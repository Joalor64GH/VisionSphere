package states;

using StringTools;

class CreditState extends FlxState
{
    private var credsGrp:FlxTypedGroup<Alphabet>;

    var credits:Array<String> = [];
    var curSelected:Int = 0;

    override public function create()
    {
        // this is so swagger
        credits = CoolUtil.getText(Paths.txt('credits'));

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + FlxG.save.data.theme));
        add(bg);

        credsGrp = new FlxTypedGroup<Alphabet>();
        add(credsGrp);

        for (i in 0...credits.length)
        {
            var creditsText:Alphabet = new Alphabet(90, 320, credits[i], true);
            creditsText.isMenuItem = true;
            creditsText.targetY = i;
            credsGrp.add(creditsText);
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
            FlxG.switchState(new states.OptionsState());
        }
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = coolGrp.length - 1;
        if (curSelected >= coolGrp.length)
            curSelected = 0;
        
        var something:Int = 0;

        for (item in credsGrp.members)
        {
            item.targetY = something - curSelected;
            something++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }
}