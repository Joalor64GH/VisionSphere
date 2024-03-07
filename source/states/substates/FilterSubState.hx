package states.substates;

class FilterSubState extends FlxSubState
{
    var curSelected:Int = 0;
    var coolGrp:FlxTypedGroup<Alphabet>;
    var filters:Array<String> = [
        'None',
        'Deuteranopia',
        'Protanopia',
        'Tritanopia',
        'Gameboy',
        'Virtual Boy',
        'Black and White',
        'Inverted',
        'What Even',
        'Random'
    ];

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);

        coolGrp = new FlxTypedGroup<Alphabet>();
        add(coolGrp);

        for (i in 0...filters.length)
        {
            var label:Alphabet = new Alphabet(190, 320, filters[i], true);
            label.isMenuItem = true;
            label.targetY = i;
            coolGrp.add(label);
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
                    SaveData.colorBlindFilter = -1;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 1:
                    SaveData.colorBlindFilter = 0;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 2:
                    SaveData.colorBlindFilter = 1;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 3:
                    SaveData.colorBlindFilter = 2;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 4:
                    SaveData.colorBlindFilter = 3;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 5:
                    SaveData.colorBlindFilter = 4;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 6:
                    SaveData.colorBlindFilter = 5;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 7:
                    SaveData.colorBlindFilter = 6;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 8:
                    SaveData.colorBlindFilter = 7;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter);
                case 9:
                    SaveData.colorBlindFilter = 8;
                    Colorblind.updateColorBlindFilter(SaveData.colorBlindFilter, FlxG.random.float(0, 1));
            }

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