package states;

class OptionsState extends FlxState
{
    var options:Array<String> = ["FPS Counter", "Time Format", "Language", "Theme", "System Information", "Restart", "Shut Down"];

    var group:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;
    var text:FlxText;

    override public function create()
    {
        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}