package util;

import sys.io.Process;

class MacroUtil
{
    public static macro function getCommitId():haxe.macro.Expr.ExprOf<String>
    {
        var gitProcess:Process = new Process('git', ['log', '--format=%h', '-n', '1']);
        if (gitProcess.exitCode != 0)
            return macro $v{'n/a'};

        return macro $v{gitProcess.stdout.readLine().trim()};
    }

    public static macro function getBuildNum():haxe.macro.Expr.ExprOf<Int>
    {
        var buildNumber:Int = Std.parseInt(File.getContent(FileSystem.fullPath('build.txt'))) + 1;
        File.saveContent(FileSystem.fullPath('build.txt'), Std.string(buildNumber));

        return macro $v{buildNumber};
    }
}