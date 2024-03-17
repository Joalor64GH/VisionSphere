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

    public var scoreTxt:FlxText;
    
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

        generateSong(SONG.song);

        camFollow = new FlxObject(0, 0, 1, 1);
        camFollow.setPosition(camPos.x, camPos.y);
        add(camFollow);

        FlxG.camera.follow(camFollow, LOCKON, 0.04);
        FlxG.camera.zoom = 1.05;
        FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
        FlxG.fixedTimestep = false;

        scoreTxt = new FlxText(0, (FlxG.height * 0.89) + 36, FlxG.height, "", 20);
        scoreTxt.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreTxt.screenCenter(X);
        scoreTxt.scrollFactor.set();
        add(scoreTxt);

        startCountdown();

        strumLineNotes.cameras = [camHUD];
        notes.cameras = [camHUD];
        scoreTxt.cameras = [camHUD];

        super.create();
    }

    var startTimer:FlxTimer;
    var startedCountdown:Bool = false;

    function startCountdown():Void
    {
        // generateStaticArrows(0);
        // generateStaticArrows(1);

        startedCountdown = true; 
        Conductor.songPosition = 0;
        Conductor.songPosition -= Conductor.crochet * 5;

        var swagCounter:Int = 0;

        startTimer = new FlxTimer().start(Conductor.crochet / 1000, (timer) -> 
        {
            opponent.playAnim('idle');
            player.playAnim('idle');

            switch (swagCounter)
            {
                case 0:
                    var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/three'));
                    three.scrollFactor.set();
                    three.screenCenter();
                    add(three);
                    FlxTween.tween(three, {y: three.y += 100, alpha: 0}, Conductor.crochet / 1000, {
                        ease: FlxEase.cubeInOut,
                        onComplete: (twn:FlxTween) -> {
                            three.destroy();
                        }
                    });
                case 1:
                    var two:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/two'));
                    two.scrollFactor.set();
                    two.screenCenter();
                    add(two);
                    FlxTween.tween(two, {y: two.y += 100, alpha: 0}, Conductor.crochet / 1000, {
                        ease: FlxEase.cubeInOut,
                        onComplete: (twn:FlxTween) -> {
                            two.destroy();
                        }
                    });
                case 2:
                    var one:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/one'));
                    one.scrollFactor.set();
                    one.screenCenter();
                    add(one);
                    FlxTween.tween(one, {y: one.y += 100, alpha: 0}, Conductor.crochet / 1000, {
                        ease: FlxEase.cubeInOut,
                        onComplete: (twn:FlxTween) -> {
                            one.destroy();
                        }
                    });
                case 3:
                    var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/go'));
                    go.scrollFactor.set();
                    go.screenCenter();
                    add(go);
                    FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
                        ease: FlxEase.cubeInOut,
                        onComplete: (twn:FlxTween) -> {
                            go.destroy();
                        }
                    });
            }

            swagCounter += 1;
        }, 5);
    }

    var previousFrameTime:Int = 0;
    var lastReportedPlayheadPosition:Int = 0;
    var songTime:Float = 0;

    function startSong():Void
    {
        previousFrameTime = FlxG.game.ticks;
        lastReportedPlayheadPosition = 0;

        startingSong = false;
        FlxG.sound.playMusic(Paths.music("rhythmo/" + SONG.song + "_Inst"), 1, false);
        FlxG.sound.music.onComplete = () -> endSong;
        vocals.play();
    }

    private function generateSong(data:String):Void
    {
        var songData = SONG;
        Conductor.bpm = songData.bpm;

        curSong = songData.song;

        vocals = (SONG.needsVoices) ? new FlxSound().loadEmbedded(Paths.music("rhythmo/" + curSong + "_Voices")) : new FlxSound();

        FlxG.sound.list.add(vocals);

        notes = new FlxTypedGroup<Note>();
        add(notes);

        var noteData:Array<SectionArray>;
        noteData = songData.notes;

        var daBeats:Int = 0;
        for (section in noteData)
        {
            var coolSection:Int = Std.int(section.lengthInSteps / 4);
            for (songNotes in section.sectionNotes)
            {
                var daStrumTime:Float = songNotes[0];
                var daNoteData:Int = Std.int(songNotes[1] % 4);
                var gottaHitNote:Bool = section.mustHitSection;

                if (songNotes[1] > 3)
                    gottaHitNote = !section.mustHitSection;

                var oldNote:Note;
                oldNote = (unspawnNotes.length > 0) ? unspawnNotes[Std.int(unspawnNotes.length - 1)] : null;

                var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
                swagNote.sustainLength = songNotes[2];
                swagNote.scrollFactor.set(0, 0);

                var susLength:Float = swagNote.sustainLength;

                susLength = susLength / Conductor.stepCrochet;
                unspawnNotes.push(swagNote);

                for (susNote in 0...Math.floor(susLength))
                {
                    oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

                    var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
                    sustainNote.scrollFactor.set();
                    unspawnNotes.push(sustainNote);

                    sustainNote.mustPress = gottaHitNote;

                    if (sustainNote.mustPress)
                        sustainNote.x += FlxG.width / 2;
                }

                swagNote.mustPress = gottaHitNote;

                if (swagNote.mustPress)
                    swagNote.x += FlxG.width / 2;
            }

            daBeats += 1;
        }

        unspawnNotes.sort(sortByShit);
        generatedMusic = true;
    }

    function sortByShit(Obj1:Note, Obj2:Note):Int
        return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);

    private function generateStaticArrows(player:Int):Void
    {
        for (in in 0...4)
        {
            var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
        }
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var divider:String = " // ";
        scoreTxt.text = "Score: " + songScore + divider + "Misses: " + songMisses;

        if (Input.is('exit'))
            FlxG.switchState(MenuState.new);
    }
}