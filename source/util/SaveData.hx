package util;

import hscript.Parser;
import hscript.Interp;

import flixel.util.FlxSave;

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
    public static var colorBlindFilter:String = "None";
    public static var framerate:Int = 60;
    public static var username:String = "user";
    public static var profile:String = "default";
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
        FlxG.save.data.colorBlindFilter = colorBlindFilter;
        FlxG.save.data.framerate = framerate;
        FlxG.save.data.username = username;
        FlxG.save.data.profile = profile;
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
        if (FlxG.save.data.colorBlindFilter != null)
            colorBlindFilter = FlxG.save.data.colorBlindFilter;
        if (FlxG.save.data.username != null)
            username = FlxG.save.data.username;
        if (FlxG.save.data.profile != null)
            profile = FlxG.save.data.profile;
        if (FlxG.save.data.framerate != null)
            framerate = FlxG.save.data.framerate;
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

    static var currentSaveSlot:Int = 0;
    public static function getSaveData(saveToRetuen:Int)
    {
        if (saveToReturn == -1 || saveToReturn == 0)
            return FlxG.save;

        var save:FlxSave = new FlxSave();
        save.bind('saveSlot_${saveToReturn}', 'Joalor64');
        save.flush();
        return save;
    }

    public static function changeSaveData(saveToLoad:Int)
    {
        currentSaveSlot = saveToLoad;
    }

    public static function resetSaveData(saveToReset:Int)
    {
        var save:FlxSave = getSaveData(saveToReset);
        save.data.loaded = false;
        save.flush();
        save.erase();
    }

    private static var haxeInterp:Interp = new Interp();
    private static var haxeParser:Parser = new Parser();

    public static function saveToSlot(variableNameInSave:String, variable:Any)
    {
        var save:FlxSave = getSaveData(currentSaveSlot);
        haxeInterp.variables.set('save', save);
        haxeInterp.variables.set('variable', variable);
        var toParse = haxeParser.parseString('save.data.$variableNameInSave = variable;\nsave.flush();');
        haxeInterp.execute(toParse);
    }

    public static function loadDataFromSaveSlot(variableNameInSave:String):Any
    {
        var save:FlxSave = getSaveData(currentSaveSlot);
        haxeInterp.variables.set('save', save);
        var toParse = haxeParser.parseString('return save.data.$variableNameInSave;');
        return haxeInterp.execute(toParse);
    }
}