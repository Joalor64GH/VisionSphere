package states.games.clicker;

import flixel.ui.FlxButton;

class MainMenuState extends FlxState
{
    override public function create()
    {   
        var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/2048/logo'));
        logo.screenCenter(X);
        add(logo);

        var playBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Play", () ->
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.clicker.PlayState());
            });
        });
        playBtn.scale.set(2, 2);
        playBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        playBtn.label.screenCenter();
        playBtn.screenCenter(X);
        add(playBtn);

        var exitBtn:FlxButton = new FlxButton(0, playBtn.y + 70, "Exit", () ->
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(MenuState.new);
                FlxG.sound.music.volume = 0;
            });
        });
        exitBtn.scale.set(2, 2);
        exitBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        exitBtn.label.screenCenter();
        exitBtn.screenCenter(X);
        add(exitBtn);

        var funny:FlxText = new FlxText(5, FlxG.height - 24, 0, "16:9 Edition!", 12);
        funny.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(funny);

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
        FlxG.sound.playMusic(Paths.music('2048/menu'));

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var secret = Input.is('o') || (gamepad != null ? Input.gamepadIs('y') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (exit) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(MenuState.new);
                FlxG.sound.music.volume = 0;
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }

        if (secret) // the original version bleh
            CoolUtil.browserLoad('https://github.com/Joalor64GH/2048-Clicker');
    }
}