package states;

class MenuState extends FlxState
{
    var dateText:FlxText;

    var btnPlay:FlxSprite;
    var btnMmods:FlxSprite;
    var btnCredits:FlxSprite;
    var btnMusic:FlxSprite;
    var btnSettings:FlxSprite;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/daylight'));
        add(bg);

        var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bar'));
        add(bar);

        var logo:FlxSprite = new FlxSprite(10, bar.y + 10).loadGraphic(Paths.image('menu/icon'));
        add(logo);

        btnPlay = new FlxSprite(150, 150).loadGraphic(Paths.image('menu/play'));
        add(btnPlay);

        #if MODS_ALLOWED
        btnMods = new FlxSprite(FlxG.width-300,150).loadGraphic(Paths.image('menu/mods'));
        add(btnMods);
        #end

        btnCredits = new FlxSprite().loadGraphic(Paths.image('menu/credits'));
        btnCredits.screenCenter(XY);
        add(btnCredits);

        btnMusic = new FlxSprite(150,FlxG.height-300).loadGraphic(Paths.image('menu/music'));
        add(btnMusic);

        btnSettings = new FlxSprite(FlxG.width-300, FlxG.height-300).loadGraphic(Paths.image('menu/settings'));
        add(btnSettings);

        add({
            dateText = new FlxText(900, 0);
            dateText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            dateText;
        });

        add({
            var daText = new FlxText(5, FlxG.height - 24, 0, "v" + Application.current.meta.get('version'), 12);
            daText.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            daText;
        });
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.M)
            FlxG.switchState(new states.ModsState());

        dateText.text = DateTools.format(Date.now(), "%F") + ' / ' + DateTools.format(Date.now(), "%r");
    }
}