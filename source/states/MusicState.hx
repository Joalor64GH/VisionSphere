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

class MusicState extends states.MusicState.BeatState
{
    var disc:FlxSprite;
    
    var songTxt:Alphabet;
    var lengthTxt:Alphabet;

    var loaded:Bool = false;
    var camZooming:Bool = false;

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
        openfl.system.System.gc();

        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + FlxG.save.data.theme));
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

        songTxt = new Alphabet(0, 0, songs[curSelected].name, true);
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

        if (FlxG.keys.justPressed.R)
            FlxG.resetState();

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.music.fadeOut(0.3);
        }

        if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSong(FlxG.keys.justPressed.LEFT ? -1 : 1);
        }

        if (FlxG.sound.music != null)
        {
            states.MusicState.Conductor.songPosition = FlxG.sound.music.time;
            if (FlxG.keys.justPressed.ENTER && loaded)
            {
                FlxG.sound.play(Paths.sound('confirm'));
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
            if (curBeat % 2 == 0 || ((songs[curSelected].name == 'Ascension' || songs[curSelected].name == 'Harmony of No Tomorrow') && curBeat % 3 == 0))
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

        curSelected += change;
        if (curSelected >= songs.length)
            curSelected = 0;
        else if (curSelected < 0)
            curSelected = songs.length - 1;

        disc.loadGraphic(Paths.image('music/discs/${songs[curSelected].disc}'));

        songTxt.text = '< ${songs[curSelected].name} >';

        states.MusicState.Conductor.bpm = songs[curSelected].bpm;

        var songName:String = songs[curSelected].song == null ? songs[curSelected].name.toLowerCase() : songs[curSelected].song;

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
        if (seconds.length == 1)
            seconds = '0' + seconds;

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

    public function beatHit():Void
    {
        // do nothing lmao
    }
}