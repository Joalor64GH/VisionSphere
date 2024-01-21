package states.games;

import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;

using StringTools;

// this is why subclasses are a thing
class MainMenuState extends FlxState
{
    override public function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/math/background'));
        add(bg);

        var titleTxt:FlxText = new FlxText(0, 0, 0, "The Simple Math Game", 12);
        titleTxt.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        titleTxt.screenCenter(X);
        add(titleTxt);

        var easyBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Easy", function()
        {
            return;
        });
        easyBtn.scale.set(2, 2);
        easyBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        easyBtn.label.screenCenter(XY);
        easyBtn.screenCenter(XY);
        add(easyBtn);

        var hardBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Hard", function()
        {
            return;
        });
        hardBtn.scale.set(2, 2);
        hardBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        hardBtn.label.screenCenter(XY);
        hardBtn.screenCenter(XY);
        add(hardBtn);

        var easyTimed:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Timed (Easy)", function()
        {
            return;
        });
        easyTimed.scale.set(2, 2);
        easyTimed.label.setFormat(Paths.font('vcr.ttf'), 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        easyTimed.label.screenCenter(XY);
        easyTimed.screenCenter(XY);
        add(easyTimed);

        var hardTimed:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Timed (Hard)", function()
        {
            return;
        });
        hardTimed.scale.set(2, 2);
        hardTimed.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        hardTimed.label.screenCenter(XY);
        hardTimed.screenCenter(XY);
        add(hardTimed);

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

class GameOverState extends FlxState
{
    var finalScore:Int;

    public function new(finalScore:Int)
    {
        super();
        this.finalScore = finalScore;
    }

    override public function create()
    {
        super.create();

        var text:FlxText = new FlxText(0, 0, 0, "Game Over!\nYour final score is $finalScore" + ".\nGood Job!", 12);
        text.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter(X);
        add(text);

        var menuBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Easy", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
	        {
	            FlxG.switchState(new states.games.TheSimpleMathGame.MainMenuState());
	        });
        });
        menuBtn.scale.set(2, 2);
        menuBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        menuBtn.label.screenCenter(XY);
        menuBtn.screenCenter(XY);
        add(menuBtn);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}

class PlayState extends FlxState
{
    // wip
}