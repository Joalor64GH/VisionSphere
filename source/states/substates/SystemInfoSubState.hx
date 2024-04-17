package states.substates;

class SystemInfoSubState extends FlxSubState
{
    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);

        var info:FlxText = new FlxText(0, 0, 0, 
            "VisionSphere Version: " + Lib.application.meta.get('version')
            + "\nVersion ID: " + CoolUtil.getText('VERSION')
            + "\nCommit ID: " + Main.commitId
            + "\nBuild Number: " + Main.buildNum
            + "\nHaxeFlixel Version: 5.7.0"
            + "\nHaxe Version: 4.3.3"
            + "\nOpenFL Version: 9.3.3"
            + "\nLime Version: 8.1.2"
        , 12);
        info.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        info.screenCenter();
        add(info);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (exit) 
        {
            FlxG.sound.play(Paths.sound("cancel"));
            close();
        }
    }
}