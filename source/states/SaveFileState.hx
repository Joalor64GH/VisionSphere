package states;

import flixel.FlxCamera;
import flixel.FlxObject;

// this doesn't actually do anything atm
class SaveFileState extends FlxState
{
    var bg:FlxSprite;

    var curSelected:Int = 0;
    var saveGrp:FlxTypedGroup<Alphabet>;
    var saves:Array<String> = [
        "Save Data 1", "Save Data 2",
        "Save Data 3", "Save Data 4",
        "Save Data 5", "Save Data 6",
        "Reset Save Data"
    ];

    var selectorLeft:Alphabet;
    var selectorRight:Alphabet;

    var camFollow:FlxObject;
    var camFollowPos:FlxObject;
    var camMain:FlxCamera;

    var accepted:Bool;
    var allowInputs:Bool = true;
    
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
            var saveTxt:Alphabet = new Alphabet(0, 0, saves[i], true);
            saveTxt.screenCenter();
            saveTxt.y += (100 * (i - (saves.length / 2))) + 50;
            saveTxt.scrollFactor.set(0, Math.max(0.25 - (0.05 * (saves.length - 4)), 0.1));
            saveGrp.add(saveTxt);
        }

        selectorLeft = new Alphabet(0, 0, '>', true);
        selectorLeft.scrollFactor.set(0, yScroll);
        add(selectorLeft);
        selectorRight = new Alphabet(0, 0, '<', true);
        selectorRight.scrollFactor.set(0, yScroll);
        add(selectorRight);

        changeSelection();

        allowInputs = true;
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

        if (allowInputs)
        {
            if ((Input.is('up') || Input.is('down')) && !accepted)
            {
                changeSelection(Input.is('up') ? -1 : 1);
                FlxG.sound.play(Paths.sound('scroll'));
            }

            if (Input.is('accept') && !accepted)
            {
                accepted = true;
                FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
                {
                    #if desktop
                    states.UpdateState.updateCheck();
                    FlxG.switchState((states.UpdateState.mustUpdate) ? new states.UpdateState() : new states.SplashState());
                    #else
                    trace('Sorry! No update support on: ' + util.PlatformUtil.getPlatform() + '!')
                    FlxG.switchState(new states.SplashState());
                    #end
                });
            }
        }
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
            item.targetY = whatever - curSelected;
            whatever++;

            item.alpha = 0.6;
            if (item.targetY == 0)
            {
                item.alpha = 1;
                selectorLeft.x = item.x - 63;
                selectorLeft.y = item.y;
                selectorRight.x = item.x + item.width + 15;
                selectorRight.y = item.y;
                var add:Float = (saveGrp.members.length > 4 ? saveGrp.members.length * 8 : 0);
                camFollow.setPosition(item.getGraphicMidpoint().x, item.getGraphicMidpoint().y - add);
            }
        }
    }
}