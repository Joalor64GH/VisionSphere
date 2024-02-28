package states.unused;

import flixel.input.keyboard.FlxKey;

using StringTools;

class KeybindsState extends FlxState
{
    var grpControls:FlxTypedGroup<Alphabet>;
    var controlsStrings:Array<String> = [];
    var curSelected:Int = 0;

    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        
        trace("this is old and scuffed why are you here");
        
        controlsStrings = CoolUtil.getText(Paths.txt('controls'));

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
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

        for (num => item in grpControls.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    private function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, controlsStrings.length - 1);
    }
}