package states.games;

#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideo;
#end

/**
 * @author ROYALEPRO
 * @see https://github.com/ROYALEPRO/soni-main-public
 */

class Phone extends FlxState
{
    var nokia:FlxSprite;
    var numbers:FlxTypedGroup<FlxSprite>;
    var code:FlxText;
    var selection:Int;
    var canSelect:Bool = true;

    var video:FlxVideo;

    override function create()
    {
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}