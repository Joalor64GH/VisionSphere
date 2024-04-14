package states;

import flixel.addons.display.FlxBackdrop;

class TestState extends FlxState
{
    var bckDrp:FlxBackdrop = new FlxBackdrop(Paths.image('flixelCoin') #if (flixel_addons < "3.0.0"), 0.2, 0.2, true, true #end);

    override function create()
    {
        bckDrp.x = 0;
        bckDrp.y = FlxG.height / 2;
        bckDrp.velocity.x = -50;
        add(bckDrp);

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (bckDrp.x + bckDrp.width < 0)
            bckDrp.x = FlxG.width;
        
        bckDrp.y = FlxG.height / 2 + Math.sin(FlxG.elapsed * 2) * 50;

        if (Input.is('exit'))
            FlxG.switchState(MenuState.new);
    }
}