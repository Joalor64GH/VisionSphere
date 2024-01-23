package states.games.jta;

class MainMenuState extends FlxState
{
    var logo:FlxSprite;

    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/jta/bgMain'));
        add(bg);

        logo = new FlxSprite(0, 220).loadGraphic(Paths.image('game/jta/logo'));
        logo.screenCenter(X);
        logo.scale.set(4, 4);
        add(logo);

        logoTween();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('accept'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.games.jta.PlayState());
            });
            FlxG.sound.play(Paths.sound('jta/play'));
        }
        else if (Input.is('exit'))
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