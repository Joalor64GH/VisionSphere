package util;

class SaveData
{
    public static function init()
    {
        if (FlxG.save.data.timeFormat == null)
            FlxG.save.data.timeFormat = '%r';

        if (FlxG.save.data.lang == null)
            FlxG.save.data.lang = 'en';

        if (FlxG.save.data.fpsCounter == null)
            FlxG.save.data.fpsCounter = true;

        if (FlxG.save.data.theme == null)
            FlxG.save.data.theme = 'daylight';

        #if desktop
        if (FlxG.save.data.fullscreen == null)
            FlxG.save.data.fullscreen = false;
        #end

        FlxG.save.bind('VisionSphere', 'Joalor64');
    }
}