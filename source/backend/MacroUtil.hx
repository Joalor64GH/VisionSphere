package backend;

import sys.io.File;
import sys.FileSystem;

import haxe.macro.Expr;
import haxe.macro.Context;

class MacroUtil
{
    /**
     * @author Leather128
     * @see https://github.com/Leather128/FabricEngine/
     */
    
    public static macro function get_commit_id():Expr.ExprOf<String>
    {
        try {
            var daProcess = new sys.io.Process('git', ['log', '--format=%h', '-n', '1']);
            daProcess.exitCode(true);
            return macro $v{daProcess.stdout.readLine()};
        } catch(e) {}
        return macro $v{"-"};
    }

    public static macro function get_build_num():Expr.ExprOf<Int>
    {
        try {
            var buildNumber:Int = Std.parseInt(File.getContent(FileSystem.fullPath('build.txt')));
            File.saveContent(FileSystem.fullPath('build.txt'), Std.string(buildNumber));
            return macro $v{buildNumber};
        } catch(e) {}
        return macro $v{0};
    }

    /**
     * @author khuonghoanghuy
     * @see https://github.com/Cool-Team-Development/Simple-Clicker-Game/
     */

    static macro function getDefine(key:String):Expr
    {
        return macro $v{Context.definedValue(key)};
    }

    static macro function setDefine(key:String, value:String):Expr
    {
        haxe.macro.Compiler.define(key, value);
        return macro null;
    }

    static macro function isDefined(key:String):Expr
    {
        return macro $v{Context.defined(key)};
    }

    static macro function getDefines():Expr
    {
        var defines:Map<String, String> = Context.getDefines();
        var map:Array<Expr> = [];
        for (key in defines.keys())
            map.push(macro $v{key} => $v{Std.string(defines.get(key))});

        return macro $a{map};
    }
}