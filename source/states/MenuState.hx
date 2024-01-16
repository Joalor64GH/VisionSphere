package states;

import flixel.tweens.FlxTween.TweenCallback;

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

        var daText = new FlxText(logo.x + 145, 50, 0, "VisionSphere v" + Application.current.meta.get('version'), 12);
        daText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(daText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(btnPlay))
        {
            FlxTween.tween(btnPlay, {y: btnPlay.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

            FlxG.sound.play(Paths.sound('scroll'), 1, false, true);

            if (FlxG.mouse.pressed) 
            {
                FlxG.switchState(new states.PlayState());
                FlxG.sound.play(Paths.sound('confirm'));
            }
        }
        else
            FlxTween.completeTweensOf(btnPlay);
        
        #if MODS_ALLOWED
        if (FlxG.mouse.overlaps(btnMods))
        {
            FlxTween.tween(btnMods, {y: btnMods.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

            FlxG.sound.play(Paths.sound('scroll'), 1, false, true);

            if (FlxG.mouse.pressed) 
            {
                FlxG.switchState(new states.ModsState());
                FlxG.sound.play(Paths.sound('confirm'));
            }
        }
        else
            FlxTween.completeTweensOf(btnMods);
        #end
        
        if (FlxG.mouse.overlaps(btnSettings))
        {
            FlxTween.tween(btnSettings, {y: btnSettings.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

            FlxG.sound.play(Paths.sound('scroll'), 1, false, true);

            if (FlxG.mouse.pressed) 
            {
                FlxG.switchState(new states.OptionsState());
                FlxG.sound.play(Paths.sound('confirm'));
            }
        }
        else
            FlxTween.completeTweensOf(btnSettings);

        dateText.text = DateTools.format(Date.now(), "%F") + ' / ' + DateTools.format(Date.now(), "%r");
    }
}