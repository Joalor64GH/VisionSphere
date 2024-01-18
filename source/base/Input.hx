package base;

import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;

/*
 * @author Leather128
 * @see https://github.com/Leather128/FabricEngine
 */

class Input
{
    public static var actionMap:Map<String, FlxKey> = [
        "left" => LEFT,
        "left_alt" => A,
        "down" => DOWN,
        "down_alt" => S,
        "up" => UP,
        "up_alt" => W,
        "right" => RIGHT,
        "right_alt" => D,
        "accept" => ENTER,
        "accept_alt" => SPACE,
        "exit" => ESCAPE,
        "exit_alt" => BACKSPACE
    ];

    public static function is(action:String, ?state:FlxInput.FlxInputState = JUST_PRESSED, ?exact:Bool = false):Bool
    {
        if (!exact)
        {
            if (state == PRESSED && is(action, JUST_PRESSED))
                return true;
            if (state == RELEASED && is(action, JUST_RELEASED))
                return true;
        }

        if (actionMap.exists(action))
            return FlxG.keys.checkStatus(actionMap.get(action), state) || FlxG.keys.checkStatus(actionMap.get('${action}_alt'), state);
        
        return FlxG.keys.checkStatus(FlxKey.fromString(action, state));
    }

    public static function get(action:String):FlxInput.FlxInputState
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