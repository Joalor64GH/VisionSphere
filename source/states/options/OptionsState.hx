package states.options;

class OptionsState extends FlxState
{
    private var curSelected:Int = 0;
    private var grpOptions:FlxTypedGroup<Alphabet>;
    
    var options:Array<String> = [
        "Preferences",
        "Controls",
        "Miscellaneous",
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
            optionTxt.y += (100 * (i - (options.length / 2))) + 50;
            optionTxt.ID = i;
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
                    FlxG.switchState(new states.options.PreferencesState());
                case "Controls":
                    FlxG.switchState(new states.options.ControlsState());
                case "Miscellaneous":
                    FlxG.switchState(new states.options.MiscState());
                case "Exit":
                    FlxG.switchState(new states.MenuState());
            }
        }

        if (Input.is('exit')) 
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.play(Paths.sound('cancel'));
        }

        #if debug
        if (Input.is('u'))
            FlxG.switchState(new states.unused.CreditsState());
        #end
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = options.length - 1;
        else if (curSelected >= options.length)
            curSelected = 0;
        
        var something:Int = 0;

        for (item in grpOptions.members)
        {
            item.targetY = something - curSelected;
            something++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }
}