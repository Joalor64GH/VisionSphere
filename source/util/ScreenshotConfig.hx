package util;

import flixel.input.keyboard.FlxKey;
import screenshotplugin.ScreenshotPlugin;

class ScreenshotConfig
{
    public static function setScreenshotConfig(format:FileFormatOption, bind:FlxKey)
    {
        ScreenshotPlugin.screenshotKey = bind;
        ScreenshotPlugin.saveFormat = format;
    }
}