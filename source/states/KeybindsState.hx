package states;

import flixel.input.keyboard.FlxKey;

using StringTools;

// scuffed
// it's just copy of CreditsState for now
class KeybindsState extends FlxState
{
    private var grpControls:FlxTypedGroup<Alphabet>;

    var controlsStrings:Array<String> = [];
    var curSelected:Int = 0;

    override public function create()
    {
        controlsStrings = CoolUtil.getText(Paths.txt('controls'));

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + (FileSystem.exists(Paths.image('theme/' + FlxG.save.data.theme))) ? FlxG.save.data.theme : 'daylight'));
        add(bg);

        grpControls = new FlxTypedGroup<Alphabet>();
        add(grpControls);

        for (i in 0...controlsStrings.length)
        {
            if (controlsStrings[i].indexOf('set') != -1)
            {
                var controlLabel:Alphabet = new Alphabet(90, 320, controlsStrings[i].substring(3) + ': ' + controlsStrings[i + 1], true);
                controlLabel.isMenuItem = true;
                controlLabel.targetY = i;
                grpControls.add(controlLabel);
            }
        }

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('up') || Input.is('down'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (Input.is('exit'))
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.switchState(new states.MenuState());
        }
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = grpControls.length - 1;
        if (curSelected >= grpControls.length)
            curSelected = 0;
        
        var something:Int = 0;

        for (item in grpControls.members)
        {
            item.targetY = something - curSelected;
            something++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }
}