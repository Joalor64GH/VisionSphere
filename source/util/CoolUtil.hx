package util;

import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets as LimeAssets;

using StringTools;

// epic functions!!
class CoolUtil
{
    inline public static function getText(path:String):Array<String> {
        return (OpenFlAssets.exists(path)) ? [for (i in OpenFlAssets.getText(path).trim().split('\n')) i.trim()] : [];
    }

    inline static public function textSplit(path:String) {
        return [for (i in LimeAssets.getText(path).trim().split('\n')) i.trim()];
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

    /*
     * @author MemeHoovy
     * @see https://github.com/Hoovy-Team/AdventureHaxe/
     */

    inline public static function isPowerOfTwo(value:Int):Bool {
        return value != 0 ? ((value & -value) == value) : false;
    }

    inline public static function hypotenuse(a:Float, b:Float) {
        return Math.sqrt(a * 2 + b * 2);
    }

    /*
     * @author Leather128
     * @see https://github.com/Leather128/LeatherEngine
     */

    public static var byteFormats:Array<Array<Dynamic>> = [
        ["$bytes b", 1.0],
        ["$bytes kb", 1024.0],
        ["$bytes mb", 1048576.0],
        ["$bytes gb", 1073741824.0],
        ["$bytes tb", 1099511627776.0]
    ];

    public static function formatBytes(bytes:Float, onlyValue:Bool = false, precision:Int = 2):String
    {
        var formattedBytes:String = "?";

        for (i in 0...byteFormats.length)
        {
            if (byteFormats.length > i + 1 && byteFormats[i + 1][1] < bytes)
                continue;

            var format:Array<Dynamic> = byteFormats[i];

            formattedBytes = (!onlyValue) ? StringTools.replace(format[0], "$bytes", Std.string(FlxMath.roundDecimal(bytes / format[1], precision))) : Std.string(FlxMath.roundDecimal(bytes / format[1], precision));

            break;
        }

        return formattedBytes;
    }
}