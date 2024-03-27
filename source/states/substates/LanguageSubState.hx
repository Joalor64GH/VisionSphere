package states.substates;

import openfl.Assets;

class LanguageSubState extends FlxSubState
{
    var curSelected:Int = 0;
    var iconArray:Array<AttachedSprite> = [];
    var coolGrp:FlxTypedGroup<Alphabet>;
    var langStrings:Array<Locale> = [];

    public function new()
    {
        super();

        pushLanguages();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);

        coolGrp = new FlxTypedGroup<Alphabet>();
        add(coolGrp);

        for (i in 0...langStrings.length)
        {
            var label:Alphabet = new Alphabet(200, 320, langStrings[i].lang, true);
            label.isMenuItem = true;
            label.targetY = i;
            coolGrp.add(label);

            var icon:AttachedSprite = new AttachedSprite();
            var iconPath:String = Paths.getSparrowAtlas('langs/' + langStrings[i].code);
            if (FileSystem.exists(iconPath)) 
            {
                icon.frames = Paths.getSparrowAtlas('langs/' + langStrings[i].code);
                icon.animation.addByPrefix('idle', langStrings[i].code, 24);
                icon.animation.play('idle');
            }
            else
            {
                icon.frames = Paths.getSparrowAtlas('langs/null');
                icon.animation.addByPrefix('idle', 'flag_base', 24);
                icon.animation.play('idle');
            }
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
            SaveData.lang = langStrings[curSelected].code;
            Localization.switchLanguage(SaveData.lang);
            FlxG.sound.play(Paths.sound('confirm'));
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

    private function pushLanguages()
    {
        var initLangString = CoolUtil.getText(Paths.txt('languagesData'));

        if (Assets.exists(Paths.txt('languagesData')))
        {
            initLangString = Assets.getText(Paths.txt('languagesData')).trim().split('\n');

            for (i in 0...initLangString.length)
                initLangString[i] = initLangString[i].trim();
        }

        for (i in 0...initLangString.length)
        {
            var data:Array<String> = initLangString[i].split(':');
            langStrings.push(new Locale(data[0], data[1]));
        }
        
        // load and push mod languages
        #if MODS_ALLOWED
        var filesPushed:Array<String> = [];
        var foldersToCheck:Array<String> = [Paths.mods('data/')];

        if (Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
            foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/'));

        for (mod in Paths.getGlobalMods())
            foldersToCheck.insert(0, Paths.mods(mod + '/data/'));
        
        for (folder in foldersToCheck) {
            if (FileSystem.exists(folder) && FileSystem.isDirectory(folder)) {
                var path:String = folder + "/languagesData.txt";
                if (FileSystem.exists(path)) {
                    var modLangData:String = File.getContent(path).trim();
                    var modLangDataSplit:Array<String> = modLangData.split(':');

                    if (modLangDataSplit.length == 2)
                        langStrings.push(new Locale(modLangDataSplit[0], modLangDataSplit[1]));

                    filesPushed.push(path);
                }
            }
        }
        #end
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