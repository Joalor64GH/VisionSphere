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

        bg = new FlxSprite().loadGraphic(Paths.image('theme/${SaveData.getData('theme')}'));
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

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var up = Input.is('up') || (gamepad != null ? Input.gamepadIs('gamepad_up') : false);
        var down = Input.is('down') || (gamepad != null ? Input.gamepadIs('gamepad_down') : false);
        var left = Input.is('left') || (gamepad != null ? Input.gamepadIs('gamepad_left') : false);
        var right = Input.is('right') || (gamepad != null ? Input.gamepadIs('gamepad_right') : false);
        var accept = Input.is('accept') || (gamepad != null ? Input.gamepadIs('gamepad_accept') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (up || down)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(up ? -1 : 1);
        }

        if (accept)
        {
            FlxG.sound.play(Paths.sound('confirm'));
            switch (options[curSelected])
            {
                #if desktop
                case "Fullscreen":
                    SaveData.saveData('fullscreen', !SaveData.getData('fullscreen'));
                    FlxG.fullscreen = SaveData.getData('fullscreen');
                #end
                case "FPS Counter":
                    SaveData.saveData('fpsCounter', !SaveData.getData('fpsCounter'));
                    if (Main.fpsDisplay != null)
                        Main.fpsDisplay.visible = SaveData.getData('fpsCounter');
                case "Language":
                    openSubState(new LanguageSubState());
                case "Colorblind Filter":
                    openSubState(new FilterSubState());
            }
        }

        if (exit) 
        {
            FlxG.switchState(OptionsState.new);
            FlxG.sound.play(Paths.sound('cancel'));
        }

        if (right || left)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            switch (options[curSelected])
            {
                case "Theme":
                    switchTheme(right ? 1 : -1);
                case "Time Format":
                    switchTime(right ? 1 : -1);
            }
        }
        
        if (options[curSelected] == "Framerate")
        {
            if (right || left)
            {
                FlxG.sound.play(Paths.sound('scroll'));

                var value:Int = SaveData.getData('framerate');
                if (!left) value += (value == 240) ? 0 : 10;
                else value -= (value == 60) ? 0 : 10;
                
                Main.updateFramerate(value);
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
        var currentThemeIndex:Int = themes.indexOf(SaveData.getData('theme'));
        var newThemeIndex:Int = (currentThemeIndex + direction) % themes.length;
        if (newThemeIndex < 0)
            newThemeIndex += themes.length;

        SaveData.saveData('theme', themes[newThemeIndex]);

        bg.loadGraphic(Paths.image('theme/${SaveData.getData('theme')}'));
    }

    private function switchTime(direction:Int = 0)
    {
        var currentTimeIndex:Int = times.indexOf(SaveData.getData('timeFormat'));
        var newTimeIndex:Int = (currentTimeIndex + direction) % times.length;
        if (newTimeIndex < 0)
            newTimeIndex += times.length;

        SaveData.saveData('timeFormat', times[newTimeIndex]);
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
                daText.text = 'Use LEFT/RIGHT to change the time format. Current Format: ${SaveData.getData('timeFormat')}';
            case "Language":
                daText.text = "Changes the current language.";
            case "Theme":
                daText.text = "Use LEFT/RIGHT to change the theme.";
            case "Framerate":
                daText.text = 'Use LEFT/RIGHT to change the framerate (Max 240). Current Framerate: ${SaveData.getData('framerate')}';
            default:
                daText.text = "";
        }
    }
}