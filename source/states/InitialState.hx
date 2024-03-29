package states;

import djFlixel.gfx.BoxScroller;
import djFlixel.gfx.pal.Pal_DB32;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

import frontend.objects.ClickableSprite.Button;

class InitialState extends FlxState
{
    var smallLogo:FlxSprite;
    var buttons:FlxTypedGroup<Button>;

    override function create()
    {
        SaveData.init();

        #if MODS_ALLOWED
        Paths.pushGlobalMods();
        #end

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        Localization.loadLanguages();

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

        smallLogo = new FlxSprite(0, 0).loadGraphic(Paths.image('logo_small'));
        smallLogo.screenCenter(X);
        smallLogo.alpha = 0;
        add(smallLogo);

        buttons = new FlxTypedGroup<Button>();
        add(buttons);

        var options:Array<String> = ['Play', 'Website', 'Exit'];
        var optCallbacks:Array<()->Void> = [playCallback, websiteCallback, exitCallback];
        
        for (i in 0...options.length)
        {
            var daButton:Button = new Button(0, (150 * i) + 50, options[i], optCallbacks[i]);
            daButton.screenCenter();
            daButton.alpha = 0;
            buttons.add(daButton);
        }

        FlxTween.tween(smallLogo, {alpha: 1}, 1.5, {ease: FlxEase.quadOut});

        for (i in buttons)
            FlxTween.tween(i, {alpha: 1}, 1.5, {ease: FlxEase.quadOut});

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        trace("Installed Mods: " + getInstalledMods());
        trace("Current Platform: " + backend.system.PlatformUtil.getPlatform());
        trace(gamepad != null ? "Controller detected!" : "Oops! no controller detected!\nProbably because it isn't connected or you don't have one at all.");

        super.create();
    }

    private function getInstalledMods():String
    {
        var installedMods:Array<String> = Paths.getModDirectories();
        return (installedMods.length > 0) ? installedMods.join("\n") : "No mods currently installed.";
    }

    function playCallback()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
        {
            #if desktop
            UpdateState.updateCheck();
            FlxG.switchState((UpdateState.mustUpdate) ? UpdateState.new : SplashState.new);
            #else
            trace('Sorry! No update support on: ' + backend.system.PlatformUtil.getPlatform() + '!');
            FlxG.switchState(SplashState.new);
            #end
        });
    }

    function websiteCallback()
    {
        CoolUtil.browserLoad('https://github.com/Joalor64GH/VisionSphere');
    }

    function exitCallback()
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
        {
            #if (sys || cpp)
            Sys.exit(0);
            #else
            openfl.system.System.exit(0);
            #end
        });
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

        scale.set(12, 12);
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