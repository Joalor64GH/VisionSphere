package states.games;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera;

class MainMenuState extends FlxState
{
    var logo:FlxSprite;

    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/jta/bgMain'));
        add(bg);

        logo = new FlxSprite(0, 220).loadGraphic(Paths.image('game/jta/logo'));
        logo.screenCenter(X);
        logo.scale.set(4, 4);
        add(logo);

        logoTween();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('accept'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.games.JourneyThroughAubekhia.PlayState());
            });
            FlxG.sound.play(Paths.sound('jta/play'));
        }
        else if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }

    private function logoTween()
    {
        logo.angle = -4;

        new FlxTimer().start(0.01, function(tmr:FlxTimer) 
        {
            if (logo.angle == -4)
                FlxTween.angle(logo, logo.angle, 4, 4, {ease: FlxEase.quartInOut});
            if (logo.angle == 4)
                FlxTween.angle(logo, logo.angle, -4, 4, {ease: FlxEase.quartInOut});
        }, 0);
    }
}

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
                FlxG.switchState(new states.games.JourneyThroughAubekhia.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }

        if (Input.is('r'))
            FlxG.resetState();
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
                flag.x = x;
                flag.y = y;
            case "spike":
                spike.add(new Spike(x, y));
        }
    }
}

class LevelCompleteState extends FlxState
{
    // wip
}

class GameOverStatee extends FlxState
{
    // wip
}


class Coin extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('coin'), true, 16, 16);

        animation.add("floating", [0, 1, 2, 1], 12, true);
        animation.play("floating");
    }

    override function kill()
    {
        alive = false;
        FlxTween.tween(this, {alpha: 0, y: y - 16}, 0.22, {
            ease: FlxEase.circOut, onComplete: function(_) {
                exists = false;
            }
        });
    }
}

class Flag extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('flag-AB'), true, 16, 16);

        animation.add("wave", [1, 2, 3, 4, 5, 0], 12, true);
        animation.add("stop", [0], 12, true);
        animation.play("wave");
    }
}

class Player extends FlxSprite
{
    public var direction:Vector = new Vector(0, 0);
    public var speed:Vector = new Vector(0, 0);

    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic(Paths.image('game/jta/player'), true, 16, 16);

        animation.add("idle", [0], 1);
        animation.add("walk", [1, 0], 12);
        animation.play("idle");
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        this.x += direction.dx * speed.dx;
        this.y += direction.dy * speed.dy;
    }
}

class Spike extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('spike'), true, 16, 16);

        animation.add("idle", [0], 1, true);
        animation.play("idle");
    }
}

/**
 * A two-dimensional vector.
 * @author khuonghoanghuy
 */

class Vector
{
    public var dx:Float;
    public var dy:Float;

    public function new(dx:Float, dy:Float)
    {
        this.dx = dx;
        this.dy = dy;
    }
}