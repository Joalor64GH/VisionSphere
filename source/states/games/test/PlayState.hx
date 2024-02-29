package states.games.test;

import states.games.test.Cube;

class PlayState extends FlxState
{
    var cube:Cube;

    override public function create()
    {
        super.create();

        cube = new Cube();
        add(cube);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    override function destroy()
    {
        super.destroy();
        cube.destroy();
    }
}