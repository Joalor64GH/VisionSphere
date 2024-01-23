package states.games.clicker;

class PlayState extends FlxState
{
    var daString:String;

    var number:FlxSprite;
    var infinity:FlxSprite;

    var clicks:Int = 0;
    var clicksTxt:FlxText;

    var coolText:FlxText;

    var winTxt:FlxText;

    public var win:Bool = false;

    override public function create()
    {
        super.create();

        daString = 'default/1';

        coolText = new FlxText(0, 0, FlxG.width, 'Click on the number to multiply it by 2!', 32);
        coolText.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        add(coolText);

        var tip:FlxText = new FlxText(5, FlxG.height - 24, 0, 'Press ESCAPE to exit at any time!', 12);
    	tip.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	add(tip);

        winTxt = new FlxText(5, FlxG.height - 44, 0, '', 12);
    	winTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	add(winTxt);

        clicksTxt = new FlxText(5, FlxG.height - 24, 0, 'Clicks: $clicks', 12);
    	clicksTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        clicksTxt.screenCenter(X);
    	add(clicksTxt);

        number = new FlxSprite().loadGraphic(Paths.image('game/2048/numbers' + daString));
        number.screenCenter();
        add(number);

        infinity = new FlxSprite();
        infinity.frames = Paths.getSparrowAtlas('game/2048/numbers/infinity');
        infinity.animation.addByPrefix('rainbow', 'infinity', 12);
        infinity.animation.play('rainbow');
        infinity.screenCenter();
        infinity.visible = false;
        add(infinity);

        FlxG.sound.playMusic(Paths.music('2048/game'));

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        clicksTxt.text = 'Clicks: $clicks';

        if (clicks == 38 || clicks >= 38)
            win = true;

        if (Input.is('w') && win)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.sound.music.volume = 0;
                FlxG.switchState(new states.games.clicker.WinState());
            });
        }
        else if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.sound.music.volume = 0;
                FlxG.switchState(new states.games.clicker.MainMenuState());
            });
        }

        if (FlxG.mouse.pressed)
        {
            FlxG.sound.play(Paths.sound('2048/click'));
            clicks += 1;

            switch(clicks)
            {
                case 1:
                    daString = 'default/2';
                    coolText.text = 'Keep going!';
                case 2:
                    daString = 'default/4';
                case 3:
                    daString = 'default/8';
                case 4:
                    daString = 'default/16';
                case 5:
                    daString = 'default/32';
                case 6:
                    daString = 'default/64';
                case 7:
                    daString = 'default/128';
                case 8:
                    daString = 'default/256';
                case 9:
                    daString = 'default/512';
                case 10:
                    daString = 'default/1024';
                case 11:
                    daString = 'default/2048';
                    coolText.text = 'You made it!';
                case 12:
                    daString = 'default/4096';
                    coolText.text = 'Wait, what?';
                case 13:
                    daString = 'default/8192';
                    coolText.text = "We're still going?";
                case 14:
                    daString = 'default/16384';
                    coolText.text = 'Uhhh, okay then.';
                case 15:
                    daString = 'default/32768';
                    coolText.text = 'These numbers are huge!';
                case 16:
                    daString = 'default/65536';
                case 17:
                    daString = 'default/131072';
                case 18:
                    daString = 'default/262144';
                case 19:
                    daString = 'default/524288';
                case 20:
                    daString = 'default/1048576';
                    coolText.text = 'One million?!';
                case 21:
                    daString = 'exponents/21';
                    coolText.text = "Numbers can't fit on-screen anymore, so\nmoving on to exponents!";
                case 22:
                    daString = 'exponents/22';
                case 23:
                    daString = 'exponents/23';
                case 24:
                    daString = 'exponents/24';
                case 25:
                    daString = 'exponents/25';
                case 26:
                    daString = 'exponents/26';
                case 27:
                    daString = 'exponents/27';
                case 28:
                    daString = 'exponents/28';
                case 29:
                    daString = 'exponents/29';
                case 30:
                    daString = 'exponents/30';
                case 31:
                    daString = 'exponents/40';
                    coolText.text = "It'll just go on forever.";
                case 32:
                    daString = 'exponents/50';
                case 33:
                    daString = 'exponents/60';
                    coolText.text = 'And ever.';
                case 34:
                    daString = 'exponents/70';
                case 35:
                    daString = 'exponents/80';
                case 36:
                    daString = 'exponents/90';
                case 37:
                    daString = 'exponents/100';
                case 38:
                    number.visible = false;
                    infinity.visible = true;
                    coolText.text = 'To infinity!';
                    winTxt.text = 'Press W to win the game!';
            }
        }
    }
}