package states;

class OptionsState extends FlxState
{
    var bg:FlxSprite;
    var times:Array<String> = ['%r', '%T'];
    var themes:Array<String> = ['daylight', 'night', 'dreamcast', 'ps3', 'xp'];
    var options:Array<String> = [
        #if desktop
        "Fullscreen",
        #end
        "FPS Counter", 
        "Time Format", 
        "Language", 
        "Theme", 
        "Credits",
        "System Information", 
        "Restart", 
        "Shut Down"
    ];

    var group:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;
    var daText:FlxText;

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
        
        daText = new FlxText(5, FlxG.height - 24, 0, "", 12);
        daText.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(daText);

        changeSelection();
        switchTheme();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        switch (options[curSelected])
        {
            #if desktop
            case "Fullscreen":
                daText.text = "Toggles fullscreen.";
            #end
            case "FPS Counter":
                daText.text = "Toggles FPS counter.";
            case "Time Format":
                daText.text = "Use LEFT/RIGHT to change the time format. Current Format: " + FlxG.save.data.timeFormat;
            case "Language":
                daText.text = "Changes the current language.";
            case "Theme":
                daText.text = "Use LEFT/RIGHT to change the theme.";
            default:
                daText.text = "";
        }

        if (Input.is('up') || Input.is('down'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (Input.is('accept'))
        {
            FlxG.sound.play(Paths.sound('confirm'));
            switch (options[curSelected])
            {
                #if desktop
                case "Fullscreen":
                    FlxG.save.data.fullscreen = !FlxG.save.data.fullscreen;
                    FlxG.fullscreen = FlxG.save.data.fullscreen;
                #end
                case "FPS Counter":
                    FlxG.save.data.fpsCounter = !FlxG.save.data.fpsCounter;
                    if (Main.fpsDisplay != null)
                        Main.fpsDisplay.visible = FlxG.save.data.fpsCounter;
                case "Language":
                    openSubState(new states.substates.LanguageSubState());
                case "Credits":
                    FlxG.switchState(new states.CreditsState());
                case "System Information":
                    openSubState(new states.substates.SystemInfoSubState());
                case "Restart":
                    openSubState(new states.substates.PromptSubState("Are you sure?", function() {
                        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
                    }, function() {
                        closeSubState();
                    }));
                case "Shut Down":
                    FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() 
                    { 
                        #if (sys || cpp)
                        Sys.exit(0);
                        #else 
                        openfl.system.System.exit(0);
                        #end
                    }, false);
            }
        }

        if (Input.is('exit')) 
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.play(Paths.sound('cancel'));
        }

        if (Input.is('right') || Input.is('left'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            switch (options[curSelected])
            {
                case "Theme":
                    switchTheme(Input.is('right') ? 1 : -1);
                case "Time Format":
                    switchTime(Input.is('right') ? 1 : -1);
            }
        }

        #if debug
        if (Input.is('k'))
            FlxG.switchState(new states.KeybindsState());
        #end
    }

    override function closeSubState()
    {
        super.closeSubState();
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = group.length - 1;
        if (curSelected >= group.length)
            curSelected = 0;

        switch (options[curSelected])
        {
            #if desktop
            case "Fullscreen":
                daText.text = "Toggles fullscreen.";
            #end
            case "FPS Counter":
                daText.text = "Toggles FPS counter.";
            case "Time Format":
                daText.text = "Use LEFT/RIGHT to change the time format. Current Format: " + FlxG.save.data.timeFormat;
            case "Language":
                daText.text = "Changes the current language.";
            case "Theme":
                daText.text = "Use LEFT/RIGHT to change the theme.";
            default:
                daText.text = "";
        }

        group.forEach(function(txt:FlxText) 
        {
            txt.color = (txt.ID == curSelected) ? FlxColor.GREEN : FlxColor.WHITE;
        });
    }

    private function switchTheme(direction:Int = 0)
    {
        var currentThemeIndex:Int = themes.indexOf(FlxG.save.data.theme);
        var newThemeIndex:Int = (currentThemeIndex + direction) % themes.length;
        if (newThemeIndex < 0)
            newThemeIndex += themes.length;

        FlxG.save.data.theme = themes[newThemeIndex];

        bg.loadGraphic(Paths.image('theme/' + FlxG.save.data.theme));
    }

    // yes i copied the theme switching code
    private function switchTime(direction:Int = 0)
    {
        var currentTimeIndex:Int = times.indexOf(FlxG.save.data.timeFormat);
        var newTimeIndex:Int = (currentTimeIndex + direction) % times.length;
        if (newTimeIndex < 0)
            newTimeIndex += times.length;

        FlxG.save.data.timeFormat = times[newTimeIndex];
    }
}