package states.games.jta;

import states.games.jta.PlayState;

class GameOverSubState extends FlxSubState
{
    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        bg.scrollFactor.set();
        bg.alpha = 0.65;
        add(bg);

        var theText:FlxText = new FlxText(0, 0, 0, "Game Over!\nPress R to restart.\nOtherwise, press ESCAPE.", 20);
        theText.alignment = LEFT;
        theText.scrollFactor.set();
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
                close();
                FlxG.resetState();
                switch (PlayState.instance.lev)
                {
                    case 1:
                        PlayState.instance.lev = 1;
                    case 2:
                        PlayState.instance.lev = 2;
                }
            });
            FlxG.sound.play(Paths.sound('jta/play'));
        }
        else if (Input.is('escape'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }
}