package states;

import util.PlatformUtil;

import djFlixel.gfx.BoxScroller;
import djFlixel.gfx.pal.Pal_DB32;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class BootState extends FlxState
{
    var text:FlxText;

    override function create()
    {
        Plugins.init();
        SaveData.init();

        #if MODS_ALLOWED
        Paths.pushGlobalMods();
        #end
        
        Localization.loadLanguages(['de', 'en', 'es', 'fr', 'it', 'pt']);

        FlxG.sound.muteKeys = [NUMPADZERO];
        FlxG.sound.volumeDownKeys = [NUMPADMINUS];
        FlxG.sound.volumeUpKeys = [NUMPADPLUS];

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

        text = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, "Loading... Please Wait :)", 12);
        text.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.scrollFactor.x = -1;
        add(text);

        new FlxTimer().start(9, function(timer)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                #if desktop
                states.UpdateState.updateCheck();
                FlxG.switchState((states.UpdateState.mustUpdate) ? new states.UpdateState() : new states.SplashState());
                #else
                trace('Sorry! No update support on: ' + PlatformUtil.getPlatform() + '!')
                FlxG.switchState(new states.SplashState());
                #end
            });
        });

        super.create();
    }

    override function update(elapsed)
    {
        super.update(elapsed);

        if (text.x + text.width < 0)
            text.x = FlxG.width;

        text.y = FlxG.height / 2 + 40 * Math.sin(2 * text.x);
    }
}

// https://youtu.be/mM4jKMHuWtU?si=5dB-Z3blV3PK-lsC
class Balls extends FlxParticle
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