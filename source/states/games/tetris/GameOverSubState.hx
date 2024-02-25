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

        if (Input.is('r'))
        {
            close();
            FlxG.resetState();
            FlxG.sound.play(Paths.sound('confirm'));
        }
        else if (Input.is('escape'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.tetris.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }
}