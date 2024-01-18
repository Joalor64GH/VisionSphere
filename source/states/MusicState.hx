package states;

import flixel.FlxCamera;

class MusicState extends BeatState
{
    override public function create()
    {
        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    override function stepHit()
    {
        super.stepHit();
    }

    override function beatHit()
    {
        super.beatHit();
    }
}

class Conductor
{
    public static var bpm(default, set):Float = 100;
    public static var crochet:Float = ((60 / bpm) * 1000);
    public static var stepCrochet:Float = crochet / 4;
    public static var songPosition:Float;

    public function new() {}

    inline public static function calculateCrochet(bpm:Float) {
        return (60 / bpm) * 1000;
    }

    public static function set_bpm(newBpm:Float) {
        crochet = calculateCrochet(newBpm);
        stepCrochet = crochet / 4;
        return bpm = newBpm;
    }
}

class BeatState extends FlxState
{
    private var curBeat:Int = 0;
    private var curStep:Int = 0;

    override function create()
    {
        super.create();
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

    public function beatHit():Void
    {
        // do nothing lmao
    }
}