package states;

class SplashState extends FlxState
{
    var text:FlxText;
    var logo:FlxSprite;
    var haxeflixel:FlxSprite;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titleBG'));
        add(bg);

        haxeflixel = new FlxSprite().loadGraphic(Paths.image('haxeflixel'));
        haxeflixel.screenCenter(XY);
        haxeflixel.scale.set(0.45, 0.45);
        haxeflixel.alpha = 0;
        add(haxeflixel);

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

        var spinner:FlxSprite = new FlxSprite(FlxG.width - 91, FlxG.height - 91).loadGraphic(Paths.image("loader"));
        spinner.angularVelocity = 30;
        add(spinner);

        var daText:FlxText = new FlxText(5, FlxG.height - 24, 0, "Press ENTER or SPACE to skip.", 12);
        daText.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(daText);

        Main.toast.create('Hello, ' + SaveData.settings.get("username") + '!', 0xFFFFFF00, "What's up?");

        FlxTween.tween(haxeflixel, {alpha: 1}, 1.5, {ease: FlxEase.quadOut});
        FlxTween.tween(text, {alpha: 1}, 2, {ease: FlxEase.quadOut});

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
        FlxG.sound.play(Paths.sound('startup'));
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        new FlxTimer().start(5, (timer) ->
        {
            FlxTween.tween(haxeflixel, {x: -1500, angle: 10, alpha: 0}, 0.1, {ease: FlxEase.expoInOut});
            FlxTween.tween(haxeflixel, {alpha: 0}, 0.1, {ease: FlxEase.expoInOut});
            FlxTween.tween(text, {x: -1500, angle: 10, alpha: 0}, 0.1, {ease: FlxEase.expoInOut});
            FlxTween.tween(text, {alpha: 0}, 0.1, {ease: FlxEase.expoInOut});
            FlxTween.tween(logo, {alpha: 1}, 1, {ease: FlxEase.quadOut});
        });

        new FlxTimer().start(12, (timer) ->
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(MenuState.new);
            });
        });

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var accept = Input.is('enter') || (gamepad != null ? Input.gamepadIs('a') : false);
        var accept_alt = Input.is('space') || (gamepad != null ? Input.gamepadIs('start') : false);

        if (accept || accept_alt)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(MenuState.new);
            });
        }
    }
}