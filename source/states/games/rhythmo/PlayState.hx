package states.games.rhythmo;

import states.games.rhythmo.Section.SectionArray;
import states.games.rhythmo.Song.Cantando;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
    public static var curLevel:String = 'lol';
    public static var SONG:Cantando;
    
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