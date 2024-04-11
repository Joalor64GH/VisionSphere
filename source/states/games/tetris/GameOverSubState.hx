package states.games.tetris;

class GameOverSubState extends FlxSubState
{
    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        bg.alpha = 0.65;
        add(bg);

        var text:FlxText = new FlxText(0, 0, 0, "Game Over!\nPress R to restart.\nOtherwise, press ESCAPE.", 12);
        text.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter();
        add(text);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var restart = Input.is('r') || (gamepad != null ? Input.gamepadIs('right_stick_click') : false);
        var exit = Input.is('escape') || (gamepad != null ? Input.gamepadIs('b') : false);

        if (restart)
        {
            close();
            FlxG.sound.play(Paths.sound('confirm'));
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.resetState();
            });
        }
        else if (exit)
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.tetris.MainMenuState());
            });
        }
    }
}