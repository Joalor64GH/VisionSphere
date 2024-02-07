package base;

/*
 * @author Leather128
 * @see https://github.com/Leather128/FabricEngine
 */

class Input
{
    public static function is(action:String, ?state:flixel.input.FlxInput.FlxInputState = JUST_PRESSED, ?exact:Bool = false):Bool
    {
        if (!exact)
        {
            if (state == PRESSED && is(action, JUST_PRESSED))
                return true;
            if (state == RELEASED && is(action, JUST_RELEASED))
                return true;
        }
        
        return FlxG.keys.checkStatus(flixel.input.keyboard.FlxKey.fromString(action), state);
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