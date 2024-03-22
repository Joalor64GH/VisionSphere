package backend.data;

import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;

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
        
        return (actionMap.exists(action)) ? FlxG.keys.checkStatus(actionMap.get(action), state) : 
            FlxG.keys.checkStatus(FlxKey.fromString(action), state);
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

    public static var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
    public static var controllerMap:Map<String, FlxGamepadInputID> = [
        "gamepad_left" => SaveData.gamepadLeftKey,
        "gamepad_right" => SaveData.gamepadRightKey,
        "gamepad_down" => SaveData.gamepadDownKey,
        "gamepad_up" => SaveData.gamepadUpKey,
        "gamepad_accept" => SaveData.gamepadAcceptKey,
        "gamepad_exit" => SaveData.gamepadExitKey
    ];

    public static function gamepadIs(key:String, ?state:FlxInputState = JUST_PRESSED):Bool
    {
        if (gamepad != null)
            return (controllerMap.exists(key)) ? gamepad.checkStatus(controllerMap.gamepadGet(key), state)
                : gamepad.checkStatus(FlxGamepadInputID.fromString(key), state);

        return false;
    }

    public static function gamepadGet(action:String):FlxInputState
    {
        if (gamepadIs(action, JUST_PRESSED))
            return JUST_PRESSED;
        if (gamepadIs(action, PRESSED))
            return PRESSED;
        if (gamepadIs(action, JUST_RELEASED))
            return JUST_RELEASED;
        
        return RELEASED;
    }
}