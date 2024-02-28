package states.games.jta;

import flixel.ui.FlxButton;

class MainMenuState extends FlxState
{
    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/jta/bgMain'));
        bg.screenCenter();
        add(bg);

        var logoBl:FlxSprite = new FlxSprite(0, 230).loadGraphic(Paths.image('game/jta/logo'));
        logoBl.color = FlxColor.BLACK;
        logoBl.screenCenter(X);
        logoBl.scale.set(3, 3);
        logoBl.angle = -4;
        add(logoBl);

        var logo:FlxSprite = new FlxSprite(0, 215).loadGraphic(Paths.image('game/jta/logo'));
        logo.screenCenter(X);
        logo.scale.set(3, 3);
        logo.angle = -4;
        add(logo);

        new FlxTimer().start(0.01, (tmr:FlxTimer) ->
        {
            if (logo.angle == -4)
                FlxTween.angle(logo, logo.angle, 4, 4, {ease: FlxEase.quartInOut});
            if (logo.angle == 4)
                FlxTween.angle(logo, logo.angle, -4, 4, {ease: FlxEase.quartInOut});
            
            if (logoBl.angle == -4)
                FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
            if (logoBl.angle == 4)
                FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
        }, 0);

        var playBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Play", () ->
        {
            FlxG.sound.play(Paths.sound('jta/play'));
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.jta.LevelSelectState());
            });
        });
        playBtn.scale.set(2, 2);
        playBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        playBtn.label.screenCenter();
        playBtn.screenCenter(X);
        add(playBtn);

        var exitBtn:FlxButton = new FlxButton(0, playBtn.y + 70, "Exit", () ->
        {
            FlxG.sound.play(Paths.sound('jta/exit'));
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(new states.MenuState());
            });
        });
        exitBtn.scale.set(2, 2);
        exitBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        exitBtn.label.screenCenter();
        exitBtn.screenCenter(X);
        add(exitBtn);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }
}