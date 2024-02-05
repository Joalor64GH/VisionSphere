package util;

class SaveData
{
    public static var timeFormat:String = '%r';
    public static var theme:String = 'daylight';
    public static var lang:String = 'en';
    public static var fpsCounter:Bool = true;
    public static var fullscreen:Bool = false;

    public static function saveSettings()
    {
        FlxG.save.data.timeFormat = timeFormat;
        FlxG.save.data.theme = theme;
        FlxG.save.data.lang = lang;
        FlxG.save.data.fpsCounter = fpsCounter;
        FlxG.save.data.fullscreen = fullscreen;

        FlxG.save.flush();
    }
    
    public static function init()
    {
        if (FlxG.save.data.timeFormat == null)
            FlxG.save.data.timeFormat = '%r';
        if (FlxG.save.data.theme == null)
            FlxG.save.data.theme = 'daylight';
        if (FlxG.save.data.lang == null)
            FlxG.save.data.lang = 'en';
        if (FlxG.save.data.fpsCounter == null)
            FlxG.save.data.fpsCounter = true;
        #if desktop
        if (FlxG.save.data.fullscreen == null)
            FlxG.save.data.fullscreen = false;
        #end

        FlxG.save.bind('VisionSphere', 'Joalor64');
    }
}