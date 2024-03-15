package states.games.rhythmo;

import flixel.addons.transition.FlxTransitionableState;
import states.games.rhythmo.Conductor;

class BeatState extends FlxState
{
    private var curBeat:Int = 0;
    private var curStep:Int = 0;

    override function create()
    {
        super.create();

        if (!FlxTransitionableState.skipNextTransOut)
        {
            var cam:FlxCamera = new FlxCamera();
            cam.bgColor.alpha = 0;
            FlxG.cameras.add(cam, false);
            cam.fade(FlxColor.BLACK, 0.7, true, () -> 
            {
                FlxTransitionableState.skipNextTransOut = false;
            });
        }
        else
            FlxTransitionableState.skipNextTransOut = false;
    }

    override function update(elapsed:Float)
    {
        var oldStep:Int = curStep;

        updateCurStep();
        updateBeat();

        if (oldStep != curStep && curStep > 0)
            stepHit();
        
        super.update(elapsed);
    }

    override function destroy()
    {
        super.destroy();
    }

    private function updateBeat():Void
    {
        curBeat = Math.floor(curStep / 4);
    }

    private function updateCurStep():Void
    {
        curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
    }

    public function stepHit():Void
    {
        if (curStep % 4 == 0)
            beatHit();
    }

    public function beatHit():Void {}
}