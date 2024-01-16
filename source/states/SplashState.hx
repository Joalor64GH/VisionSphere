package states;

class SplashState extends FlxState
{
    var logo:FlxSprite;
    var text:FlxText;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titleBG'));
        add(bg);

        text = new FlxText(0, 0, 0, "Created by Joalor64\nMade with HaxeFlixel", 12);
        text.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter(XY);
        text.alpha = 0;
        add(text);

        logo = new FlxSprite().loadGraphic(Paths.image('logo'));
        logo.screenCenter(XY);
        logo.scale.set(0.6, 0.6);
        logo.alpha = 0;
        add(logo);

        add({
            var daText = new FlxText(5, FlxG.height - 24, 0, "Press ENTER or SPACE to skip.", 12);
            daText.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            daText;
        });

        FlxTween.tween(text, {alpha: 1}, 2, {ease: FlxEase.quadOut});

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
        FlxG.sound.play(Paths.sound('startup'));
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        new FlxTimer().start(5, function(tmr:FlxTimer)
        {
            FlxTween.tween(text, {x: -1500, angle: 10, alpha: 0}, 0.1, {ease: FlxEase.expoInOut});
            FlxTween.tween(text, {alpha: 0}, 0.1, {ease: FlxEase.expoInOut});

            FlxTween.tween(logo, {alpha: 1}, 1, {ease: FlxEase.quadOut});
        });

        new FlxTimer().start(12, function(tmr:FlxTimer)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
        });

        if (FlxG.keys.anyJustPressed([SPACE, ENTER]))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
        }
    }
}