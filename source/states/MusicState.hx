package states;

import flixel.FlxCamera;

using StringTools;

typedef Song = 
{
    var name:String;
    var song:String;
    var disc:String;
    var bpm:Float;
}

class MusicState extends BeatState
{
    var songTxt:Alphabet;
    var lengthTxt:Alphabet;

    var curSelected:Int = 0;
    var songs:Array<Song> = [
        {name:"Arcadia Mania", song:"arcadia-mania", disc:"arcadia", bpm:125},
        {name:"Ascension", song:"ascension", disc:"ascension", bpm:110},
        {name:"Christmas Wishes",  song:"christmas-wishes", disc:"christmas", bpm:130},
        {name:"Creepy Ol Forest", song:"creepy-ol-forest", disc:"creepy", bpm:100},
        {name:"Dreamy Lo-fi Beats", song:"dreamy-lo-fi-beats", disc:"dreamy", bpm:120},
        {name:"Forever Confusing", song:"forever-confusing", disc:"forever", bpm:110},
        {name:"Game Development", song:"game-development", disc:"game", bpm:130},
        {name:"GBA Cliche", song:"gba-cliche", disc:"gba", bpm:100},
        {name:"Harmony of No Tomorrow", song:"harmony-of-no-tomorrow", disc:"harmony", bpm:110},
        {name:"Mystical Desert", song:"mystical-desert", disc:"mystical", bpm:100},
        {name:"New Era", song:"new-era", disc:"new", bpm:125},
        {name:"Nighttime Gaming", song:"nighttime-gaming", disc:"nighttime", bpm:120},
        {name:"Nighttime Gaming REMIX", song:"nighttime-gaming-remix", disc:"nighttimere", bpm:130},
        {name:"Pixel Birthday Bash", song:"pixel-birthday-bash", disc:"pixel", bpm:100},
        {name:"Pure Indian Vibes", song:"pure-indian-vibes", disc:"pure", bpm:100},
        {name:"Relaxing Evening Lo-fi", song:"relaxing-evening-lo-fi", disc:"relaxing", bpm:120},
        {name:"Silver Candy", song:"silver-candy", disc:"silver", bpm:135},
        {name:"Universal Questioning", song:"universal-questioning", disc:"universal", bpm:125},
        {name:"Untitled Lo-fi Song", song:"untitled-lo-fi-song", disc:"untitled", bpm:130}
    ];

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

    static var loadedSongs:Array<String> = [];

    private function changeSong(change:Int = 0)
    {
        // idk
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