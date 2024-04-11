package states.games.clicker;

class PlayState extends FlxState
{
    var number:FlxSprite;
    var infinity:FlxSprite;

    var clicks:Int = 0;
    
    var clicksTxt:FlxText;
    var coolText:FlxText;
    var winTxt:FlxText;

    var win:Bool = false;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        coolText = new FlxText(0, 0, FlxG.width, 'Click on the number to multiply it by 2!', 32);
        coolText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        add(coolText);

        var tip:FlxText = new FlxText(5, FlxG.height - 24, 0, 'Press ESCAPE to exit at any time!', 12);
    	tip.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	add(tip);

        winTxt = new FlxText(5, FlxG.height - 44, 0, '', 12);
    	winTxt.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	add(winTxt);

        clicksTxt = new FlxText(5, FlxG.height - 24, 0, 'Clicks: $clicks', 12);
    	clicksTxt.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        clicksTxt.screenCenter(X);
    	add(clicksTxt);

        number = new FlxSprite().loadGraphic(Paths.image('game/2048/numbers/default/1'));
        number.screenCenter();
        add(number);

        infinity = new FlxSprite();
        infinity.frames = Paths.getSparrowAtlas('game/2048/numbers/infinity');
        infinity.animation.addByPrefix('rainbow', 'infinity', 12);
        infinity.animation.play('rainbow');
        infinity.screenCenter();

        FlxG.sound.playMusic(Paths.music('2048/game'));

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        number.screenCenter();

        clicksTxt.text = 'Clicks: $clicks';

        if (clicks == 38 || clicks >= 38)
            win = true;

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var winner = Input.is('w') || (gamepad != null ? Input.gamepadIs('start') : false);
        var clicker = FlxG.mouse.justPressed || (gamepad != null ? Input.gamepadIs('a') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (winner && win)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.sound.music.volume = 0;
                FlxG.switchState(new states.games.clicker.WinState());
            });
        }
        else if (exit)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.sound.music.volume = 0;
                FlxG.switchState(new states.games.clicker.MainMenuState());
            });
        }

        if (clicker) 
        {
            click();
            clicks++;
        }
    }

    function click()
    {
        new FlxTimer().start(0.01, (timer) ->
        {
            switch(clicks)
            {
                case 1:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/2'));
                    coolText.text = 'Keep going!';
                case 2:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/4'));
                case 3:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/8'));
                case 4:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/16'));
                case 5:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/32'));
                case 6:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/64'));
                case 7:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/128'));
                case 8:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/256'));
                case 9:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/512'));
                case 10:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/1024'));
                case 11:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/2048'));
                    coolText.text = 'You made it!';
                case 12:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/4096'));
                    coolText.text = 'Wait, what?';
                case 13:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/8192'));
                    coolText.text = "We're still going?";
                case 14:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/16384'));
                    coolText.text = 'Uhhh, okay then.';
                case 15:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/32768'));
                    coolText.text = 'These numbers are huge!';
                case 16:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/65536'));
                case 17:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/131072'));
                case 18:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/262144'));
                case 19:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/524288'));
                case 20:
                    number.loadGraphic(Paths.image('game/2048/numbers/default/1048576'));
                    coolText.text = 'One million?!';
                case 21:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/21'));
                    coolText.text = "Numbers can't fit on-screen anymore, so\nmoving on to exponents!";
                case 22:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/22'));
                case 23:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/23'));
                case 24:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/24'));
                case 25:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/25'));
                case 26:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/26'));
                case 27:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/27'));
                case 28:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/28'));
                case 29:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/29'));
                case 30:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/30'));
                case 31:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/40'));
                    coolText.text = "It'll just go on forever.";
                case 32:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/50'));
                case 33:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/60'));
                    coolText.text = 'And ever.';
                case 34:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/70'));
                case 35:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/80'));
                case 36:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/90'));
                case 37:
                    number.loadGraphic(Paths.image('game/2048/numbers/exponents/100'));
                case 38:
                    remove(number);
                    add(infinity);
                    coolText.text = 'To infinity!';
                    winTxt.text = 'Press W to win the game!';
            }

            FlxG.sound.play(Paths.sound('2048/click'));
        });
    }
}