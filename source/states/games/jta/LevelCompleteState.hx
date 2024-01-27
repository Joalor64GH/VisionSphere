package states.games.jta;

class LevelCompleteState extends FlxState
{
    override public function create()
    {
        super.create();

        var theText:FlxText = new FlxText(0, 0, 0, "Level Complete!\nPress any button to continue.", 12);
        theText.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        theText.screenCenter();
        add(theText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('any'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }
}