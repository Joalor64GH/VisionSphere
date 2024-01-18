package util;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

class MacroUtil
{
    // will fix this later
    /*
    public static macro function getCommitId(url:String):haxe.macro.Expr.ExprOf<String>
    {
        var apiUrl = "https://api.github.com/repos/" + url.split("/").pop() + "/commits";
        var response = new haxe.Http(apiUrl).request(false);
        var commits:Array<Dynamic> = Json.parse(response.data);

        return macro $v{commits[0].sha};
    }
    */

    public static macro function get_build_num():haxe.macro.Expr.ExprOf<Int>
    {
        var buildNumber:Int = Std.parseInt(File.getContent(FileSystem.fullPath('build.txt'))) + 1;
        File.saveContent(FileSystem.fullPath('build.txt'), Std.string(buildNumber));

        return macro $v{buildNumber};
    }
}