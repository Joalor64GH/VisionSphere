package base;

import hscript.Interp;
import hscript.InterpEx;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.sound.FlxSound;
import flixel.graphics.frames.FlxAtlasFrames;

class Plugins
{
    public static var interp = new InterpEx();
    public static var hscriptClasses:Array<String> = [];

    @:access(hscript.InterpEx)
    public static function init()
    {
        if (!FileSystem.exists(Paths.getPluginPath("config.txt")))
            return;

        hscriptClasses = CoolUtil.getText(Paths.getPluginPath("config.txt"));
        interp = addVarstoInterp(interp);

        for (file in hscriptClasses)
        {
            if (FileSystem.exists(Paths.getPluginPath("scripts/" + file + ".hx")))
                interp.addModule(Paths.getPluginPath("scripts/" + file + ".hx"));
        }

        trace(InterpEx._scriptClassDescriptors);
    }

    public static function addVarstoInterp<T:Interp>(interp:T):T
    {
        interp.variables.set("FlxG", FlxG);
        interp.variables.set("FlxState", FlxState);
        interp.variables.set("FlxSubState", FlxSubState);
        interp.variables.set("FlxText", FlxText);
        interp.variables.set("FlxGroup", FlxGroup);
        interp.variables.set("FlxSound", FlxSound);
        interp.variables.set("FlxSprite", FlxSprite);
        interp.variables.set("FlxMath", FlxMath);
        interp.variables.set("FlxTimer", FlxTimer);
        interp.variables.set("FlxTween", FlxTween);
        interp.variables.set("FlxEase", FlxEase);
        interp.variables.set("FlxSprite", FlxSprite);
        interp.variables.set("FlxTypedGroup", FlxTypedGroup);
        interp.variables.set("FlxAtlasFrames", FlxAtlasFrames);
        interp.variables.set("FlxSprite", FlxSprite);
        interp.variables.set("FlxBasic", FlxBasic);
        interp.variables.set("FlxObject", FlxObject);
        interp.variables.set("Application", Application);
        #if sys
        interp.variables.set("File", File);
        interp.variables.set("FileSystem", FileSystem);
        #end
        interp.variables.set("Reflect", Reflect);
        interp.variables.set("StringTools", StringTools);
        interp.variables.set("Math", Math);
        interp.variables.set("Std", Std);
        interp.variables.set("Sys", Sys);

        interp.variables.set("Main", Main);
        interp.variables.set("Paths", Paths);
        interp.variables.set("Event", Event);
        interp.variables.set("Input", Input);
        interp.variables.set("CoolUtil", CoolUtil);
        interp.variables.set("SaveData", SaveData);
        interp.variables.set("Plugins", Plugins); // lol

        interp.variables.set("debug", #if debug true #else false #end);

        interp.variables.set("getVarFromClass", function(instance:String, variable:String)
        {
            Reflect.field(Type.resolveClass(instance), variable);
        });

        return interp;
    }
}