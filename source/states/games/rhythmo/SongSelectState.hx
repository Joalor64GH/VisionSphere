package states.games.rhythmo;

import states.games.rhythmo.BeatState;
import states.games.rhythmo.Highscore;

class SongSelectState extends BeatState
{
    var grpSongs:FlxTypedGroup<Alphabet>;
    var songs:Array<String> = ["Bopeebo", "Bopeebo", "Bopeebo"]; // only testing for now

    var curSelected:Int = 0;
    
    var scoreText:FlxText;
    var lerpScore:Int = 0;
    var intendedScore:Int = 0;

    override public function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/rhythmo/menuBG'));
        add(bg);

        grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);

        for (i in 0...songs.length)
        {
            var songTxt:Alphabet = new Alphabet(90, 320, songs[i], true);
            songTxt.isMenuItem = true;
            songTxt.targetY = i;
            grpSongs.add(songTxt);
        }

        var bottomPanel:FlxSprite = new FlxSprite(0, FlxG.height - 100).makeGraphic(FlxG.width, 100, 0xFF000000);
        bottomPanel.alpha = 0.5;
        add(bottomPanel);

        scoreText = new FlxText(20, FlxG.height - 80, 1000, "", 22);
        scoreText.setFormat("VCR OSD Mono", 30, 0xFFffffff, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreText.scrollFactor.set();
        scoreText.screenCenter(X);
        add(scoreText);

        var descTxt = new FlxText(scoreText.x, scoreText.y + 36, 1000, "Totally not a copy of FNF! (It is)", 22);
        descTxt.screenCenter(X);
        descTxt.scrollFactor.set();
        descTxt.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(descTxt);

        changeSelection();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
        scoreText.text = "PERSONAL BEST:" + lerpScore;

        if (Input.is('up') || Input.is('down'))
            changeSection(Input.is('up') ? -1 : 1);

        if (Input.is('accept'))
        {
            var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase());
            PlayState.SONG = Song.loadFromJSON(poop, songs[curSelected].toLowerCase());
            FlxG.switchState(new states.games.rhythmo.PlayState());
        }
        
        if (Input.is('exit'))
            FlxG.switchState(new states.games.rhythmo.TitleState());

        for (num => item in grpSongs.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
        intendedScore = Highscore.getScore(songs[curSelected]);
    }
}