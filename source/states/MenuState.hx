package states;

class MenuState extends FlxState
{
    var dateText:FlxText;
    var splashTxt:FlxText;

    var isTweening:Bool = false;
    var lastString:String = '';
    var timer:Float = 0;
    
    var options:Array<String> = ['play', #if MODS_ALLOWED 'mods', #end 'music', 'settings'];

    var randomBox:FlxSprite;
    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;
    var curOption:FlxSprite;
    
    var curSelected:Int = 0;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var ui_tex:String = 'menu/ui_arrows';

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        var sideBox:FlxSprite = new FlxSprite();
        sideBox.frames = Paths.getSparrowAtlas('menu/thisidk');
        sideBox.animation.addByPrefix('idle', 'thingidk', 24, false);
        sideBox.animation.play('idle');
        add(sideBox);

        var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bar'));
        add(bar);

        var logo:FlxSprite = new FlxSprite(10, bar.y + 5).loadGraphic(Paths.image('menu/icon'));
        add(logo);

        if (FlxG.random.bool(30)) // oooh banana
        {
            var banana:FlxSprite = new FlxSprite(5, FlxG.height - 120).loadGraphic(Paths.image('banan'), true, 102, 103);
            banana.animation.add('rotate', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 14);
            banana.animation.play('rotate');
            add(banana);
        }

        curOption = new FlxSprite(sideBox.x, sideBox.y).loadGraphic(Paths.image('menu/play'));
        curOption.screenCenter(Y);
        curOption.scale.set(3, 3);
        add(curOption);

        leftArrow = new FlxSprite(curOption.width - 19, curOption.y);
        leftArrow.frames = Paths.getSparrowAtlas(ui_tex);
        leftArrow.animation.addByPrefix('idle', "arrow left");
        leftArrow.animation.addByPrefix('press', "arrow push left");
        leftArrow.animation.play('idle');
        add(leftArrow);

        rightArrow = new FlxSprite(curOption.width + 19, curOption.y);
        rightArrow.frames = Paths.getSparrowAtlas(ui_tex);
        rightArrow.animation.addByPrefix('idle', "arrow right");
        rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
        rightArrow.animation.play('idle');
        add(rightArrow);

        randomBox = new FlxSprite(780, 0).loadGraphic(Paths.image('menu/randombox/template'));
        randomBox.screenCenter(Y);
        add(randomBox);

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

        if (Input.is('left'))
        {
            curSelected--;
            if (curSelected < 0)
                curSelected = options.length - 1;
            curOption.loadGraphic(Paths.image('menu/' + options[curSelected]));
            FlxG.sound.play(Paths.sound('scroll'));
            leftArrow.animation.play('press');
        }
        else
            leftArrow.animation.play('idle');

        if (Input.is('right'))
        {
            curSelected++;
            if (curSelected >= options.length)
                curSelected = 0;
            curOption.loadGraphic(Paths.image('menu/' + options[curSelected]));
            FlxG.sound.play(Paths.sound('scroll'));
            rightArrow.animation.play('press');
        }
        else
            rightArrow.animation.play('idle');

        if (Input.is('accept'))
        {
            switch (curSelected)
            {
                case 0:
                    FlxG.switchState(PlayState.new);
                case 1:
                    #if MODS_ALLOWED
                    FlxG.switchState(ModsState.new);
                    #end
                case 2:
                    FlxG.switchState(MusicState.new);
                case 3:
                    FlxG.switchState(OptionsState.new);
            }
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