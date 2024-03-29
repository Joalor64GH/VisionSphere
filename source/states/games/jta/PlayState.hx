package states.games.jta;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tile.FlxTilemap;
import flixel.sound.FlxSound;
import flixel.FlxCamera;

import states.games.jta.Coin;
import states.games.jta.Flag;
import states.games.jta.Player;
import states.games.jta.Spike;

class PlayState extends FlxState
{
    var lev:Int = 1;

    var map:FlxOgmo3Loader;
    var walls:FlxTilemap;

    var player:Player;
    var coin:FlxTypedGroup<Coin>;
    var spike:FlxTypedGroup<Spike>;
    var flag:Flag;

    var jumpTimer:Float = 0;
    var jumping:Bool = false;
    
    var coinSnd:FlxSound;

    public function new(lev:Int)
    {
        super();
        this.lev = lev;
    }

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        openfl.system.System.gc();

        FlxG.camera.zoom = 2.95;

        coinSnd = FlxG.sound.load(Paths.sound('jta/coin'), 1);

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF00FFFF);
        bg.scrollFactor.set();
        add(bg);

        map = new FlxOgmo3Loader(Paths.file('data/jta/level.ogmo'), Paths.json('jta/lev' + lev));
        walls = map.loadTilemap(Paths.image('game/jta/tilemap_1'), 'walls');
        walls.follow();
        walls.setTileProperties(1, NONE);
        walls.setTileProperties(2, ANY);
        add(walls);

        coin = new FlxTypedGroup<Coin>();
        add(coin);

        flag = new Flag();
        add(flag);

        spike = new FlxTypedGroup<Spike>();
        add(spike);

        map.loadEntities(placeEntities, 'entity');
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        FlxG.collide(player, walls);
        FlxG.camera.follow(player, LOCKON);

        FlxG.overlap(player, coin, touchCoin);
        FlxG.overlap(player, flag, touchFlag);
        FlxG.overlap(player, spike, touchSpike);

        player.animation.play((player.velocity.x != 0) ? "walk" : "idle");
        player.velocity.x = Input.is('left', PRESSED) ? -150 : Input.is('right', PRESSED) ? 150 : 0;

        if (player.velocity.x != 0)
            player.flipX = player.velocity.x < 0;

        if (jumping && !Input.is('up'))
            jumping = false;

        if (player.isTouching(DOWN) && !jumping)
            jumpTimer = 0;

        if (jumpTimer >= 0 && Input.is('up'))
        {
            jumping = true;
            jumpTimer += elapsed;
            new FlxTimer().start(0.01, (timer) ->
            {
                FlxG.sound.play(Paths.sound('jta/jump'));
            });
        }
        else
            jumpTimer = -1;

        if (jumpTimer > 0 && jumpTimer < 0.25)
            player.velocity.y = -300;

        if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }

        if (Input.is('r'))
            FlxG.resetState();
    }

    override public function destroy()
    {
        super.destroy();
    }

    function placeEntities(entity:EntityData)
    {
        var x = entity.x;
        var y = entity.y;

        switch (entity.name)
        {
            case "player":
                add(player = new Player(x, y));
                player.maxVelocity.y = 300;
                player.acceleration.y = 900;
                player.setPosition(x, y);
            case "coin":
                coin.add(new Coin(x, y));
            case "flag":
                flag.setPosition(x, y);
            case "spike":
                spike.add(new Spike(x, y));
        }
    }

    private function touchCoin(player:Player, coin:Coin)
    {
        if (player.alive && player.exists && coin.alive && coin.exists)
        {
            coin.kill();
            coinSnd.play(true);
        }
    }

    private function touchFlag(player:Player, flag:Flag)
    {
        if (player.alive && player.exists && flag.alive && flag.exists)
        {
            flag.animation.play("stop");
            FlxG.switchState(new states.games.jta.LevelCompleteState());
        }
    }

    private function touchSpike(player:Player, spike:Spike)
    {
        if (player.alive && player.exists && spike.alive && spike.exists)
        {
            player.kill();
            openSubState(new states.games.jta.GameOverSubState());
        }
    }
}