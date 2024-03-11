package states.games.react;

class PlayState extends FlxState
{
    override public function create()
    {
        super.create();
        add(new FlxText("Hello World", 64).screenCenter());
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
            FlxG.switchState(MenuState.new);
    }
}