package states;

typedef BasicData = {
    var ?bg:String;
    var songs:Array<Song>;
}

typedef Song = {
    var name:String;
    var song:String;
    var disc:String;
    var bpm:Float;
}

class MusicState extends states.MusicState.BeatState
{
    var disc:FlxSprite;
    
    var songTxt:Alphabet;
    var lengthTxt:Alphabet;

    var loaded:Bool = false;
    var camZooming:Bool = false;

    var curSelected:Int = 0;
    var musicData:BasicData;

    var bg:FlxSprite;

    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        
        openfl.system.System.gc();

        super.create();

        musicData = Json.parse(Paths.getTextFromFile('data/music.json'));

        if (musicData.bg != null && musicData.bg.length > 0)
            bg = new FlxSprite().loadGraphic(Paths.image(musicData.bg));
        else
            bg = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        var musplayer:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('music/musplayer'));
        musplayer.screenCenter();
        add(musplayer);

        disc = new FlxSprite(0, 0).loadGraphic(Paths.image('music/disc')); // default
        disc.setPosition(musplayer.x + 268, musplayer.y + 13);
        add(disc);

        var playerneedle:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('music/playerneedle'));
        playerneedle.screenCenter();
        add(playerneedle);

        songTxt = new Alphabet(0, 0, musicData.songs[curSelected].name, true);
        songTxt.setPosition(80, musplayer.y - 120);
        add(songTxt);

        lengthTxt = new Alphabet(150, FlxG.height - 84, '', true);
        add(lengthTxt);

        changeSong();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        camZooming = (FlxG.sound.music.playing) ? true : false;

        if (Input.is('r'))
            FlxG.resetState();

        if (Input.is('exit'))
        {
            FlxG.switchState(MenuState.new);
            FlxG.sound.music.volume = 0;
        }

        if (Input.is('left') || Input.is('right'))
        {
            new FlxTimer().start(0.01, (timer) -> 
            {
                FlxG.sound.play(Paths.sound('scroll'));
            });
            changeSong(Input.is('left') ? -1 : 1);
        }

        if (FlxG.sound.music != null)
        {
            states.MusicState.Conductor.songPosition = FlxG.sound.music.time;
            if ((Input.is('accept') || Input.is('space')) && loaded)
            {
                if (!FlxG.sound.music.playing)
                {
                    FlxG.sound.music.play();
                    disc.angularVelocity = 30;
                }
                else 
                {
                    FlxG.sound.music.pause();
                    disc.angularVelocity = 0;
                }
            }
        }
    }

    override function stepHit()
    {
        super.stepHit();
    }

    override function beatHit()
    {
        super.beatHit();

        if (camZooming)
        {
            // did this because ascension and harmony of no tomorrow have a time signature of 3/4
            if (curBeat % 2 == 0 || ((musicData.songs[curSelected].name == 'Ascension' 
                || musicData.songs[curSelected].name == 'Harmony of No Tomorrow') && curBeat % 3 == 0))
                FlxTween.tween(FlxG.camera, {zoom:1.03}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
        }
    }

    static var loadedSongs:Array<String> = [];
    private function changeSong(change:Int = 0)
    {
        loaded = false;

        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();

        lengthTxt.text = 'Loading song...';

        curSelected = FlxMath.wrap(curSelected + change, 0, musicData.songs.length - 1);

        if (FileSystem.exists(Paths.image('music/discs/${musicData.songs[curSelected].disc}')))
            disc.loadGraphic(Paths.image('music/discs/${musicData.songs[curSelected].disc}'));
        else
        {
            trace('ohno its dont exist (${musicData.songs[curSelected].disc})');
            disc.loadGraphic(Paths.image('music/disc'));
        }

        songTxt.text = '< ${musicData.songs[curSelected].name} >';
        states.MusicState.Conductor.bpm = musicData.songs[curSelected].bpm;

        var songName:String = musicData.songs[curSelected].song == null ? musicData.songs[curSelected].name.toLowerCase() : musicData.songs[curSelected].song;
        trace("NEXT SONG: " + songName);

        if (!loadedSongs.contains(songName))
        {
            loadedSongs.push(songName);
            FlxG.sound.playMusic(Paths.music(songName), 1, false);
            FlxG.sound.music.pause();
        }
        else
        {
            FlxG.sound.playMusic(Paths.music(songName), 1, false);
            FlxG.sound.music.pause();
        }

        loaded = true;

        var seconds:String = '' + Std.int(FlxG.sound.music.length / 1000) % 60;
        if (seconds.length == 1) seconds = '0' + seconds;

        lengthTxt.text = 'Song Length: ${Std.int(FlxG.sound.music.length / 1000 / 60)}:$seconds';
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

    public function beatHit():Void {}
}