package states;

class MenuState extends FlxState
{
    public static var gameVersion:String = '0.4.0';

    var dateText:FlxText;
    
    var btnPlay:FlxSprite;
    var btnMods:FlxSprite;
    var btnCredits:FlxSprite;
    var btnMusic:FlxSprite;
    var btnSettings:FlxSprite;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        FlxG.mouse.visible = true;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + FlxG.save.data.theme));
        add(bg);

        var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bar'));
        add(bar);

        var logo:FlxSprite = new FlxSprite(10, bar.y + 5).loadGraphic(Paths.image('menu/icon'));
        add(logo);

        btnPlay = new FlxSprite(150, 150).loadGraphic(Paths.image('menu/play'));
        add(btnPlay);

        #if MODS_ALLOWED
        btnMods = new FlxSprite(875, 150).loadGraphic(Paths.image('menu/mods'));
        add(btnMods);
        #end

        btnCredits = new FlxSprite().loadGraphic(Paths.image('menu/credits'));
        btnCredits.screenCenter(XY);
        add(btnCredits);

        btnMusic = new FlxSprite(150, FlxG.height - 300).loadGraphic(Paths.image('menu/music'));
        add(btnMusic);

        btnSettings = new FlxSprite(875, FlxG.height - 300).loadGraphic(Paths.image('menu/settings'));
        add(btnSettings);

        dateText = new FlxText(900, 50);
        dateText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(dateText);

        var versionTxt:FlxText = new FlxText(logo.x + 145, 50, 0, "VisionSphere v" + gameVersion, 12);
        versionTxt.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(versionTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(btnPlay) && FlxG.mouse.pressed)
        {
            FlxG.switchState(new states.PlayState());
            FlxG.sound.play(Paths.sound('confirm'));
        }
        
        #if MODS_ALLOWED
        if (FlxG.mouse.overlaps(btnMods) && FlxG.mouse.pressed)
        {
            FlxG.switchState(new states.ModsState());
            FlxG.sound.play(Paths.sound('confirm'));
        }
        #end

        if (FlxG.mouse.overlaps(btnMusic) && FlxG.mouse.pressed)
        {
            FlxG.switchState(new states.MusicState());
            FlxG.sound.play(Paths.sound('confirm'));
        }
        
        if (FlxG.mouse.overlaps(btnSettings) && FlxG.mouse.pressed)
        {
            FlxG.switchState(new states.OptionsState());
            FlxG.sound.play(Paths.sound('confirm'));
        }

        dateText.text = DateTools.format(Date.now(), "%F") + ' / ' + DateTools.format(Date.now(), FlxG.save.data.timeFormat);
    }
}