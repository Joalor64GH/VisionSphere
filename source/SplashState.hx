package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class SplashState extends FlxState
{
    var logo:FlxSprite;
    var haxeflixel:FlxSprite;

    var text:FlxText;

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

        text = new FlxText(0, haxeflixel.y, 0, "Created by Joalor64\nMade with HaxeFlixel", 12);
        text.setFormat(Paths.font('vcr.ttf'), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter(X);
        text.alpha = 0;
        add(text);

        logo = new FlxSprite().loadGraphic(Paths.image('logo'));
        logo.screenCenter(XY);
        logo.scale.set(0.6, 0.6);
        logo.alpha = 0;
        add(logo);

        FlxTween.tween(text, {alpha: 1}, 2, {ease: FlxEase.quadOut});
        FlxTween.tween(haxeflixel, {alpha: 1}, 1, {ease: FlxEase.quadOut});

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        new FlxTimer().start(5, function(tmr:FlxTimer)
        {
            FlxTween.tween(text, {alpha: 0}, 0.95, {ease: FlxEase.expoInOut});
            FlxTween.tween(haxeflixel, {alpha: 0}, 0.95, {ease: FlxEase.expoInOut});
            FlxTween.tween(logo, {alpha: 1}, 1.5, {ease: FlxEase.quadOut});
        });

        new FlxTimer().start(10, function(tmr:FlxTimer)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new PlayState());
            });
        });

        if (FlxG.keys.anyJustPressed([SPACE, ENTER]))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new PlayState());
            });
        }
    }
}