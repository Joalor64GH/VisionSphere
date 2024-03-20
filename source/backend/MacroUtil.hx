package backend;

import sys.io.File;
import sys.io.Process;
import sys.FileSystem;

class MacroUtil
{
    public static macro function get_commit_id():haxe.macro.Expr.ExprOf<String>
    {
        try {
            var daProcess = new Process('git', ['log', '--format=%h', '-n', '1']);
            daProcess.exitCode(true);
            return macro $v{daProcess.stdout.readLine()};
        } catch(e) {}
        return macro $v{"-"};
    }

    public static macro function get_build_num():haxe.macro.Expr.ExprOf<Int>
    {
        try {
            var buildNumber:Int = Std.parseInt(File.getContent(FileSystem.fullPath('build.txt')));
            File.saveContent(FileSystem.fullPath('build.txt'), Std.string(buildNumber));
            return macro $v{buildNumber};
        } catch(e) {}
        return macro $v{0};
    }

    static macro function getDefine(key:String):haxe.macro.Expr
    {
        return macro $v{haxe.macro.Context.definedValue(key)};
    }

    static macro function setDefine(key:String, value:String):haxe.macro.Expr
    {
        haxe.macro.Compiler.define(key, value);
        return macro null;
    }

    static macro function isDefined(key:String):haxe.macro.Expr
    {
        return macro $v{haxe.macro.Context.defined(key)};
    }

    static macro function getDefines():haxe.macro.Expr
    {
        var defines:Map<String, String> = haxe.macro.Context.getDefines();
        var map:Array<haxe.macro.Expr> = [];
        for (key in defines.keys())
            map.push(macro $v{key} => $v{Std.string(defines.get(key))});

        return macro $a{map};
    }
}