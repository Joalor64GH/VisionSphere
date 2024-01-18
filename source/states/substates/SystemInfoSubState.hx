package states.substates;

import util.MacroUtil;

class SystemInfoSubState extends FlxSubState
{
    public static var commitId(default, never):String = MacroUtil.getCommitId();
    public static var buildNum(default, never):Int = MacroUtil.getBuildNum();

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);

        var info:FlxText = new FlxText(0, 0, 0, "Hello World", 12);
        info.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        info.screenCenter();
        add(info);
    }
}