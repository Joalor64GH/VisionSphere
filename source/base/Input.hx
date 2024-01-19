package base;

import flixel.input.keyboard.FlxKey;

/*
 * @author Leather128
 * @see https://github.com/Leather128/FabricEngine
 */

class Input
{
    public static var actionMap:Map<String, Array<FlxKey>> = [
        "left" => [LEFT, A],
        "down" => [DOWN, S],
        "up" => [UP, W],
        "right" => [RIGHT, D],
        "accept" => [ENTER, SPACE],
        "exit" => [ESCAPE, BACKSPACE]
    ];

    public static function is(action:String, ?state:flixel.input.FlxInput.FlxInputState = JUST_PRESSED, ?exact:Bool = false):Bool
    {
        if (!exact)
        {
            if (state == PRESSED && is(action, JUST_PRESSED))
                return true;
            if (state == RELEASED && is(action, JUST_RELEASED))
                return true;
        }

        if (actionMap.exists(action))
            return FlxG.keys.checkStatus(actionMap.get(action), state);
        
        return FlxG.keys.checkStatus(FlxKey.fromString(action), state);
    }

    public static function get(action:String):flixel.input.FlxInput.FlxInputState
    {
        if (is(action, JUST_PRESSED))
            return JUST_PRESSED;
        if (is(action, PRESSED))
            return PRESSED;
        if (is(action, JUST_RELEASED))
            return JUST_RELEASED;
        
        return RELEASED;
    }
}