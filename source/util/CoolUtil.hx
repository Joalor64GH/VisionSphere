package util;

import openfl.utils.Assets;

using StringTools;

class CoolUtil
{
    inline public static function getText(path:String):Array<String> {
        return Assets.exists(path) ? [for (i in Assets.getText(path).trim().split('\n')) i.trim()] : [];
    }

    inline static public function textSplit(path:String) {
        return [for (i in Assets.getText(path).trim().split('\n')) i.trim()];
    }

    inline public static function boundTo(value:Float, min:Float, max:Float):Float {
        return Math.max(min, Math.min(max, value));
    }

    inline public static function browserLoad(site:String) {
        #if linux
        Sys.command('/usr/bin/xdg-open', [site]);
        #else
        FlxG.openURL(site);
        #end
    }

    inline public static function colorFromString(color:String):FlxColor {
        var hideChars = ~/[\t\n\r]/;
        var color:String = hideChars.split(color).join('').trim();
        if (color.startsWith('0x')) color = color.substr(4);

        var colorNum:Null<FlxColor> = FlxColor.fromString(color);
        if (colorNum == null) colorNum = FlxColor.fromString('#$color');
        return colorNum != null ? colorNum : FlxColor.WHITE;
    }

    /**
     * @author MemeHoovy
     * @see https://github.com/Hoovy-Team/AdventureHaxe/
     */

    inline public static function isPowerOfTwo(value:Int):Bool {
        return value != 0 ? ((value & -value) == value) : false;
    }

    inline public static function hypotenuse(a:Float, b:Float) {
        return Math.sqrt(a * 2 + b * 2);
    }

    /**
     * @author MAJigsaw77
     * @see https://github.com/MAJigsaw77/UTF
     */

    public static function getWeather():Int {
        final curDate:Date = Date.now();

        switch(curDate.getMonth() + 1)
        {
            case 12 | 1 | 2: // winter
                return 1;
            case 3 | 4 | 5: // spring
                return 2;
            case 6 | 7 | 8: // summer
                return 3;
            case 9 | 10 | 11: // autumn
                return 4;
        }

        return 0;
    }
}