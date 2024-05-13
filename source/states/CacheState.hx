package states;

class CacheState extends FlxState // wip
{
    override function create()
    {
        add(new FlxText("Hello, world!", 64).screenCenter());
        FlxG.switchState(InitialState.new);
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}