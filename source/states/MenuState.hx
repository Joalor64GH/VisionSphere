package states;

import frontend.objects.ClickableSprite;
import flixel.addons.display.FlxBackdrop;

class MenuState extends FlxState
{
    var dateText:FlxText;
    var splashTxt:FlxText;

    var isTweening:Bool = false;
    var lastString:String = '';
    var timer:Float = 0;

    var seasonalBackdrop:FlxBackdrop; // wip

    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.settings.theme));
        add(bg);

        var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bar'));
        add(bar);

        var logo:FlxSprite = new FlxSprite(10, bar.y + 5).loadGraphic(Paths.image('menu/icon'));
        add(logo);

        if (FlxG.random.bool(30)) // oooh banana
        {
            var banana:FlxSprite = new FlxSprite(5, FlxG.height - 120).loadGraphic(Paths.image('menu/banan'), true, 102, 103);
            banana.animation.add('rotate', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 14);
            banana.animation.play('rotate');
            add(banana);
        }

        var btnPlay:ClickableSprite = new ClickableSprite(150, 150, 'menu/play', () -> 
        {
            FlxG.switchState(PlayState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        });
        add(btnPlay);

        #if MODS_ALLOWED
        var btnMods:ClickableSprite = new ClickableSprite(875, 150, 'menu/mods', () -> 
        {
            FlxG.switchState(ModsState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        });
        add(btnMods);
        #end

        var btnProfile:ClickableSprite = new ClickableSprite(0, 0, 'menu/profile/' + SaveData.settings.profile, () -> 
        {
            FlxG.switchState(AccountState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        });
        btnProfile.screenCenter(XY);
        add(btnProfile);

        var btnMusic:ClickableSprite = new ClickableSprite(150, FlxG.height - 300, 'menu/music', () -> 
        {
            FlxG.switchState(MusicState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        });
        add(btnMusic);

        var btnSettings:ClickableSprite = new ClickableSprite(875, FlxG.height - 300, 'menu/settings', () -> 
        {
            FlxG.switchState(OptionsState.new);
            FlxG.sound.play(Paths.sound('confirm'));
        });
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

        #if debug // transition test
        if (Input.is('t'))
            Main.switchState(TestState.new);
        #end

        if (isTweening)
            timer = 0;
        else 
        {
            timer += elapsed;
            if (timer >= 3)
                changeText();
        }

        dateText.text = DateTools.format(Date.now(), "%F") + ' / ' + DateTools.format(Date.now(), SaveData.settings.timeFormat);
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