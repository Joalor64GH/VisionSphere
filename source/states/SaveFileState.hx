package states;

import flixel.util.FlxSave;

// this doesn't actually do anything atm
class SaveFileState extends FlxState
{
    var curSelected:Int = 0;

    var saveGrp:FlxTypedGroup<Alphabet>;
    var saves:Array<String> = [];
    var savesCanDelete:Array<String> = [];

    var selectorLeft:Alphabet;
    var selectorRight:Alphabet;

    var accepted:Bool = false;
    var deleteMode:Bool = false;
    var emptySave:Array<Bool> = [true, true, true, true, true, true];

    public static var saveFile:FlxSave;
    
    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('saveBG'));
        add(bg);

        for (i in 0...6)
        {
            SaveData.getSaveData(Std.string(i));
            trace("added save file" + Std.string(i + 1));
            emptySave[i] = (!SaveData.save.data.init || SaveData.save.data.init == null);
            saves.push("Save File " + Std.string(i + 1) + (!emptySave[i] ? "" : " Empty"))
        }

        saves.push("Erase Save");

        saveGrp = new FlxTypedGroup<Alphabet>();
        add(saveGrp);

        for (i in 0...saves.length)
        {
            var saveTxt:Alphabet = new Alphabet(0, 0, saves[i], true);
            saveTxt.screenCenter();
            saveTxt.y += (100 * (i - (saves.length / 2))) + 50;
            saveGrp.add(saveTxt);
        }

        selectorLeft = new Alphabet(0, 0, '>', true);
        selectorLeft.scrollFactor.set(0, yScroll);
        add(selectorLeft);
        selectorRight = new Alphabet(0, 0, '<', true);
        selectorRight.scrollFactor.set(0, yScroll);
        add(selectorRight);

        changeSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (!accepted)
        {
            if ((Input.is('up') || Input.is('down')))
            {
                changeSelection(Input.is('up') ? -1 : 1);
                FlxG.sound.play(Paths.sound('scroll'));
            }

            if (Input.is('accept'))
            {
                if (curSelected != (saveGrp.length - 1))
                {
                    if (!deleteMode)
                    {
                        accepted = true;

                        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
                        {
                            SaveData.save.init = true;
                            SaveData.changeSaveData(curSelected);
                            SaveData.getSaveData(curSelected);
                            FlxG.switchState(SplashState.new);
                        });
                    }
                }
            }
        }
    }

    function eraseSave(id:Int)
    {
        trace("erased save " + (id + 1));
        SaveData.resetSaveData(id);
        emptySave[id] = true;
        idkLol();
    }

    function idkLol()
    {
        savesCanDelete = [];

        for (i in 0...saveGrp.length)
            if (i != 6)
                if (!emptySave[i])
                    savesCanDelete.push(i);
        
        saveGrp.clear();

        var savesAvailable:Array<String> = [];

        for (i in 0...savesCanDelete.length)
            savesAvailable.push("Save File " + Std.string(i + 1));
        
        savesAvailable.push("Cancel");

        for (i in 0...savesAvailable.length)
        {
            var saveTxt:Alphabet = new Alphabet(0, 0, savesAvailable[i], true);
            saveTxt.screenCenter();
            saveTxt.y += (100 * (i - (savesAvailable.length / 2))) + 50;
            saveGrp.add(saveTxt);
        }

        changeSelection();
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, saves.length - 1);

        for (num => item in saveGrp.members)
        {
            item.targetY = num - curSelected;
            item.alpha = 0.6;
            
            if (item.targetY == 0)
            {
                item.alpha = 1;
                selectorLeft.x = item.x - 63;
                selectorLeft.y = item.y;
                selectorRight.x = item.x + item.width + 15;
                selectorRight.y = item.y;
            }
        }
    }
}