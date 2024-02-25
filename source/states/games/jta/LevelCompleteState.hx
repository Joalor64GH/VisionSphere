package states.games.jta;

class LevelCompleteState extends FlxState
{
    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var theText:FlxText = new FlxText(0, 0, 0, "Level Complete!\nPress any button to continue.", 50);
        theText.screenCenter();
        add(theText);

        FlxG.sound.play(Paths.sound('jta/win'));
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('any'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }
}