package states.options;

class MiscState extends FlxState
{
    var curSelected:Int = 0;
    var grpOptions:FlxTypedGroup<Alphabet>;
    var options:Array<String> = [
        "Credits",
        "System Information",
        "Restart",
        "Shut Down",
        "Back"
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
            optionTxt.y += (100 * (i - (options.length / 2))) + 50;
            grpOptions.add(optionTxt);
        }

        changeSelection();
    }

    override function closeSubState() 
    {
        super.closeSubState();
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
                case "Credits":
                    FlxG.switchState(CreditsState.new);
                case "System Information":
                    openSubState(new states.substates.SystemInfoSubState());
                case "Restart":
                    openSubState(new states.substates.PromptSubState("Are you sure?", () -> {
                        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
                    }, () -> {
                        closeSubState();
                    }));
                case "Shut Down":
                    openSubState(new states.substates.PromptSubState("Are you sure?", () -> {
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
                case "Back":
                    FlxG.switchState(OptionsState.new);
            }
        }

        if (Input.is('exit')) 
        {
            FlxG.switchState(OptionsState.new);
            FlxG.sound.play(Paths.sound('cancel'));
        }
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