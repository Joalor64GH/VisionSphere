package states.substates;

class LanguageSubState extends FlxSubState
{
    var curSelected:Int = 0;
    var iconArray:Array<AttachedSprite> = [];
    var coolGrp:FlxTypedGroup<Alphabet>;
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
            var label:Alphabet = new Alphabet(190, 320, langStrings[i].lang, true);
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

        if (Input.is('up') || Input.is('down'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (Input.is('accept'))
        {
            SaveData.saveSettings();
            FlxG.sound.play(Paths.sound('confirm'));
            switch(curSelected)
            {
                case 0:
                    SaveData.lang = 'de';
                case 1:
                    SaveData.lang = 'en';
                case 2:
                    SaveData.lang = 'es';
                case 3:
                    SaveData.lang = 'fr';
                case 4:
                    SaveData.lang = 'it';
                case 5:
                    SaveData.lang = 'pt';
            }

            Localization.switchLanguage(SaveData.lang);
            close();
        }
        else if (Input.is('exit'))
        {
            FlxG.sound.play(Paths.sound('cancel'));
            close();
        }

        for (num => item in coolGrp.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    private function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, langStrings.length - 1);
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