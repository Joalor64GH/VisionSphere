package;

class SplashState extends FlxState
{
    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
        logo.screenCenter(XY);
        logo.scale.set(-2, -2);
        add(logo);

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        new FlxTimer().start(5, function(tmr:FlxTimer)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new PlayState());
            });
        });
    }
}