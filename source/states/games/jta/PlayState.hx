package states.games.jta;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera;

import Props.Coin;
import Props.Flag;
import Props.Player;
import Props.Spike;

class PlayState extends FlxState
{
    public static var instance:PlayState;

    var map:FlxOgmo3Loader;
    var walls:FlxTilemap;

    var player:Player;
    var coin:FlxTypedGroup<Coin>;
    var spike:FlxTypedGroup<Spike>;
    var flag:Flag;

    var jumpTimer:Float = 0;
    var jumping:Bool = false;

    var camHUD:FlxCamera;

    override public function create()
    {
        super.create();

        instance = this;

        openfl.system.System.gc();

        camHUD = new FlxCamera();
        camHUD.bgColor = 0;
        FlxG.cameras.add(camHUD, false);

        FlxG.camera.zoom = 2.25;

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF00FFFF);
        bg.scrollFactor.set();
        add(bg);

        map = new FlxOgmo3Loader(Paths.file('data/jta/level.ogmo'), Paths.json('jta/lev1'));
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
        FlxG.camera.follow(player, PLATFORMER);

        FlxG.overlap(player, coin, touchCoin);
        FlxG.overlap(player, flag, touchFlag);
        FlxG.overlap(player, spike, touchSpike);

        player.animation.play((player.velocity.x != 0) ? "walk" : "idle");
        player.velocity.x = (Input.is('left') || Input.is('left_alt')) ? -150 : (Input.is('right') || Input.is('right_alt')) ? 150 : 0;

        if (player.velocity.x != 0)
            player.flipX = player.velocity.x < 0;

        if (jumping && !(Input.is('up') || Input.is('up_alt') || Input.is('accept_alt')))
            jumping = false;

        if (player.isTouching(DOWN) && !jumping)
            jumpTimer = 0;

        if (jumpTimer >= 0 && (Input.is('up') || Input.is('up_alt') || Input.is('accept_alt')))
        {
            jumping = true;
            jumpTimer += elapsed;

            new FlxTimer().start(0.01, function(tmr:FlxTimer)
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
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }

        if (Input.is('r'))
            FlxG.resetState();
    }

    private function placeEntities(entity:EntityData)
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
                flag.x = x;
                flag.y = y;
            case "spike":
                spike.add(new Spike(x, y));
        }
    }
}