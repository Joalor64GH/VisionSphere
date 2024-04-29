package backend.data;

typedef SaveSettings = {
    var timeFormat:TimeFormatSetting;
    var theme:ThemeSetting;
    var lang:String;
    var username:String;
    var profile:String;
    var framerate:Int;
    var colorBlindFilter:ColorblindFilterSetting;
    var fpsCounter:Bool;
    #if desktop
    var fullscreen:Bool;
    #end
    var keyboardBinds:Array<FlxKey>;
    var gamepadBinds:Array<FlxGamepadInputID>;
}

enum abstract TimeFormatSetting(String) {
    var TWELVEHOUR = "%r";
    var TWENTYFOURHOUR = "%T";
}

enum abstract ThemeSetting(String) {
    var DAY = "daylight";
    var NIGHT = "night";
    var SEGA = "dreamcast";
    var PLAYSTATION = "ps3";
    var WINDOWS = "xp";
    var XBOX = "xbox360";
}

enum abstract ColorblindFilterSetting(Int) {
    var OFF = -1;
    var DEUT = 0;
    var DEUT_MILD = 1;
    var PROTA = 2;
    var PROTA_MILD = 3;
    var TRITA = 4;
    var TRITA_MILD = 5;
    var ACHROMA = 6;
    var GAMEBOY = 7;
    var VIRTUAL = 8;
    var MONO = 9;
    var INVERT = 10;
    var WHY_THO = 11;
    var RANDOM = 12;
}

class SaveDataV2
{
}