package util;

import sys.io.File;
import sys.io.Process;
import sys.FileSystem;

class MacroUtil
{
    public static macro function get_commit_id():haxe.macro.Expr.ExprOf<String>
    {
        var daProcess = new Process('git', ['log', '--format=%h', '-n', '1']);
        daProcess.exitCode(true);

        return macro $v{daProcess.stdout.readLine()};
    }

    public static macro function get_build_num():haxe.macro.Expr.ExprOf<Int>
    {
        var buildNumber:Int = Std.parseInt(File.getContent(FileSystem.fullPath('build.txt')));
        File.saveContent(FileSystem.fullPath('build.txt'), Std.string(buildNumber));

        return macro $v{buildNumber};
    }
}