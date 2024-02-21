package states.options;

import display.Colorblind;

class PreferencesState extends FlxState
{
    var bg:FlxSprite;
    var times:Array<String> = ['%r', '%T'];
    var filters:Array<String> = ['None', 'Deuteranopia', 'Protanopia', 'Tritanopia'];
    var themes:Array<String> = ['daylight', 'night', 'dreamcast', 'ps3', 'xp'];
    var options:Array<String> = [
        #if desktop
        "Fullscreen",
        #end
        "FPS Counter", 
        "Colorblind Filter",
        "Antialiasing",
        "Time Format", 
        "Framerate",
        "Language", 
        "Theme"
    ];

    var fpsMin:Int = 60;
    var fpsMax:Int = 240;

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
                    openSubState(new states.substates.LanguageSubState());
                case "Antialiasing":
                    SaveData.antialiasing = !SaveData.antialiasing;
                    FlxSprite.defaultAntialiasing = SaveData.antialiasing;
            }
        }

        if (Input.is('exit')) 
        {
            FlxG.switchState(new states.options.OptionsState());
            FlxG.sound.play(Paths.sound('cancel'));
            SaveData.saveSettings();
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
                case "Colorblind Filter":
                    switchFilter(Input.is('right') ? 1 : -1);
            }
        }
        
        // i know i could've used another function, but this still works
        if (options[curSelected] == "Framerate")
        {
            if (Input.is('right') || Input.is('left'))
            {
                FlxG.updateFramerate = SaveData.framerate;
                FlxG.drawFramerate = SaveData.framerate;
                FlxG.game.focusLostFramerate = SaveData.framerate;
                openfl.Lib.current.stage.frameRate = SaveData.framerate;
                if (!Input.is('left'))
                {
                    if (SaveData.framerate > fpsMax)
                        SaveData.framerate = fpsMin;
                    else
                        SaveData.frameRate += 10;
                }
                else
                {
                    if (SaveData.framerate < fpsMin)
                        SaveData.framerate = fpsMax;
                    else
                        SaveData.frameRate -= 10;
                }
            }
        }
    }

    override function closeSubState()
    {
        super.closeSubState();
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = options.length - 1;
        else if (curSelected >= options.length)
            curSelected = 0;

        updateText();
        
        var ratio:Int = 0; // stay mad

        for (item in group.members)
        {
            item.targetY = ratio - curSelected;
            ratio++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
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

    private function switchFilter(direction:Int = 0)
    {
        var currentFilterIndex:Int = filters.indexOf(SaveData.colorBlindFilter);
        var newFilterIndex:Int = (currentFilterIndex + direction) % filters.length;
        if (newFilterIndex < 0)
            newFilterIndex += filters.length;

        SaveData.colorBlindFilter = filters[newFilterIndex];

        Colorblind.updateFilter();
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
                daText.text = "In case you're colorblind. Current Filter: " + SaveData.colorBlindFilter;
            case "Time Format":
                daText.text = "Use LEFT/RIGHT to change the time format. Current Format: " + SaveData.timeFormat;
            case "Language":
                daText.text = "Changes the current language.";
            case "Theme":
                daText.text = "Use LEFT/RIGHT to change the theme.";
            case "Framerate":
                daText.text = "Use LEFT/RIGHT to change the framerate (Max 240). Current Framerate: " + SaveData.framerate;
            case "Antialiasing":
                daText.text = "If disabled, increases performance, at the cost of sharper visuals.";
            default:
                daText.text = "";
        }
    }
}