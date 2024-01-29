package base;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

/*
 * @author Leather128
 * @see https://github.com/Leather128/FabricEngine
 */

class Input
{
    public static var actionMap:Map<String, FlxKey> = [
        "left" => LEFT,
        "down" => DOWN,
        "up" => UP,
        "right" => RIGHT,
        "accept" => ENTER,
        "exit" => ESCAPE
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

class GamepadInput
{
    public static var gamepadMap:Map<String, FlxGamepadInputID> = [
        "left" => DPAD_LEFT,
        "down" => DPAD_DOWN,
        "up", => DPAD_UP,
        "right", => DPAD_RIGHT,
        "accept" => A,
        "exit" => B
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

        if (gamepadMap.exists(action))
            return FlxGamepad.checkStatus(gamepadMap.get(action), state);

        return FlxGamepad.checkStatus(FlxGampad.fromString(action), state);
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