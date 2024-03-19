package states.games.rhythmo;

class Conductor
{
    public static var bpm:Int = 100;
    public static var crochet:Float = ((60 / bpm) * 1000);
    public static var stepCrochet:Float = crochet / 4;
    public static var songPosition:Float;
    public static var lastSongPos:Float;
    
    public static var safeFrames:Int = 5;
    public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

    public function new() {}

    public static function changeBPM(newBpm:Int) 
    {
        bpm = newBpm;
        crochet = ((60 / bpm) * 1000);
        stepCrochet = crochet / 4;
    }
}