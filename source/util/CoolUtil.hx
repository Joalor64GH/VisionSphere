package;

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
}