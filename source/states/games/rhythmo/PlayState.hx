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
import flixel.math.FlxRect;
import flixel.util.FlxSort;
import flixel.sound.FlxSound;

import flixel.FlxObject;

class PlayState extends BeatState
{
    public static var SONG:SongData;

    private final animArray:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

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

    var scoreTxt:FlxText;
    var timeText:FlxText;

    var songLength:Float = 0;
    var songPercent:Float = 0;

    var ratingArray:Array<String> = ['no', 'okay', 'nice'];
    var ratingMap:Map<String, Int> = [
        'no' => 50,
        'okay' => 100,
        'nice' => 200
    ];

    var ratingOffsetArray:Array<Float> = [0.9, 0.75, 0.2];
    var ratingOffsetMap:Map<String, Float> = [
        'no' => 0.9,
        'okay' => 0.75,
        'nice' => 0.2
    ];
    
    override public function create()
    {
        camGame = new FlxCamera();
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;

        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD);

        FlxCamera.defaultCameras = [camGame];
        
        persistentUpdate = persistentDraw = true;

        if (SONG == null)
            SONG = Song.loadFromJSON('Bopeebo');
        
        Conductor.changeBPM(SONG.bpm);

        var bg:FlxSprite = FlxGridOverlay.create(50, 50);
        bg.scrollFactor.set(0.5, 0.5);
        add(bg);

        opponent = new Opponent(100, 100);
        add(opponent);

        var camPos:FlxPoint = new FlxPoint(opponent.getGraphicMidpoint().x, opponent.getGraphicMidpoint().y);
        camPos.x += 400;

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

        timeText = new FlxText(0, 10, FlxG.width, "", 20);
        scoreTxt.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreTxt.screenCenter(X);
        scoreTxt.scrollFactor.set();
        add(scoreTxt);

        startCountdown();

        strumLineNotes.cameras = [camHUD];
        notes.cameras = [camHUD];
        scoreTxt.cameras = [camHUD];
        timeText.cameras = [camHUD];

