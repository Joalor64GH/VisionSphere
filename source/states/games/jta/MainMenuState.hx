package states.games.jta;

class MainMenuState extends FlxState
{
    var logo:FlxSprite;

    // not making a FlxTypedGroup because it wont work!!!
    var playBtn:FlxSprite;
    var exitBtn:FlxSprite;

    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/jta/bgMain'));
        bg.screenCenter();
        add(bg);

        logo = new FlxSprite(0, 200).loadGraphic(Paths.image('game/jta/logo'));
        logo.screenCenter(X);
        logo.scale.set(2.5, 2.5);
        add(logo);

        playBtn = new FlxSprite(logo.x - 229, 640).loadGraphic(Paths.image('game/jta/buttons'), true, 16, 16);
        playBtn.animation.add('playU', [0]); // unselected
        playBtn.animation.add('playS', [1]); // selected
        playBtn.animation.add('playP', [2]); // pressed
        playBtn.animation.play('playU');
        playBtn.scale.set(12, 12);
        add(playBtn);

        exitBtn = new FlxSprite(logo.x + 229, 640).loadGraphic(Paths.image('game/jta/buttons'), true, 16, 16);
        exitBtn.animation.add('exitU', [12]); // unselected
        exitBtn.animation.add('exitS', [13]); // selected
        exitBtn.animation.add('exitP', [14]); // pressed
        exitBtn.animation.play('exitU');
        exitBtn.scale.set(12, 12);
        add(exitBtn);

        logoTween();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(playBtn))
        {
            playBtn.animation.play('playS');

            if (FlxG.mouse.pressed)
            {
                playBtn.animation.play('playP');
                FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
                {
                    FlxG.switchState(new states.games.jta.PlayState());
                });
            }
        }
        else if (FlxG.mouse.overlaps(exitBtn))
        {
            exitBtn.animation.play('exitS');

            if (FlxG.mouse.pressed)
            {
                exitBtn.animation.play('exitP');
                FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
                {
                    FlxG.switchState(new states.MenuState());
                });
            }
        }

        if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }

    private function logoTween()
    {
        logo.angle = -4;

        new FlxTimer().start(0.01, function(tmr:FlxTimer) 
        {
            if (logo.angle == -4)
                FlxTween.angle(logo, logo.angle, 4, 4, {ease: FlxEase.quartInOut});
            if (logo.angle == 4)
                FlxTween.angle(logo, logo.angle, -4, 4, {ease: FlxEase.quartInOut});
        }, 0);
    }
}