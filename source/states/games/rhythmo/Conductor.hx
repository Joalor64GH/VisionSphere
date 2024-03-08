package states.games.rhythmo;

class Conductor
{
    public static var bpm(default, set):Float = 100;
    public static var crochet:Float = ((60 / bpm) * 1000);
    public static var stepCrochet:Float = crochet / 4;
    public static var songPosition:Float;
    public static var lastSongPos:Float;
    public static var safeFrames:Int = 5;
    public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

    public function new() {}

    inline public static function calculateCrochet(bpm:Float) 
    {
        return (60 / bpm) * 1000;
    }

    public static function set_bpm(newBpm:Float) 
    {
        crochet = calculateCrochet(newBpm);
        stepCrochet = crochet / 4;
        return bpm = newBpm;
    }
}