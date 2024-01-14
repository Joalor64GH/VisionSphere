package;

class PlayState extends FlxState
{
    override public function create()
    {
        super.create();

        add({
            var text = new FlxText(0, 0, 0, "Hello World", 64);
            text.screenCenter();
            text;
        });
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}