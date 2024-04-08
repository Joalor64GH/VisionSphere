package states.games;

class DVDScreensaver extends FlxState
{
    var dvdLogo:FlxSprite;

    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        dvdLogo = new FlxSprite(0, 0).loadGraphic(Paths.image('game/dvd/dvd'));
        dvdLogo.setGraphicSize(200, 5);
        dvdLogo.scale.y = dvdLogo.scale.x;
        dvdLogo.updateHitbox();
        dvdLogo.velocity.set(135, 95);
        dvdLogo.setColorTransform(0, 0, 0, 1, 255, 255, 255);
        add(dvdLogo);

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit')) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(MenuState.new);
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
        
        if (dvdLogo.x > FlxG.width - dvdLogo.width || dvdLogo.x < 0)
        {
            dvdLogo.velocity.x = -dvdLogo.velocity.x;
            switchColor();
        }

        if (dvdLogo.y > FlxG.height - dvdLogo.height || dvdLogo.y < 0)
        {
            dvdLogo.velocity.y = -dvdLogo.velocity.y;
            switchColor();
        }
    }

    private function switchColor()
    {
        dvdLogo.setColorTransform(0, 0, 0, 1, FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
    }
}