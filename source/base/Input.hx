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
        // wip
    }
}