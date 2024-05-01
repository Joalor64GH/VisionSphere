package states;

class TestState extends FlxState
{
    override function create()
    {
        add(new FlxText("Hello, world!", 64).screenCenter());
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
            Main.switchState(MenuState.new);
    }
}