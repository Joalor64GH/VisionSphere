package states.options;

class MiscState extends FlxState
{
    private var curSelected:Int = 0;
    private var grpOptions:FlxTypedGroup<Alphabet>;

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

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        for (i in 0...options.length)
        {
            var optionTxt:Alphabet = new Alphabet(0, 0, options[i], true);
            optionTxt.screenCenter();
            optionTxt.y += (100 * (i - (options.length / 2))) + 50;
            optionTxt.ID = i;
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
                case "Back":
                    FlxG.switchState(new states.options.OptionsState());
            }
        }

        if (Input.is('exit')) 
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = options.length - 1;
        else if (curSelected >= options.length)
            curSelected = 0;
        
        var verbalase:Int = 0; // 50k

        for (item in grpOptions.members)
        {
            item.targetY = verbalase - curSelected;
            verbalase++;

            item.alpha = (targetY == 0) ? 1 : 0.6;
        }
    }
}