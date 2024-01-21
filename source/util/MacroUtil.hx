package util;

import sys.io.File;
import sys.FileSystem;

class MacroUtil
{
    // will fix this later
    /*
    public static macro function getCommitId(url:String):haxe.macro.Expr.ExprOf<String>
    {
        // something maybe
    }
    */

    public static macro function get_build_num():haxe.macro.Expr.ExprOf<Int>
    {
        var buildNumber:Int = Std.parseInt(File.getContent(FileSystem.fullPath('build.txt')));
        File.saveContent(FileSystem.fullPath('build.txt'), Std.string(buildNumber));

        return macro $v{buildNumber};
    }
}