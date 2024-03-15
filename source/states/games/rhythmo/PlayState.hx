package states.games.rhythmo;

import states.games.rhythmo.Section.SectionArray;
import states.games.rhythmo.Song.SongData;
import states.games.rhythmo.Opponent;
import states.games.rhythmo.Player;
import states.games.rhythmo.Note;

import states.games.rhythmo.BeatState;
import states.games.rhythmo.Conductor;
import states.games.rhythmo.Highscore;

import flixel.addons.display.FlxGridOverlay;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import flixel.sound.FlxSound;

import flixel.FlxObject;

class PlayState extends BeatState
{
    public static var curLevel:String = 'lol';
    public static var SONG:SongData;

    private var vocals:FlxSound;

    private var opponent:Character;
    private var player:Player;

    private var notes:FlxTypedGroup<Note>;
    private var unspawnNotes:Array<Note> = [];

    private var strumLine:FlxSprite;
    private var curSection:Int = 0;

    private var camFollow:FlxObject;
    private var strumLineNotes:FlxTypedGroup<FlxSprite>;
    private var playerStrums:FlxTypedGroup<FlxSprite>;

    private var camZooming:Bool = false;
    private var curSong:String = "";

    private var combo:Int = 0;
    private var songScore:Int = 0;
    private var songMisses:Int = 0;

    private var generatedMusic:Bool = false;
    private var startingSong:Bool = false;

    private var camHUD:FlxCamera;
    private var camGame:FlxCamera;
    
    override public function create()
    {
        camGame = new FlxCamera();
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;

        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD);

        FlxCamera.defaultCameras = [camGame];
        
        persistentUpdate = persistentDraw = true;

        if (SONG != null)
            SONG = SONG.loadFromJSON(curLevel);
        
        Conductor.bpm = SONG.bpm;

        var bg:FlxSprite = FlxGridOverlay.create(50, 50);
        bg.scrollFactor.set(0.5, 0.5);
        add(bg);

        opponent = new Opponent(100, 100);
        add(opponent);

        var camPos:FlxPoint = new FlxPoint(opponent.getGraphicMidpoint().x, opponent.getGraphicMidpoint().y);
        camPos += 400;

        player = new Player(770, 450);
        add(player);

        Conductor.songPosition = -5000;

        strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
        strumLine.scrollFactor.set();

        strumLineNotes = new FlxTypedGroup<FlxSprite>();
        add(strumLineNotes);

        playerStrums = new FlxTypedGroup<FlxSprite>();

        startingSong = true;

        // generateSong(SONG.song);

        camFollow = new FlxObject(0, 0, 1, 1);
        camFollow.setPosition(camPos.x, camPos.y);
        add(camFollow);

        FlxG.camera.follow(camFollow, LOCKON, 0.04);
        FlxG.camera.zoom = 1.05;
        FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
        FlxG.fixedTimestep = false;

        // startCountdown();

        strumLineNotes.cameras = [camHUD];
        notes.cameras = [camHUD];

        super.create();
    }

    var startTimer:FlxTimer;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
            FlxG.switchState(MenuState.new);
    }
}