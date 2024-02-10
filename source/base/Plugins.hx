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
        interp = addModulesToInterp(interp, hscriptClasses);
    }

    private static function addModulesToInterp<T:Interp>(interp:T, classes:Array<String>):T
    {
        for (file in classes)
        {
            if (FileSystem.exists(Paths.getPluginPath("scripts/" + file + ".hx")))
                interp.addModule(Paths.getPluginPath("scripts/" + file + ".hx"));
        }
        return interp;
    }

    public static function addVarstoInterp<T:Interp>(interp:T):T
    {
        var flxVars:Array<String> = [
            "FlxG",
            "FlxState",
            "FlxSubState",
            "FlxText", 
            "FlxGroup", 
            "FlxSound", 
            "FlxSprite", 
            "FlxMath",
            "FlxTimer", 
            "FlxTween", 
            "FlxEase", 
            "FlxTypedGroup", 
            "FlxAtlasFrames", 
            "FlxBasic", 
            "FlxObject"
        ];

        for (flxVar in flxVars)
            interp.variables.set(flxVar, Type.resolveClass(flxVar));

        interp.variables.set("Application", Application);
        
        #if sys
        interp.variables.set("File", File);
        interp.variables.set("FileSystem", FileSystem);
        #end
        interp.variables.set("Reflect", Reflect);
        interp.variables.set("Dynamic", Dynamic);
        interp.variables.set("StringTools", StringTools);
        interp.variables.set("DateTools", DateTools);
        interp.variables.set("String", String);
        interp.variables.set("Float", Float);
        interp.variables.set("Array", Array);
        interp.variables.set("Date", Date);
        interp.variables.set("Bool", Bool);
        interp.variables.set("Type", Type);
        interp.variables.set("Math", Math);
        interp.variables.set("Std", Std);
        interp.variables.set("Sys", Sys);
        interp.variables.set("Int", Int);

        interp.variables.set("Main", Main);
        interp.variables.set("Paths", Paths);
        interp.variables.set("Event", Event);
        interp.variables.set("Input", Input);
        interp.variables.set("CoolUtil", CoolUtil);
        interp.variables.set("SaveData", SaveData);
        interp.variables.set("Plugins", Plugins); // lol

        interp.variables.set("debug", #if debug true #else false #end);

        interp.variables.set("create", FlxG.state.create);
        interp.variables.set("update", FlxG.state.update);
        interp.variables.set("getVarFromClass", function(instance:String, variable:String)
        {
            Reflect.field(Type.resolveClass(instance), variable);
        });

        return interp;
    }
}