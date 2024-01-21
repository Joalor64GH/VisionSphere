package states.substates;

import objects.Alphabet;
import objects.AttachedSprite;

class LanguageSubState extends FlxSubState
{
    private var iconArray:Array<AttachedSprite> = [];
    private var coolGrp:FlxTypedGroup<Alphabet>;

    var curSelected:Int = 0;
    var langStrings:Array<Locale> = [
        new Locale('Deutsch', 'de'),
        new Locale('English', 'en'),
        new Locale('Español', 'es'),
        new Locale('Français', 'fr'),
        new Locale('Italiano', 'it'),
        new Locale('Português', 'pt')
    ];

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);

        coolGrp = new FlxTypedGroup<Alphabet>();
        add(coolGrp);

        for (i in 0...langStrings.length)
        {
            var label:Alphabet = new Alphabet(400, 320, langStrings[i].lang, true);
            label.isMenuItem = true;
            label.targetY = i;
            coolGrp.add(label);

            var icon:AttachedSprite = new AttachedSprite();
            icon.frames = Paths.getSparrowAtlas('langs/' + langStrings[i].code);
            icon.animation.addByPrefix('idle', langStrings[i].code, 24);
            icon.animation.play('idle');
            icon.xAdd = -icon.width - 10;
            icon.sprTracker = label;

            iconArray.push(icon);
            add(icon);
        }

        changeSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(FlxG.keys.justPressed.UP ? -1 : 1);
        }

        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.play(Paths.sound('confirm'));
            switch(curSelected)
            {
                case 0:
                    FlxG.save.data.lang = 'de';
                case 1:
                    FlxG.save.data.lang = 'en';
                case 2:
                    FlxG.save.data.lang = 'es';
                case 3:
                    FlxG.save.data.lang = 'fr';
                case 4:
                    FlxG.save.data.lang = 'it';
                case 5:
                    FlxG.save.data.lang = 'pt';
            }

            close();
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.sound.play(Paths.sound('cancel'));
            close();
        }
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = coolGrp.length - 1;
        if (curSelected >= coolGrp.length)
            curSelected = 0;
        
        var lobotomy:Int = 0; // FIRE IN THE HOLE

        for (item in coolGrp.members)
        {
            item.targetY = lobotomy - curSelected;
            lobotomy++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }
}

class Locale
{
    public var lang:String;
    public var code:String;

    public function new(lang:String, code:String)
    {
        this.lang = lang;
        this.code = code;
    }
}