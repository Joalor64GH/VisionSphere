package states.games;

class ReactionGame extends FlxState
{
    var reactionTime:Float = 0;

    var red:FlxSprite;
    var green:FlxSprite;

    var text:FlxText;

    var gameEnded:Bool = false;
    var allowInputs:Bool = false;
    var anyPressed:Bool;

    override public function create()
    {
        super.create();

        text = new FlxText(0, 0, 0, "The Reaction Game\nClick to start!", 64);
        text.screenCenter(X);
        add(text);

        red = new FlxSprite().makeGraphic(150, 150, FlxColor.RED);
        green = new FlxSprite().makeGraphic(150, 150, FlxColor.GREEN);

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

        if (allowInputs && !gameEnded)
        {
            if (Input.is('any') && !anyPressed)
            {
                anyPressed = true;
                text.text = "Get ready...";
                new FlxTimer().start(FlxG.random.float(1, 10), (timer) ->
                {
                    reactionTime += (gameEnded) ? 0 : elapsed;
                    thinkFast();
                });
            }
        }

        if (Input.is('r') && gameEnded)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                FlxG.resetState();
            });
        }

        if (FlxG.mouse.overlaps(green) && FlxG.mouse.pressed)
        {
            text.text = "Good job! Your reaction time is " + reactionTime + "\nPress R to play again.";
            gameEnded = true;
        }
        else if (FlxG.mouse.overlaps(red) && FlxG.mouse.pressed)
        {
            text.text = "Oops! You clicked the wrong one!\nPress R to play again.";
            gameEnded = true;
        }
    }

    function thinkFast()
    {
        text.text = "Think fast!";

        red.setPosition(FlxG.random.int(-1280, 1280), FlxG.random.int(-720, 720));
        green.setPosition(FlxG.random.int(-1280, 1280), FlxG.random.int(-720, 720));

        add(red);
        add(green);

        new FlxTimer().start(FlxG.random.float(1, 10), (timer) ->
        {
            didntClick();
        });
    }

    function didntClick()
    {
        text.text = "Oops! You didn't click in time!\nPress R to play again.";
        gameEnded = true;
    }
}