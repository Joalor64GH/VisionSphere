package states.games.jta;

class GameOverSubState extends FlxSubState
{
    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        bg.scrollFactor.set();
        bg.alpha = 0.65;
        add(bg);

        var theText:FlxText = new FlxText(0, 0, 0, "Game Over!\nPress any button to return to the menu.", 16);
        theText.alignment = LEFT;
        theText.scrollFactor.set();
        theText.screenCenter();
        add(theText);

        FlxG.sound.play(Paths.sound('jta/gameover'));
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var any = Input.is('any') || (gamepad != null ? Input.gamepadIs('any') : false);

        if (any)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }
}