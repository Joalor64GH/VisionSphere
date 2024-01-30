package base;

import Reflect;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

import openfl.utils.Assets;
import openfl.Lib;

class State extends FlxState 
{
    public var script:Script;

    override function create()
    {
        super.create();

        startScript();

        if (script != null)
            script.executeFunc("onCreate");
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (script != null)
            script.executeFunc("onUpdate");
    }

    override function destroy()
    {
        if (script != null) {
            script.executeFunc("destroy");
            script.destroy();
        }

        super.destroy();
    }

    public function startScript()
    {
        var path:String = null;
        var files:Array<String> = [Paths.getPreloadPath('scripts/')];

        #if MODS_ALLOWED
        files.insert(0, Paths.mods('scripts/'));
        if (Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
            files.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));
        #end

        for (folder in files) {
            if (FileSystem.exists(folder)) {
                for (file in FileSystem.readDirectory(folder)) {
                    if (file.toLowerCase().endsWith('.hx'))
                        path = folder + file;
                }
            }
        }

        var hxData:String = "";

        if (Assets.exists(path))
            hxData = Assets.getText(path);

        if (hxData != null)
        {
            script = new Script();

            script.setVariable("onCreate", function() 
            {
            });

            script.setVariable("onUpdate", function() 
            {
            });

            script.setVariable("destroy", function() 
            {
            });

            script.setVariable("import", function(daClass:String, ?asDa:Null<String>)
            {
                final splitClassName:Array<String> = [for (e in daClass.split('.')) e.trim()];
                final className:String = splitClassName.join('.');
                final daClass:Class<Dynamic> = Type.resolveClass(className);
                final daEnum:Enum<Dynamic> = Type.resolveEnum(className);

                if (daClass == null && daEnum == null)
                    Lib.application.window.alert('Class / Enum at $className does not exist.', 'Hscript Error!');
                else 
                {
                    if (daEnum != null)
                    {
                        var daEnumField = {};
                        for (daConstructor in daEnum.getConstructors())
                            Reflect.setField(daEnumField, daConstructor, daEnum.createByName(daConstructor));
                        
                        if (asDa != null && asDa != '')
                            script.setVariable(asDa, daEnumField);
                        else
                            script.setVariable(splitClassName[splitClassName.length - 1], daEnumField);
                    }
                    else
                    {
                        if (asDa != null && asDa != '')
                            script.setVariable(asDa, daClass);
                        else
                            script.setVariable(splitClassName[splitClassName.length - 1], daClass);
                    }
                }
            });

            script.setVariable("fromRGB", function(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255) 
            {
                return FlxColor.fromRGB(Red, Green, Blue, Alpha);
            });

            script.setVariable("getClass", function(name:String) {
                return Type.resolveClass(name);
            });

            script.setVariable("getEnum", function(name:String) {
                return Type.resolveEnum(name);
            });

            // i'm being generous with these
            #if sys
            script.setVariable("File", File);
            script.setVariable("FileSystem", FileSystem);
            #end
            script.setVariable("FlxBasic", FlxBasic);
            script.setVariable("FlxGroup", FlxGroup);
            script.setVariable("FlxTypedGroup", FlxTypedGroup);
            script.setVariable("FlxTween", FlxTween);
            script.setVariable("FlxEase", FlxEase);
            script.setVariable("FlxSprite", FlxSprite);
            script.setVariable("FlxMath", FlxMath);
            script.setVariable("FlxState", FlxState);
            script.setVariable("FlxSubState", FlxSubState);
            script.setVariable("FlxObject", FlxObject);
            script.setVariable("FlxText", FlxText);
            script.setVariable("Math", Math);
            script.setVariable("FlxG", FlxG);
            script.setVariable("Input", Input);
            script.setVariable("Event", Event);
            script.setVariable("Paths", Paths);
            script.setVariable("Script", Script);
            script.setVariable("CoolUtil", CoolUtil);
            script.setVariable("Alphabet", Alphabet);
            script.setVariable("AttachedSprite", AttachedSprite);
            script.setVariable("FlxTimer", FlxTimer);
            script.setVariable("Main", Main);
            script.setVariable("StringTools", StringTools);
            script.setVariable("Reflect", Reflect);
            script.setVariable("DateTools", DateTools);
            script.setVariable("Date", Date);
            script.setVariable("Std", Std);
            script.setVariable("Sys", Sys);
            script.setVariable("Type", Type);

            script.runScript(hxData);
        }
    }
}