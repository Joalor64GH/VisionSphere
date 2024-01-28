package states.games.jta;

class GameOverState extends FlxState
{
    override public function create()
    {
        super.create();

        var theText:FlxText = new FlxText(0, 0, 0, "Game Over!\nPress R to restart.\nOtherwise, press ESCAPE.", 12);
        theText.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        theText.screenCenter();
        add(theText);

        FlxG.sound.play(Paths.sound('jta/gameover'));
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('r'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.games.jta.PlayState());
            });
            FlxG.sound.play(Paths.sound('jta/play'));
        }
        else if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }
}