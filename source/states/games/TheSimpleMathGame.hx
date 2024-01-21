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
    // wip
}

class PlayState extends FlxState
{
    // wip
}