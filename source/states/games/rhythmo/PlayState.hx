package states.games.rhythmo;

import states.games.rhythmo.Section.SectionArray;
import states.games.rhythmo.Song.SongData;
import states.games.rhythmo.Character;
import states.games.rhythmo.Player;

import states.games.rhythmo.BeatState;
import states.games.rhythmo.Conductor;
import states.games.rhythmo.Highscore;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import flixel.sound.FlxSound;

class PlayState extends FlxState
{
    public static var curLevel:String = 'lol';
    public static var SONG:SongData;

    private var vocals:FlxSound;

    private var opponent:Character;
    private var player:Player;

    private var curSection:Int = 0;

    private var combo:Int = 0;
    private var songScore:Int = 0;

    private var generatedMusic:Bool = false;
    private var startingSong:Bool = false;

    
    
    override public function create()
    {
        super.create();
        add(new FlxText("Hello World", 64).screenCenter());
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
            FlxG.switchState(MenuState.new);
    }
}