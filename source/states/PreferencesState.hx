package states;

class PreferencesState extends FlxState
{
    var bg:FlxSprite;
    
    var times:Array<String> = ['%r', '%T'];
    var themes:Array<String> = ['daylight', 'night', 'dreamcast', 'ps3', 'xp'];
    var options:Array<String> = [
        #if desktop
        "Fullscreen",
        #end
        "FPS Counter", 
        "Colorblind Filter",
        "Time Format", 
        "Framerate",
        "Language", 
        "Theme"
    ];

    var group:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var daText:FlxText;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        bg = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        group = new FlxTypedGroup<Alphabet>();
        add(group);

        for (i in 0...options.length)
        {
            var optionTxt:Alphabet = new Alphabet(90, 320, options[i], true);
            optionTxt.isMenuItem = true;
            optionTxt.ID = i - curSelected;
            group.add(optionTxt);
        }
        
        daText = new FlxText(5, FlxG.height - 24, 0, "", 12);
        daText.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(daText);

        changeSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        updateText();

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
                    SaveData.fullscreen = !SaveData.fullscreen;
                    FlxG.fullscreen = SaveData.fullscreen;
                #end
                case "FPS Counter":
                    SaveData.fpsCounter = !SaveData.fpsCounter;
                    if (Main.fpsDisplay != null)
                        Main.fpsDisplay.visible = SaveData.fpsCounter;
                case "Language":
                    openSubState(new LanguageSubState());
                case "Colorblind Filter":
                    openSubState(new FilterSubState());
            }
        }

        if (Input.is('exit') || Input.is('backspace')) 
        {
            FlxG.switchState(OptionsState.new);
            FlxG.sound.play(Paths.sound('cancel'));
            if (!Input.is('backspace'))
            {
                SaveData.saveSettings();
                trace('settings saved!');
            }
            else
                trace('settings not saved!');
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
        
        // i know i could've used another function, but this still works
        if (options[curSelected] == "Framerate")
        {
            if (Input.is('right') || Input.is('left'))
            {
                FlxG.sound.play(Paths.sound('scroll'));
                if (!Input.is('left'))
                    SaveData.framerate += (SaveData.framerate == 240) ? 0 : 10;
                else
                    SaveData.framerate -= (SaveData.framerate == 60) ? 0 : 10;
                
                Main.updateFramerate(SaveData.framerate);
            }
        }

        for (num => item in group.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    override function closeSubState() 
    {
        super.closeSubState();
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);
        updateText();
    }

    private function switchTheme(direction:Int = 0)
    {
        var currentThemeIndex:Int = themes.indexOf(SaveData.theme);
        var newThemeIndex:Int = (currentThemeIndex + direction) % themes.length;
        if (newThemeIndex < 0)
            newThemeIndex += themes.length;

        SaveData.theme = themes[newThemeIndex];

        bg.loadGraphic(Paths.image('theme/' + SaveData.theme));
    }

    private function switchTime(direction:Int = 0)
    {
        var currentTimeIndex:Int = times.indexOf(SaveData.timeFormat);
        var newTimeIndex:Int = (currentTimeIndex + direction) % times.length;
        if (newTimeIndex < 0)
            newTimeIndex += times.length;

        SaveData.timeFormat = times[newTimeIndex];
    }

    function updateText()
    {
        switch (options[curSelected])
        {
            #if desktop
            case "Fullscreen":
                daText.text = "Toggles fullscreen.";
            #end
            case "FPS Counter":
                daText.text = "Toggles FPS counter.";
            case "Colorblind Filter":
                daText.text = "In case you're colorblind.";
            case "Time Format":
                daText.text = "Use LEFT/RIGHT to change the time format. Current Format: " + SaveData.timeFormat;
            case "Language":
                daText.text = "Changes the current language.";
            case "Theme":
                daText.text = "Use LEFT/RIGHT to change the theme.";
            case "Framerate":
                daText.text = "Use LEFT/RIGHT to change the framerate (Max 240). Current Framerate: " + SaveData.framerate;
            default:
                daText.text = "";
        }
    }
}