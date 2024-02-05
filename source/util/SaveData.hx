package util;

import openfl.Lib;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;

/**
 * A simple save data class based on psych engine lol
 * @see https://github.com/ShadowMario/FNF-PsychEngine/
 */

class SaveData
{
    public static var timeFormat:String = '%r';
    public static var theme:String = 'daylight';
    public static var lang:String = 'en';
    public static var fpsCounter:Bool = true;
    public static var fullscreen:Bool = false;
    public static var antialiasing:Bool = false;

    public static var keyBinds:Map<String, FlxKey> = [
        "left" => LEFT,
        "down" => DOWN,
        "up" => UP,
        "right" => RIGHT,
        "accept" => ENTER,
        "exit" => ESCAPE
    ];

    public static var defaultKeys:Map<String, FlxKey> = [
        "left" => LEFT,
        "down" => DOWN,
        "up" => UP,
        "right" => RIGHT,
        "accept" => ENTER,
        "exit" => ESCAPE
    ];

    public static function saveSettings()
    {
        FlxG.save.data.timeFormat = timeFormat;
        FlxG.save.data.theme = theme;
        FlxG.save.data.lang = lang;
        FlxG.save.data.fpsCounter = fpsCounter;
        FlxG.save.data.fullscreen = fullscreen;
        FlxG.save.data.antialiasing = antialiasing;
        
        FlxG.save.flush();
    }
    
    public static function init()
    {
        if (FlxG.save.data.timeFormat == null)
            timeFormat = FlxG.save.data.timeFormat;
        if (FlxG.save.data.theme == null)
            theme = FlxG.save.data.theme;
        if (FlxG.save.data.lang == null)
            lang = FlxG.save.data.lang;
        if (FlxG.save.data.fpsCounter == null)
            fpsCounter = FlxG.save.data.fpsCounter;
        #if desktop
        if (FlxG.save.data.fullscreen == null)
            fullscreen = FlxG.save.data.fullscreen;
        #end
        if (FlxG.save.data.antialiasing == null)
            antialiasing = FlxG.save.data.antialiasing;

        FlxG.save.bind('VisionSphere', 'Joalor64');
    }
}