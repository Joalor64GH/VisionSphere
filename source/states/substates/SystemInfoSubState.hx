package states.substates;

import util.MacroUtil;

class SystemInfoSubState extends FlxSubState
{
    public static var commitId(default, never):String = MacroUtil.get_commit_id();
    public static var buildNum(default, never):Int = MacroUtil.get_build_num();

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);

        var info:FlxText = new FlxText(0, 0, 0, 
            "VisionSphere Version: " + Application.current.meta.get('version')
            + "nBuild Number: ${buildNum}"
            + "\nBuild Commit ID: ${commitId}
            + "\nHaxeflixel Version: 5.5.0"
            + "\nHaxe Version: 4.2.5"
        , 12);
        info.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        info.screenCenter();
        add(info);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.sound.play(Paths.sound("cancel"));
            close();
        }
    }
}