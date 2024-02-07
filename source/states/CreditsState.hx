package states;

using StringTools;

class CreditsState extends FlxState
{
    private var credsGrp:FlxTypedGroup<Alphabet>;

    var credits:Array<CreditsMetadata> = [];
    var curSelected:Int = 0;
    var descTxt:FlxText;

    override public function create()
    {
        // this is even swaggier
        var initCredits = CoolUtil.getText(Paths.txt('credits'));

        if (FileSystem.exists(Paths.txt('credits')))
        {
            initCredits = CoolUtil.getText(Paths.txt('credits'));

            for (i in 0...initCredits.length)
            {
                initCredits[i] = initCredits[i].trim();
            }
        }
        else
        {
            trace("Oops! Could not find 'credits.txt'!");
            trace("Replacing with normal credits...");
            initCredits = "person:what they did idk\n
                engine start:no problem".trim().split('\n');
            
            for (i in 0...initCredits.length)
            {
                initCredits[i] = initCredits[i].trim();
            }
        }

        for (i in 0...initCredits.length)
        {
            var data:Array<String> = initCredits[i].split(':');
            credits.push(new CreditsMetadata(data[0], data[1]));
        }

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        credsGrp = new FlxTypedGroup<Alphabet>();
        add(credsGrp);

        for (i in 0...credits.length)
        {
            var creditsText:Alphabet = new Alphabet(90, 320, credits[i].name, true);
            creditsText.isMenuItem = true;
            creditsText.targetY = i - curSelected;
            credsGrp.add(creditsText);
        }

        descTxt = new FlxText(50, 600, 1180, "", 32);
        descTxt.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        descTxt.borderSize = 24;
        add(descTxt);

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
            curSelected = credsGrp.length - 1;
        if (curSelected >= credsGrp.length)
            curSelected = 0;

        descTxt.text = credits[curSelected].desc;
        
        var something:Int = 0;

        for (item in credsGrp.members)
        {
            item.targetY = something - curSelected;
            something++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }
}

class CreditsMetadata
{
    public var name:String = "";
    public var desc:String = "";

    public function new(name:String, desc:String)
    {
        this.name = name;
        this.desc = desc;
    }
}