        super.create();
    }

    var startTimer:FlxTimer;
    var startedCountdown:Bool = false;

    function startCountdown():Void
    {
        generateStaticArrows(0);
        generateStaticArrows(1);

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

            swagCounter++;
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

        songLength = FlxG.sound.music.length;
    }

    private function generateSong(songData:String):Void
    {
        var songData = SONG;
        Conductor.changeBPM(songData.bpm);

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

            daBeats++;
        }

        unspawnNotes.sort(sortByShit);
        generatedMusic = true;
    }

    function sortByShit(Obj1:Note, Obj2:Note):Int
        return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);

    private function generateStaticArrows(player:Int):Void
    {
        for (i in 0...4)
        {
            var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
            babyArrow.frames = Paths.getSparrowAtlas('game/rhythmo/NOTE_assets');
            babyArrow.animation.addByPrefix('green', 'arrowUP');
            babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
            babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
            babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
            babyArrow.scrollFactor.set();
            babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
            babyArrow.updateHitbox();
            babyArrow.y -= 10;
            babyArrow.alpha = 0;

            FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

            babyArrow.ID = i;

            if (player == 1)
                playerStrums.add(babyArrow);
            
            switch (Math.abs(i))
            {
                case 0:
                    babyArrow.x += Note.swagWidth * 0;
                    babyArrow.animation.addByPrefix('static', 'arrowLEFT');
                    babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
                case 1:
                    babyArrow.x += Note.swagWidth * 1;
                    babyArrow.animation.addByPrefix('static', 'arrowDOWN');
                    babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
                case 2:
                    babyArrow.x += Note.swagWidth * 2;
                    babyArrow.animation.addByPrefix('static', 'arrowUP');
                    babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
                case 3:
                    babyArrow.x += Note.swagWidth * 3;
                    babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
                    babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
                    babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
            }

            babyArrow.animation.play('static');
            babyArrow.x += 50;
            babyArrow.x += ((FlxG.width / 2) * player);

            strumLineNotes.add(babyArrow);
        }
    }

    private var paused:Bool = false;

    override function openSubState(SubState:FlxSubState)
    {
        if (paused)
        {
            if (FlxG.sound.music != null)
            {
                FlxG.sound.music.pause();
                vocals.pause();
            }

            if (!startTimer.finished)
                startTimer.active = false;
        }

        super.openSubState(SubState);
    }

    override function closeSubState()
    {
        if (paused)
        {
            if (FlxG.sound.music != null)
            {
                vocals.time = Conductor.songPosition;

                FlxG.sound.music.play();
                vocals.play();
            }

            if (!startTimer.finished)
                startTimer.active = true;
            
            paused = false;
        }

        super.closeSubState();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        scoreTxt.text = "Score: " + songScore + " // " + "Misses: " + songMisses;

        if (Input.is('enter') && startedCountdown)
        {
            persistentUpdate = false;
            persistentDraw = true;
            paused = true;

            openSubState(new states.games.rhythmo.PauseSubState(player.getScreenPosition().x, player.getScreenPosition().y));
        }

        if (Input.is('seven'))
            FlxG.switchState(new states.games.rhythmo.ChartingState());

        if (startingSong)
        {
            if (startedCountdown)
            {
                Conductor.songPosition += FlxG.elapsed * 1000;
                if (Conductor.songPosition >= 0)
                    startSong();
            }
        }
        else
        {
            Conductor.songPosition = FlxG.sound.music.time;
            if (!paused)
            {
                songTime += FlxG.game.ticks - previousFrameTime;
                previousFrameTime = FlxG.game.ticks;

                if (Conductor.lastSongPos != Conductor.songPosition)
                {
                    songTime = (songTime + Conductor.songPosition) / 2;
                    Conductor.lastSongPos = Conductor.songPosition;
                }

                var curTime:Float = FlxG.sound.music.time;
                if (curTime < 0) curTime = 0;
                songPercent = (curTime / songLength);

                var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
                if (secondsTotal < 0) secondsTotal = 0;

                var minutesRemaining:Int = Math.floor(secondsTotal / 60);
                var secondsRemaining:String = '' + secondsTotal % 60;
                if (secondsRemaining.length < 2) secondsRemaining = '0' + secondsRemaining;

                timeText.text = "Time: " + minutesRemaining + ':' + secondsRemaining;
            }
        }

        if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
        {
            if (camFollow.x != opponent.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
            {
                camFollow.setPosition(opponent.getMidpoint().x + 150, opponent.getMidpoint().y - 100);
                vocals.volume = 1;
            }

            if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != player.getMidpoint().x - 100)
                camFollow.setPosition(player.getMidpoint().x - 100, player.getMidpoint().y - 100);
        }

        if (camZooming)
        {
            FlxG.camera.zoom = FlxMath.lerp(1.05, FlxG.camera.zoom, 0.95);
            camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
        }

        if (unspawnNotes[0] != null)
        {
            if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
            {
                var dunceNote:Note = unspawnNotes[0];
                notes.add(dunceNote);

                var index:Int = unspawnNotes.indexOf(dunceNote);
                unspawnNotes.splice(index, 1);
            }
        }

        if (generatedMusic)
        {
            notes.forEachAlive((daNote:Note) -> 
            {
                daNote.visible = (daNote.y > FlxG.height) ? false : true;
                daNote.active = (daNote.y > FlxG.height) ? false : true;

                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

                if (daNote.isSustainNote 
                    && daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2 
                    && (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
                {
                    var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
                    swagRect.y /= daNote.scale.y;
                    swagRect.height -= swagRect.y;

                    daNote.clipRect = swagRect;
                }

                if (!daNote.mustPress && daNote.wasGoodHit)
                {
                    opponent.playAnim(animArray[daNote.noteData % 4] + altAnim, true);
                    opponent.holdTimer = 0;

                    if (SONG.needsVoices)
                        vocals.volume = 1;

                    daNote.kill();
                    notes.remove(daNote, true);
                    daNote.destroy();
                }

                if (daNote.y < -daNote.height)
                {
                    if (daNote.isSustainNote && daNote.wasGoodHit)
                    {
                        daNote.kill();
                        notes.remove(daNote, true);
                        daNote.destroy();
                    }
                    else
                        noteMiss(daNote.noteData);
                    
                    daNote.active = false;
                    daNote.visible = false;

                    daNote.kill();
                    notes.remove(daNote, true);
                    daNote.destroy();
                }
            });
        }
        
        keyShit();
    }

    function endSong():Void
    {
        trace("song finished!");
        Highscore.saveScore(SONG.song, songScore);
        FlxG.switchState(new states.games.rhythmo.SongSelectState());
    }

    private function popUpScore(strumtime:Float):Void
    {
        var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
        vocals.volume = 1;

        var placement:String = Std.string(combo);

        var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
        coolText.screenCenter();
        coolText.x = FlxG.width * 0.55;

        var rating:FlxSprite = new FlxSprite();
        var score:Int = 350;

        var daRating:String = "perfect";

        for (ratingString in ratingArray) {
            final offset = ratingOffsetMap.get(ratingString);
            if (noteDiff > Conductor.safeZoneOffset * offset) {
                daRating = ratingString;
                score = ratingMap.get(daRating);
            }
        }

        songScore += score;

        rating.loadGraphic(Paths.image('game/rhythmo/' + daRating));
        rating.screenCenter();
        rating.x = coolText.x - 40;
        rating.y -= 60;
        rating.acceleration.y = 550;
        rating.velocity.y -= FlxG.random.int(140, 175);
        rating.setGraphicSize(Std.int(rating.width * 0.7));
        rating.updateHitbox();
        rating.velocity.x -= FlxG.random.int(0, 10);

        var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/combo'));
        comboSpr.screenCenter();
        comboSpr.x = coolText.x;
        comboSpr.acceleration.y = 600;
        comboSpr.velocity.y -= 150;
        comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
        comboSpr.updateHitbox();
        comboSpr.velocity.x += FlxG.random.int(1, 10);

        add(rating);

        var seperatedScore:Array<Int> = [];
        seperatedScore.push(Math.floor(combo / 100));
        seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
        seperatedScore.push(combo % 10);

        var daLoop:Int = 0;
        while (seperatedScore[0] == 0) seperatedScore.remove(seperatedScore[0]);
        for (i in seperatedScore)
        {
            var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/num' + Std.int(i)));
            numScore.screenCenter();
            numScore.x = coolText.x + (43 * daLoop) - 90;
            numScore.y += 80;
            numScore.setGraphicSize(Std.int(numScore.width * 0.5));
            numScore.updateHitbox();
            numScore.acceleration.y = FlxG.random.int(200, 300);
            numScore.velocity.y -= FlxG.random.int(140, 160);
            numScore.velocity.x = FlxG.random.float(-5, 5);

            if (combo >= 0)
                add(numScore);
            if (combo >= 10)
                add(comboSpr);
            
            FlxTween.tween(numScore, {alpha: 0}, 0.2, {onComplete: (tween:FlxTween) -> 
            {
                numScore.destroy();
            }, startDelay: Conductor.crochet * 0.002});

            daLoop++;
        }

        FlxTween.tween(rating, {alpha: 0}, 0.2, {startDelay: Conductor.crochet * 0.001});
        FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {onComplete: (tween:FlxTween) -> 
        {
            coolText.destroy();
            comboSpr.destroy();
            rating.destroy();
        }, startDelay: Conductor.crochet * 0.001});

        curSection++;
    }

    private function keyShit():Void
    {
        var controlArray:Array<Bool> = [Input.is('left', PRESSED),  Input.is('down', PRESSED), Input.is('up', PRESSED), Input.is('right', PRESSED)];
        var holdArray:Array<Bool> = [Input.is('left'), Input.is('down'), Input.is('up'), Input.is('right')];

        if (holdingArray.contains(true) && generatedMusic)
        {
            notes.forEachAlive((daNote:Note) -> 
            {
                if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdingArray[daNote.noteData])
                    goodNoteHit(daNote);
            });
        }

        if (controlArray.contains(true) && generatedMusic)
        {
            player.holdTimer = 0;

            var possibleNotes:Array<Note> = [];
            var removeList:Array<Note> = [];
            var ignoreList:Array<Int> = [];

            notes.forEachAlive((daNote:Note) -> 
            {
                if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) 
                {
                    if (ignoreList.contains(daNote.noteData))
                    {
                        for (possibleNote in possibleNotes)
                        {
                            if (possibleNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - possibleNote.strumTime) < 10)
                                removeList.push(daNote);
                            else if (possibleNote.noteData == daNote.noteData && daNote.strumTime < possibleNote.strumTime)
                            {
                                possibleNotes.remove(possibleNote);
                                possibleNotes.push(daNote);
                            }
                        }
                    }
                    else
                    {
                        possibleNotes.push(daNote);
                        ignoreList.push(daNote.noteData);
                    }
                }
            });

            for (badNote in removeList)
            {
                badNote.kill();
                notes.remove(badNote, true);
                badNote.destroy();
            }

            possibleNotes.sort((note1:Note, note2:Note) -> 
            {
                return Std.int(note1.strumTime - note2.strumTime);
            });

            if (possibleNotes.length > 0)
            {
                var daNote = possibleNotes[0];

                if (possibleNotes.length >= 2)
                {
                    for (i in 0...controlArray.length)
                        if (controlArray[i] && !ignoreList.contains(i))
                            badNoteCheck();

                    for (possibleNote in possibleNotes)
                        if (controlArray[possibleNote.noteData])
                            goodNoteHit(possibleNote);
                }
            }
            else
                badNoteCheck();
        }

        if (player.holdTimer > Conductor.stepCrochet * 4 * && !holdingArray.contains(true) 
            && player.animation.curAnim.name.startsWith('sing'))
            player.playAnim('idle');

        playerStrums.forEach((spr:FlxSprite) -> 
        {
            if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
                spr.animation.play('pressed');
            if (!holdingArray[spr.ID])
                spr.animation.play('static');

            if ((spr.animation.curAnim == null || spr.animation.curAnim.name != 'confirm'))
                spr.centerOffsets()
            else
            {
                spr.centerOffsets();
                spr.offset.x -= 13;
                spr.offset.y -= 13;
            }
        });
    }

    function noteMiss(direction:Int = 1):Void
    {
        combo = 0;
        songScore -= 10;
        songMisses++;
        
        switch (direction)
        {
            case 0:
                trace('missed left');
            case 1:
                trace('missed down');
            case 2:
                trace('missed up');
            case 3:
                trace('missed right');
        }
    }

    function badNoteCheck()
    {
        var upP = Input.is('up', PRESSED);
        var downP = Input.is('down', PRESSED);
        var leftP = Input.is('left', PRESSED);
        var rightP = Input.is('right', PRESSED);

        if (leftP)
            noteMiss(0);
        if (downP)
            noteMiss(1);
        if (upP)
            noteMiss(2);
        if (rightP)
            noteMiss(3);
    }

    function noteCheck(keyP:Bool, note:Note):Void
    {
        if (keyP)
            goodNoteHit(note);
        else
            badNoteCheck();
    }

    function goodNoteHit(note:Note):Void
    {
        if (!note.wasGoodHit)
        {
            if (!note.isSustainNote)
            {
                popUpScore(note.strumTime);
                combo++;
            }

            player.playAnim(animArray[note.noteData % 4], true);

            playerStrums.forEach((spr:FlxSprite) -> 
            {
                if (Math.abs(note.noteData) == spr.ID)
                    spr.animation.play('confirm', true);
            });

            note.wasGoodHit = true;
            vocals.volume = 1;

            note.kill();
            notes.remove(note, true);
            note.destroy();
        }
    }

    override function stepHit()
    {
        if (SONG.needsVoices)
        {
            if (vocals.time > Conductor.songPosition + Conductor.stepCrochet
                || vocals.time < Conductor.songPosition - Conductor.stepCrochet)
            {
                vocals.pause();
                vocals.time = Conductor.songPosition;
                vocals.play();
            }
        }

        super.stepHit();
    }

    private var totalBeats:Int = 0;

    override function beatHit()
    {
        super.beatHit();

        if (generatedMusic)
            notes.sort(FlxSort.byY, FlxSort.DESCENDING);
        
        if (SONG.notes[Math.floor(curStep / 16)] != null)
        {
            Conductor.changeBPM((SONG.notes[Math.floor(curStep / 16)].changeBPM) ? 
                SONG.notes[Math.floor(curStep / 16)].bpm : SONG.bpm);

            if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
                opponent.playAnim('idle');
        }

        if (camZooming && FlxG.camera.zoom < 1.35 && totalBeats % 4 == 0)
        {
            FlxG.camera.zoom += 0.015;
            camHUD.zoom += 0.03;
        }

        if (!player.animation.curAnim.name.startsWith("sing"))
            player.playAnim('idle');
    }
}