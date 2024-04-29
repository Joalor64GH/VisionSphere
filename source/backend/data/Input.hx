package backend.data;

import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;

import flixel.input.gamepad.FlxGamepadInputID;

/*
 * A simple input system.
 * Modified by me to support game controllers.
 * @author Leather128
 * @see https://github.com/Leather128/FabricEngine
 */

class Input
{
    public static var actionMap:Map<String, FlxKey> = [
        "left" => SaveData.settings.get("keyboardBinds")[0],
        "down" => SaveData.settings.get("keyboardBinds")[1],
        "up" => SaveData.settings.get("keyboardBinds")[2],
        "right" => SaveData.settings.get("keyboardBinds")[3],
        "accept" => SaveData.settings.get("keyboardBinds")[4],
        "exit" => SaveData.settings.get("keyboardBinds")[5]
    ];

    public static function is(action:String, ?state:FlxInputState = JUST_PRESSED, ?exact:Bool = false):Bool
    {
        if (!exact)
        {
            if (state == PRESSED && is(action, JUST_PRESSED))
                return true;
            if (state == RELEASED && is(action, JUST_RELEASED))
                return true;
        }
        
        return (actionMap.exists(action)) ? FlxG.keys.checkStatus(actionMap.get(action), state) 
            : FlxG.keys.checkStatus(FlxKey.fromString(action), state);
    }

    public static function get(action:String):FlxInputState
    {
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
        
        if (gamepad != null)
        {
            if (gamepadIs(action, JUST_PRESSED))
                return JUST_PRESSED;
            if (gamepadIs(action, PRESSED))
                return PRESSED;
            if (gamepadIs(action, JUST_RELEASED))
                return JUST_RELEASED;
        }
        else
        {
            if (is(action, JUST_PRESSED))
                return JUST_PRESSED;
            if (is(action, PRESSED))
                return PRESSED;
            if (is(action, JUST_RELEASED))
                return JUST_RELEASED;
        }
        
        return RELEASED;
    }

    public static var controllerMap:Map<String, FlxGamepadInputID> = [
        "gamepad_left" => SaveData.settings.get("gamepadBinds")[0],
        "gamepad_down" => SaveData.settings.get("gamepadBinds")[1],
        "gamepad_up" => SaveData.settings.get("gamepadBinds")[2],
        "gamepad_right" => SaveData.settings.get("gamepadBinds")[3],
        "gamepad_accept" => SaveData.settings.get("gamepadBinds")[4],
        "gamepad_exit" => SaveData.settings.get("gamepadBinds")[5]
    ];

    public static function gamepadIs(key:String, ?state:FlxInputState = JUST_PRESSED):Bool
    {
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
        if (gamepad != null)
            return (controllerMap.exists(key)) ? gamepad.checkStatus(controllerMap.get(key), state)
                : gamepad.checkStatus(FlxGamepadInputID.fromString(key), state);

        return false;
    }
}