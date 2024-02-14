package states.games.clicker;

import flixel.ui.FlxButton;

class MainMenuState extends FlxState
{
    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        
        var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/2048/logo'));
        logo.screenCenter(X);
        add(logo);

        var playBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Play", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.games.clicker.PlayState());
            });
        });
        playBtn.scale.set(2, 2);
        playBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        playBtn.label.screenCenter();
        playBtn.screenCenter(X);
        add(playBtn);

        var exitBtn:FlxButton = new FlxButton(0, playBtn.y + 70, "Exit", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
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

        if (Input.is('exit')) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
                FlxG.sound.music.volume = 0;
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }
}