package states;

import flixel.FlxCamera;
import flixel.FlxObject;

class SaveFileState extends FlxState
{
    var bg:FlxSprite;

    var curSelected:Int = 0;
    var saveGrp:FlxTypedGroup<Alphabet>;
    var saves:Array<String> = [
        "Save Slot 1", "Save Slot 2",
        "Save Slot 3", "Save Slot 4",
        "Save Slot 5", "Save Slot 6"
    ];

    var selectorLeft:Alphabet;
    var selectorRight:Alphabet;

    var camFollow:FlxObject;
    var camFollowPos:Flxobject;
    var camMain:FlxCamera;
    
    override public function create()
    {
        super.create();

        camMain = new FlxCamera();
        FlxG.cameras.reset(camMain);
        FlxG.cameras.setDefaultDrawTarget(camMain, true);

        camFollow = new FlxObject(0, 0, 1, 1);
        camFollowPos = new FlxObject(0, 0, 1, 1);
        add(camFollow);
        add(camFollowPos);

        var yScroll:Float = Math.max(0.25 - (0.05 * (saves.length - 4)), 0.1);
        bg = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        bg.updateHitbox();
        bg.screenCenter();
        bg.scrollFactor.set(0, yScroll / 3);
        add(bg);

        saveGrp = new FlxTypedGroup<Alphabet>();
        add(saveGrp);

        for (i in 0...saves.length)
        {
            var saveTxt:Alphabet = new Alphabet(90, 320, saves[i], true);
            saveTxt.isMenuItem = true;
            saveTxt.targetY = i;
            saveGrp.add(saveTxt);
        }

        selectorLeft = new Alphabet(0, 0, '>', true);
        selectorLeft.scrollFactor.set(0, yScroll);
        add(selectorLeft);
        selectorRight = new Alphabet(0, 0, '<', true);
        selectorRight.scrollFactor.set(0, yScroll);
        add(selectorRight);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
        camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

        var mult:Float = FlxMath.lerp(1.07, bg.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
        bg.scale.set(mult, mult);
        bg.updateHitbox();
        bg.offset.set();
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;
        
        if (curSelected < 0)
            curSelected = saves.length - 1;
        if (curSelected >= saves.length)
            curSelected = 0;

        var whatever:Int = 0;

        for (item in saveGrp.members)
        {
            item.targetY = whatever + curSelected;
            whatever++;

            item.alpha = 0.6;
            if (item.targetY == 0)
            {
                item.alpha = 1;
                selectorLeft.x = item.x - 63;
                selectorLeft.y = item.y;
            }
        }
    }
}