package states;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

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

class MusicState extends BeatState
{
    var bg:FlxSprite;
    var disc:FlxSprite;
    
    var songTxt:Alphabet;
    var lengthTxt:Alphabet;

    var loaded:Bool = false;
    var camZooming:Bool = false;

    var curSelected:Int = 0;
    var musicData:BasicData;

    var timeBar:Bar;

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

        timeBar = new Bar(0, 0, FlxG.width, 10, FlxColor.WHITE, FlxColor.fromRGB(30, 144, 255));
        timeBar.screenCenter(X);
        timeBar.y = FlxG.height - 10;
        add(timeBar);

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
            Conductor.songPosition = FlxG.sound.music.time;
            if ((Input.is('accept') || Input.is('space')) && loaded)
            {
                if (!FlxG.sound.music.playing)
                {
                    FlxG.sound.music.play();
                    disc.angularVelocity = 30;
                    timeBar.value = (Conductor.songPosition / FlxG.sound.music.length);
                }
                else 
                {
                    FlxG.sound.music.pause();
                    disc.angularVelocity = 0;
                }
            }
        }

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (gamepad != null)
        {
            if (Input.gamepadIs('right_stick_click'))
                FlxG.resetState();

            if (Input.gamepadIs('gamepad_exit'))
            {
                FlxG.switchState(MenuState.new);
                FlxG.sound.music.volume = 0;
            }

            if (Input.gamepadIs('gamepad_left') || Input.gamepadIs('gamepad_right'))
            {
                new FlxTimer().start(0.01, (timer) -> 
                {
                    FlxG.sound.play(Paths.sound('scroll'));
                });
                changeSong(Input.gamepadIs('left') ? -1 : 1);
            }

            if (FlxG.sound.music != null)
            {
                Conductor.songPosition = FlxG.sound.music.time;
                if ((Input.gamepadIs('gamepad_accept') || Input.gamepadIs('start')) && loaded)
                {
                    if (!FlxG.sound.music.playing)
                    {
                        FlxG.sound.music.play();
                        disc.angularVelocity = 30;
                        timeBar.value = (Conductor.songPosition / FlxG.sound.music.length);
                    }
                    else 
                    {
                        FlxG.sound.music.pause();
                        disc.angularVelocity = 0;
                    }
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

        disc.loadGraphic(Paths.image('music/discs/${musicData.songs[curSelected].disc}'));

        songTxt.text = '< ${musicData.songs[curSelected].name} >';
        Conductor.bpm = musicData.songs[curSelected].bpm;

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

class Bar extends FlxSprite
{
    private var _bgBarBit:BitmapData;
    private var _bgBarRect:Rectangle;
    private var _zeroOffset:Point;

    private var _fgBarBit:BitmapData;
    private var _fgBarRect:Rectangle;
    private var _fgBarPoint:Point;

    private var barWidth(default, null):Int;
    private var barHeight(default, null):Int;

    public var value:Float = 0;

    public function new(x:Float = 0, y:Float = 0, width:Int = 100, height:Int = 10, bgColor:FlxColor, fgColor:FlxColor)
    {
        super(x, y);

        this.barWidth = width;
        this.barHeight = height;

        _bgBarRect = new Rectangle();
        _zeroOffset = new Point();

        _fgBarRect = new Rectangle();
        _fgBarPoint = new Point();

        _bgBarBit = Paths.setBitmap("bgBarBitmap", new BitmapData(barWidth, barHeight, true, bgColor));
        _bgBarRect.setTo(0, 0, barWidth, barHeight);

        _fgBarBit = Paths.setBitmap("fgBarBitmap", new BitmapData(barWidth, barHeight, true, fgColor));
        _fgBarRect.setTo(0, 0, barWidth, barHeight);

        makeGraphic(width, height, FlxColor.TRANSPARENT, true);
    }

    override public function destroy()
    {
        _bgBarBit = null;
        Paths.disposeBitmap("bgBarBitmap");
        _bgBarRect = null;
        _zeroOffset = null;

        _fgBarBit = null;
        Paths.disposeBitmap("fgBarBitmap");
        _fgBarRect = null;
        _fgBarRect = null;

        super.destroy();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        pixels.copyPixels(_bgBarBit, _bgBarRect, _zeroOffset);

        _fgBarRect.width = (value * barWidth);
        _fgBarRect.height = barHeight;

        pixels.copyPixels(_fgBarBit, _fgBarRect, _fgBarPoint, null, null, true);
    }
}