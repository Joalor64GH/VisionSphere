package states;

class OptionsState extends FlxState
{
    var options:Array<String> = ["FPS Counter", "Time Format", "Language", "Theme", "System Information", "Restart", "Shut Down"];

    var group:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;

    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/daylight'));
        add(bg);

        group = new FlxTypedGroup<FlxText>();
        add(group);

        for (i in 0...options.length)
        {
            var optionTxt:FlxText = new FlxText(20, 20 + (i * 50), 0, options[i], 32);
            optionTxt.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            optionTxt.ID = i;
            group.add(optionTxt);
        }

        changeSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(FlxG.keys.justPressed.UP ? -1 : 1);
        }

        if (FlxG.keys.justPressed.ESCAPE) 
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = group.length - 1;
        if (curSelected >= group.length)
            curSelected = 0;

        group.forEach(function(txt:FlxText) 
        {
            txt.color = (txt.ID == curSelected) ? FlxColor.GREEN : FlxColor.WHITE;
        });
    }
}