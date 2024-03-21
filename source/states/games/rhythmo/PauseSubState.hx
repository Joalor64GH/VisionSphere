package states.games.rhythmo;

class PauseSubState extends FlxSubState
{
    public function new(x:Float, y:Float)
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        bg.cameras = [FlxG.cameras.list[1]];
        bg.scrollFactor.set();
        bg.alpha = 0.6;
        add(bg);

        var text:FlxText = new FlxText(0, 0, 0, "R - Restart\nENTER - Resume\nESCAPE - Exit", 54);
        text.scrollFactor.set();
        text.screenCenter();
        add(text);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('r'))
        {
            FlxG.resetState();
            close();
        }
        else if (Input.is('escape'))
        {
            close();
            FlxG.switchState(new states.games.rhythmo.SongSelectState());
        }
        else if (Input.is('enter'))
            close();
    }
}