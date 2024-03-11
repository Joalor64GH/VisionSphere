package states;

import states.options.*;

class MenuState extends FlxState
{
    var dateText:FlxText;
    var splashTxt:FlxText;

    var isTweening:Bool = false;
    var lastString:String = '';
    var timer:Float = 0;
    
    var btnPlay:FlxSprite;
    var btnMods:FlxSprite;
    var btnProfile:FlxSprite;
    var btnMusic:FlxSprite;
    var btnSettings:FlxSprite;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bar'));
        add(bar);

        var logo:FlxSprite = new FlxSprite(10, bar.y + 5).loadGraphic(Paths.image('menu/icon'));
        add(logo);

        if (FlxG.random.bool(30)) 
        {
            var banana:FlxSprite = new FlxSprite(5, FlxG.height - 120).loadGraphic(Paths.image('banan'), true, 102, 103);
            banana.animation.add('rotate', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 14);
            banana.animation.play('rotate');
            add(banana);
        }

        btnPlay = new FlxSprite(150, 150).loadGraphic(Paths.image('menu/play'));
        add(btnPlay);

        #if MODS_ALLOWED
        btnMods = new FlxSprite(875, 150).loadGraphic(Paths.image('menu/mods'));
        add(btnMods);
        #end

        btnProfile = new FlxSprite().loadGraphic(Paths.image('menu/profile/' + SaveData.profile));
        btnProfile.screenCenter(XY);
        add(btnProfile);

        btnMusic = new FlxSprite(150, FlxG.height - 300).loadGraphic(Paths.image('menu/music'));
        add(btnMusic);

        btnSettings = new FlxSprite(875, FlxG.height - 300).loadGraphic(Paths.image('menu/settings'));
        add(btnSettings);

        dateText = new FlxText(900, 50);
        dateText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(dateText);

        splashTxt = new FlxText(logo.x + 145, 50, 0, "", 12);
        splashTxt.setFormat(Paths.font('vcr.ttf'), 30, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        splashTxt.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
        add(splashTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (isTweening)
            timer = 0;
        else 
        {
            timer += elapsed;
            if (timer >= 3)
                changeText();
        }

        if (FlxG.mouse.overlaps(btnPlay) && FlxG.mouse.pressed)
        {
            FlxG.switchState(PlayState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        }
        
        #if MODS_ALLOWED
        if (FlxG.mouse.overlaps(btnMods) && FlxG.mouse.pressed)
        {
            FlxG.switchState(ModsState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        }
        #end

        if (FlxG.mouse.overlaps(btnProfile) && FlxG.mouse.pressed)
        {
            FlxG.switchState(AccountState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        }

        if (FlxG.mouse.overlaps(btnMusic) && FlxG.mouse.pressed)
        {
            FlxG.switchState(MusicState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        }
        
        if (FlxG.mouse.overlaps(btnSettings) && FlxG.mouse.pressed)
        {
            FlxG.switchState(OptionsState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        }

        #if debug
        if (Input.is('e'))
            FlxG.switchState(TestState.new);
        #end

        dateText.text = DateTools.format(Date.now(), "%F") + ' / ' + DateTools.format(Date.now(), SaveData.timeFormat);
    }

    private function changeText()
    {
        var selectedText:String = '';
        var textArray:Array<String> = CoolUtil.getText(Paths.txt('splash'));

        splashTxt.alpha = 1;
        isTweening = true;
        selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))];
        FlxTween.tween(splashTxt, {alpha: 0}, 1, {
            ease: FlxEase.linear,
            onComplete: (blud:FlxTween) ->
            {
                if (selectedText != lastString) {
                    splashTxt.text = selectedText;
                    lastString = selectedText;
                } else {
                    selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))];
                    splashTxt.text = selectedText;
                }

                splashTxt.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
                splashTxt.alpha = 0;

                FlxTween.tween(splashTxt, {alpha: 1}, 1, {
                    ease: FlxEase.linear,
                    onComplete: (blud:FlxTween) ->
                    {
                        isTweening = false;
                    }
                });
            }
        });
    }
}