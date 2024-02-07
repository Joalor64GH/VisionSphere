package states;

/**
 * @author khuonghoanghuy
 * @see https://github.com/khuonghoanghuy/FNF-Pop-Engine-Rewrite/
 */

class ControlsState extends FlxState
{
    var init:Int = 0;
    var inChange:Bool = false;

    var text1:FlxText;
    var text2:FlxText;

    public function new()
    {
        super();
    }
}