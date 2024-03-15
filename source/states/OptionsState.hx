package states;

class OptionsState extends FlxState
{
    var curSelected:Int = 0;
    var grpOptions:FlxTypedGroup<Alphabet>;
    var options:Array<String> = [
        "Preferences",
        "Language",
        "Controls",
        "Credits",
        "System Information",
        "Restart",
        "Shut Down",
        "Exit"
    ];

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        for (i in 0...options.length)
        {
            var optionTxt:Alphabet = new Alphabet(0, 0, options[i], true);
            optionTxt.screenCenter();
            optionTxt.y += (80 * (i - (options.length / 2))) + 45;
            grpOptions.add(optionTxt);
        }

        changeSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

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
                case "Preferences":
                    FlxG.switchState(PreferencesState.new);
                case "Language":
                    openSubState(new LanguageSubState());
                case "Controls":
                    openSubState(new ControlsSubState());
                case "Credits":
                    FlxG.switchState(CreditsState.new);
                case "System Information":
                    openSubState(new SystemInfoSubState());
                case "Restart":
                    openSubState(new PromptSubState("Are you sure?", () -> {
                        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
                    }, () -> {
                        closeSubState();
                    }));
                case "Shut Down":
                    openSubState(new PromptSubState("Are you sure?", () -> {
                        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
                        {
                            #if (sys || cpp)
                            Sys.exit(0);
                            #else
                            openfl.system.System.exit(0);
                            #end
                        });
                    }, () -> {
                        closeSubState();
                    }));
                case "Exit":
                    FlxG.switchState(MenuState.new);
            }
        }

        if (Input.is('exit')) 
        {
            FlxG.switchState(MenuState.new);
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }

    override function closeSubState() 
    {
        super.closeSubState();
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);

        for (num => item in grpOptions.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }
}