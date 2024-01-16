package states;

class OptionsState extends FlxState
{
    var bg:FlxSprite;
    
    var themes:Array<String> = ['daylight', 'night', 'dreamcast', 'ps3', 'xp'];
    var options:Array<String> = [
        "Fullscreen",
        "FPS Counter", 
        "Time Format", 
        "Language", 
        "Theme", 
        "System Information", 
        "Restart", 
        "Shut Down"
    ];

    var group:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;

    override public function create()
    {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image('theme/' + FlxG.save.data.theme));
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

        if (FlxG.keys.justPressed.ENTER)
        {
            switch (options[curSelected])
            {
                case "Restart":
                    openSubState(new states.substates.PromptSubState("Are you sure?", function() {
                        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
                    }, function() {
                        close();
                    }));

                case "Shut Down":
                    Sys.exit(0);
            }
        }

        if (FlxG.keys.justPressed.ESCAPE) 
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.play(Paths.sound('cancel'));
        }

        if (options[curSelected] == "Theme")
            switchTheme((FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT) ? -1 : 1);
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

    private function switchTheme(direction:Int)
    {
        var currentThemeIndex:Int = themes.indexOf(FlxG.save.data.theme);
        var newThemeIndex:Int = (currentThemeIndex + direction) % themes.length;
        if (newThemeIndex < 0)
            newThemeIndex += themes.length;

        FlxG.save.data.theme = themes[newThemeIndex];

        bg.loadGraphic(Paths.image('theme/' + FlxG.save.data.theme));
    }
}