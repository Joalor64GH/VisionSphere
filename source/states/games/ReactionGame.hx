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

        var timer:FlxTimer;

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
            timer = new FlxTimer().start(FlxG.random.int(1, 10) * 0.1, (tmr:FlxTimer) ->
            {
                reactionTime += tmr.timeLeft;
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
                timer.cancel();
                text.text = "Good job! Your reaction time is " + formatReactionTime(reactionTime) + ".\nPress R to play again.";
                gameEnded = true;
            }
            else if (FlxG.mouse.overlaps(red) && FlxG.mouse.justPressed)
            {
                timer.cancel();
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

    function formatReactionTime(time:Float):String
    {
        var reactionTimeString:String = Std.string(time);
        var decimalIndex:Int = reactionTimeString.indexOf(".");
        if (decimalIndex != -1)
            reactionTimeString = reactionTimeString.substring(0, decimalIndex + 3);
        else 
            reactionTimeString += ".00";

        return reactionTimeString;
    }
}