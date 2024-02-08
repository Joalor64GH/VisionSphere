package util;

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
    public static var leftKey:String = "LEFT";
    public static var rightKey:String = "RIGHT";
    public static var downKey:String = "DOWN";
    public static var upKey:String = "UP";
    public static var acceptKey:String = "ENTER";
    public static var exitKey:String = "ESCAPE";

    public static function saveSettings()
    {
        FlxG.save.data.timeFormat = timeFormat;
        FlxG.save.data.theme = theme;
        FlxG.save.data.lang = lang;
        FlxG.save.data.fpsCounter = fpsCounter;
        FlxG.save.data.fullscreen = fullscreen;
        FlxG.save.data.leftKey = leftKey;
        FlxG.save.data.rightKey = rightKey;
        FlxG.save.data.downKey = downKey;
        FlxG.save.data.upKey = upKey;
        FlxG.save.data.acceptKey = acceptKey;
        FlxG.save.data.exitKey = exitKey;
        
        FlxG.save.flush();
    }
    
    public static function init()
    {
        if (FlxG.save.data.timeFormat != null)
            timeFormat = FlxG.save.data.timeFormat;
        if (FlxG.save.data.theme != null)
            theme = FlxG.save.data.theme;
        if (FlxG.save.data.lang != null)
            lang = FlxG.save.data.lang;
        if (FlxG.save.data.fpsCounter != null)
            fpsCounter = FlxG.save.data.fpsCounter;
        #if desktop
        if (FlxG.save.data.fullscreen != null)
            fullscreen = FlxG.save.data.fullscreen;
        #end
        if (FlxG.save.data.leftKey != null)
            leftKey = FlxG.save.data.leftKey;
        if (FlxG.save.data.rightKey != null)
            rightKey = FlxG.save.data.rightKey;
        if (FlxG.save.data.downKey != null)
            downKey = FlxG.save.data.downKey;
        if (FlxG.save.data.upKey != null)
            upKey = FlxG.save.data.upKey;
        if (FlxG.save.data.acceptKey != null)
            acceptKey = FlxG.save.data.acceptKey;
        if (FlxG.save.data.exitKey != null)
            exitKey = FlxG.save.data.exitKey;

        FlxG.save.bind('VisionSphere', 'Joalor64');
    }
}