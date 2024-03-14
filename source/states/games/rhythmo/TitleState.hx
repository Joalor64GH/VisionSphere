package states.games.rhythmo;

import flixel.addons.display.FlxGridOverlay;

class TitleState extends FlxState
{
    override public function create()
    {
        super.create();

        var bg:FlxSprite = FlxGridOverlay.create(20, 20);
        add(bg);

        var logoBck:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/logo'));
        logoBck.screenCenter();
        logoBck.color = FlxColor.BLACK;
        add(logoBck);

        var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/logo'));
        logo.screenCenter();
        add(logo);

        FlxTween.tween(logoBl, {y: logoBck.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
        FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

        if (logoBck.angle == -4)
            FlxTween.angle(logoBck, logoBck.angle, 4, 4, {ease: FlxEase.quartInOut});
        if (logoBck.angle == 4)
            FlxTween.angle(logoBck, logoBck.angle, -4, 4, {ease: FlxEase.quartInOut});
        if (logo.angle == -4)
            FlxTween.angle(logo, logo.angle, 4, 4, {ease: FlxEase.quartInOut});
        if (logo.angle == 4)
            FlxTween.angle(logo, logo.angle, -4, 4, {ease: FlxEase.quartInOut});
    }
}