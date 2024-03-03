package states;

import haxe.Exception;
import haxe.CallStack;

import flixel.addons.display.FlxBackdrop;

class CrashState extends FlxState
{
    var error:Exception;
    var checker:FlxBackdrop = new FlxBackdrop(Paths.image('game/grid') #if (flixel_addons < "3.0.0"), 0.2, 0.2, true, true #end);

    public function new(error:Exception)
    {
        super();
        this.error = error;
    }

    override public function create()
    {
        super.create();

        checker.scrollFactor.set(0.07, 0);
        add(checker);

        var title:Alphabet = new Alphabet(25, 25, "VisionSphere - Uncaught Error!", true);
        add(title);

        var emsg:String = error.toString() + "\n\n";
        for (stackItem in CallStack.exceptionStack(true))
        {
            switch (stackItem)
            {
                case FilePos(s, file, line, column):
                    emsg += file + " (line " + line + ")\n";
                default:
                    #if sys
                    Sys.println(stackItem);
                    #else
                    trace(stackItem);
                    #end
            }
        }

        #if desktop
        if (!FileSystem.exists("./crash/"))
            FileSystem.createDirectory("./crash/");
            
        var path:String = "./crash/" + "VisionSphere_" + Date.now().toString().replace(" ", "_").replace(":", "'") + ".txt";
        File.saveContent(path, emsg + "\n");

        emsg += "\n\nA crash report has been saved to " + path + ".";
        #end

        emsg += "\n\nPlease report this error to the GitHub page: https://github.com/Joalor64GH/VisionSphere\n\nPress Q to quit the game.\nOtherwise, press R to restart.";

        var msg:FlxText = new FlxText(25, title.members[0].height + 50, FlxG.width - 50, emsg).setFormat(Paths.font('vcr.ttf'), 24, 0xffffffff, LEFT, OUTLINE, 0xff000000);
        msg.borderSize = 2;
        add(msg);

        FlxG.sound.play(Paths.sound('crash'));
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        checker.x -= 0.45;
        checker.y -= 0.16;

        if (Input.is('q'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                #if (sys || cpp)
                Sys.exit(0);
                #else
                openfl.system.System.exit(0);
                #end
            });
        }
        else if (Input.is('r'))
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
    }
}