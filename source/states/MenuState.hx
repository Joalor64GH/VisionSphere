package states;

class MenuState extends FlxState
{
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

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/daylight'));
        add(bg);

        var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bar'));
        add(bar);

        var logo:FlxSprite = new FlxSprite(10, bar.y + 5).loadGraphic(Paths.image('menu/icon'));
        add(logo);

        btnPlay = new FlxSprite(150, 150).loadGraphic(Paths.image('menu/play'));
        add(btnPlay);

        #if MODS_ALLOWED
        btnMods = new FlxSprite(850, 150).loadGraphic(Paths.image('menu/mods'));
        add(btnMods);
        #end

        btnCredits = new FlxSprite().loadGraphic(Paths.image('menu/credits'));
        btnCredits.screenCenter(XY);
        add(btnCredits);

        btnMusic = new FlxSprite(150, FlxG.height - 300).loadGraphic(Paths.image('menu/music'));
        add(btnMusic);

        btnSettings = new FlxSprite(850, FlxG.height - 300).loadGraphic(Paths.image('menu/settings'));
        add(btnSettings);

        add({
            dateText = new FlxText(900, 50);
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

        if (FlxG.mouse.overlaps(btnPlay))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            if (FlxG.mouse.pressed) 
            {
                FlxG.switchState(new states.PlayState());
                FlxG.sound.play(Paths.sound('confirm'));
            }
        }
        #if MODS_ALLOWED
        else if (FlxG.mouse.overlaps(btnMods))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            if (FlxG.mouse.pressed) 
            {
                FlxG.switchState(new states.ModsState());
                FlxG.sound.play(Paths.sound('confirm'));
            }
        }
        #end

        dateText.text = DateTools.format(Date.now(), "%F") + ' / ' + DateTools.format(Date.now(), "%r");
    }
}