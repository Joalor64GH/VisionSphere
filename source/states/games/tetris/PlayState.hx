package states.games.tetris;

import djFlixel.gfx.BoxScroller;
import djFlixel.gfx.pal.Pal_DB32;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

import states.games.tetris.GameGrid;

import states.games.tetris.Point;
import states.games.tetris.Piece;
import states.games.tetris.PieceQueue;

class PlayState extends FlxState
{
    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var colors = FlxColor.gradient(0xFF0080FF, 0xFF200050, 12);
        var parallaxes:Array<BoxScroller> = [];
        var h0 = 48;
        var inc = FlxG.height / (colors.length - 1);
        for (i in 0...colors.length)
        {
            var b = new BoxScroller("assets/images/stripe.png", 0, 0, FlxG.width);
            b.scale.set(3.5, 3.5);
            b.color = colors[i];
            b.autoScrollX = -(0.2 + (i * 0.15)) * (1 + (i * 0.06));
            b.randomOffset();
            parallaxes.push(b);
            b.x = 0;
            b.y = (inc * i) - 24;
            add(b);
        }

        var em = new FlxEmitter(1280, 128, 256);
        em.height = 64;
        em.particleClass = Balls;
        em.launchMode = FlxEmitterMode.SQUARE;
        em.velocity.set(-40, 0, -70);
        em.start(false, 0.3);
        em.lifespan.set(99);
        add(em);

        var text:FlxText = new FlxText(0, 0, 0, "hello world\nthis unfinished lmao", 12);
        text.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter();
        add(text);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit')) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }
}

class Balls extends FlxParticle // https://youtu.be/mM4jKMHuWtU?si=5dB-Z3blV3PK-lsC
{
    static var wMin = 32;
    static var wMax = 64;
    static var FREQ = 0.12;
    static var inc = 0.4;

    var c:Float = 0;
    var t:Float = 0;
    var w:Float = 0;

    public function new()
    {
        super();

        loadGraphic(Paths.image("baller"), true, 16, 16, true);
        animation.add("main", [0, 1, 2, 3, 4, 5, 6], 14);
        lifespan = 0;

        if (FlxG.random.bool())
            replaceColor(Pal_DB32.COL[28], Pal_DB32.COL[26]);
        else if (FlxG.random.bool())
        {
            replaceColor(Pal_DB32.COL[28], Pal_DB32.COL[17]);
            replaceColor(Pal_DB32.COL[8], Pal_DB32.COL[19]);
        }

        scale.set(8, 8);
    }

    override public function onEmit():Void
    {
        super.onEmit();

        animation.play("main");
        c = Math.random() * Math.PI;
        w = FlxG.random.int(wMin, wMax);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if ((t += elapsed) > FREQ)
        {
            t = 0;
            velocity.y = Math.sin(c) * w;
            c += inc;

            if (x > FlxG.width)
                kill();
        }
    }
}