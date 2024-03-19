package states.games;

class ReactionGame extends FlxState
{
    var red:FlxSprite;
    var green:FlxSprite;
    var text:FlxText;

    var gameEnded:Bool = false;
    var allowInputs:Bool = false;
    var anyPressed:Bool;

    override public function create()
    {
        super.create();

        text = new FlxText(0, 0, 0, "The Reaction Game\nPress any button to start!", 32);
        text.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter(X);
        add(text);

        red = new FlxSprite().makeGraphic(250, 250, FlxColor.RED);
        green = new FlxSprite().makeGraphic(250, 250, FlxColor.GREEN);

        allowInputs = true;

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> 
            {
                FlxG.switchState(MenuState.new);
            });
        }

        if (Input.is('any') && !anyPressed && allowInputs && !gameEnded)
        {
            anyPressed = true;
            text.text = "Get ready...";
            new FlxTimer().start(4, (timer) ->
            {
                thinkFast();
            });
        }

        if (Input.is('r') && gameEnded)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                FlxG.resetState();
            });
        }

        if (!gameEnded) 
        {
            if (FlxG.mouse.overlaps(green) && FlxG.mouse.justPressed)
            {
                text.text = "Good job! You clicked the right one!\nPress R to play again.";
                gameEnded = true;
            }
            else if (FlxG.mouse.overlaps(red) && FlxG.mouse.justPressed)
            {
                text.text = "Oops! You clicked the wrong one!\nPress R to play again.";
                gameEnded = true;
            }
        }
    }

    function thinkFast()
    {
        text.text = "Think fast!";

        red.setPosition(FlxG.random.int(0, 900), FlxG.random.int(0, 720));
        green.setPosition(FlxG.random.int(0, 900), FlxG.random.int(0, 720));

        red.visible = green.visible = true;

        add(red);
        add(green);
    }
}