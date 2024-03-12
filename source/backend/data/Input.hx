package backend.data;

import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

/*
 * @author Leather128
 * @see https://github.com/Leather128/FabricEngine
 */

class Input
{
    public static var actionMap:Map<String, FlxKey> = [
        "left" => SaveData.leftKey,
        "down" => SaveData.downKey,
        "up" => SaveData.upKey,
        "right" => SaveData.rightKey,
        "accept" => SaveData.acceptKey,
        "exit" => SaveData.exitKey
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

    public static function get(action:String):FlxInputState
    {
        if (is(action, JUST_PRESSED))
            return JUST_PRESSED;
        if (is(action, PRESSED))
            return PRESSED;
        if (is(action, JUST_RELEASED))
            return JUST_RELEASED;
        
        return RELEASED;
    }

    public var controllerMap:Map<String, FlxGamepadInputID> = [
        "gamepad_left" => DPAD_LEFT,
        "gamepad_right" => DPAD_RIGHT,
        "gamepad_down" => DPAD_DOWN,
        "gamepad_up" => DPAD_UP,
        "gamepad_accept" => A,
        "gamepad_exit" => B
    ];

    public function gamepadIs(key:String, ?state:FlxInputState = JUST_PRESSED):Bool
    {
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
        if (gamepad != null)
            return (controllerMap.exists(key)) ? gamepad.checkStatus(key, state)
                : gamepad.checkStatus(FlxGamepadInputID.fromString(key), state);

        return false;
    }
}