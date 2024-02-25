package states.games.clicker;

class WinState extends FlxState
{
    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        
        var winSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/2048/win'));
        winSpr.screenCenter();
        add(winSpr);

        var text:FlxText = new FlxText(0, 0, 0, "You win!\nPress any key to continue.", 12);
        text.setFormat(Paths.font('vcr.ttf'), 55, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter(X);
        add(text);

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
        FlxG.sound.play(Paths.sound('2048/win'));

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('any'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.clicker.MainMenuState());
            });
        }
    }
}