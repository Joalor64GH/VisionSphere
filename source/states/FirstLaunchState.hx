package states;

class FirstLaunchState extends FlxState
{
    override public function create()
    {
        var text:FlxText = new FlxText(0, 0, 0, "Hey you!\nWould you like to set your options first?\nY - Yes (Recommended) / N - No", 12);
        text.setFormat(Paths.font('vcr.ttf'), 45, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter();
        add(text);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        if (Input.is('y') || Input.is('n'))
            FlxG.switchState(Input.is('y') ? new states.OptionsState() : new states.SplashState());

        super.update(elapsed);
    }
}