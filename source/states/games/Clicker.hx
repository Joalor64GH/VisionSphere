package states.games;

import flixel.ui.FlxButton;

class MainMenuState extends FlxState
{
    override public function create()
    {
        var logo:FlxSprite = new FlxSprite().loadGraphic('game/2048/logo');
        logo.screenCenter(X);
        add(logo);

        var playBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Play", function()
        {
            return;
        });
        playBtn.scale.set(2, 2);
        playBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        playBtn.label.screenCenter();
        playBtn.screenCenter();
        add(playBtn);

        var exitBtn:FlxButton = new FlxButton(0, playBtn.y + 70, "Exit", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
	        {
	            FlxG.switchState(new states.MenuState());
	        });
        });
        exitBtn.scale.set(2, 2);
        exitBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        exitBtn.label.screenCenter();
        exitBtn.screenCenter();
        add(exitBtn);

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }
}

class PlayState extends FlxState
{
    var number:FlxSprite;
    var infinity:FlxSprite;

    var clicks:Int = 0;
    var clicksTxt:FlxText;

    var coolText:FlxText;

    public var win:Bool = false;
    public var cheat:Bool = false;

    override public function create()
    {
        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}

class WinState extends FlxState
{
    // wip
}