package states.games;

import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;

using StringTools;

// this is why subclasses are a thing
// honestly, this is just easier
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
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
	        {
	            FlxG.switchState(new states.games.TheSimpleMathGame.PlayState(0));
	        });
        });
        easyBtn.scale.set(2, 2);
        easyBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        easyBtn.label.screenCenter(XY);
        easyBtn.screenCenter(XY);
        add(easyBtn);

        var hardBtn:FlxButton = new FlxButton(0, easyBtn.y + 70, "Hard", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
	        {
	            FlxG.switchState(new states.games.TheSimpleMathGame.PlayState(1));
	        });
        });
        hardBtn.scale.set(2, 2);
        hardBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        hardBtn.label.screenCenter(XY);
        hardBtn.screenCenter(XY);
        add(hardBtn);

        var easyTimed:FlxButton = new FlxButton(0, hardBtn.y + 70, "Timed (Easy)", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
	        {
	            FlxG.switchState(new states.games.TheSimpleMathGame.PlayState(0, true));
	        });
        });
        easyTimed.scale.set(2, 2);
        easyTimed.label.setFormat(Paths.font('vcr.ttf'), 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        easyTimed.label.screenCenter(XY);
        easyTimed.screenCenter(XY);
        add(easyTimed);

        var hardTimed:FlxButton = new FlxButton(0, easyTimed.y + 70, "Timed (Hard)", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
	        {
	            FlxG.switchState(new states.games.TheSimpleMathGame.PlayState(1, true));
	        });
        });
        hardTimed.scale.set(2, 2);
        hardTimed.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        hardTimed.label.screenCenter(XY);
        hardTimed.screenCenter(XY);
        add(hardTimed);

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
    public var score:Int = 0;

    var scoreTxt:FlxText;

    var input:FlxUIInputText;

    var math:FlxText;

    var randomNum1:Float;
    var randomNum2:Int;
    var correctAnswer:Float;
    var symbol:String;

    var difficulty:Int = 0;

    var timed:Bool;
    var timeLeft:Int;
    var timeTxt:FlxText;

    public function new(difficulty:Int, ?timed:Bool)
    {
        super();
	    
        this.difficulty = difficulty;
        this.timed = timed;
    }

    override public function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/math/background'));
        add(bg);

        math = new FlxText(0, 0, FlxG.width, "", 12);
        math.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        math.screenCenter(X);
        add(math);

        input = new FlxUIInputText(10, 10, FlxG.width, '', 8);
        input.setFormat(Paths.font('vcr.ttf'), 96, FlxColor.WHITE, FlxTextAlign.CENTER);
        input.alignment = CENTER;
        input.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
        input.screenCenter(XY);
        input.y += 50;
        input.backgroundColor = 0xFF000000;
        input.lines = 1;
        input.caretColor = 0xFFFFFFFF;
        add(input);

        scoreTxt = new FlxText(5, FlxG.height - 24, 0, 'Score: $score', 12);
        scoreTxt.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(scoreTxt);

        timeTxt = new FlxText(5, FlxG.height - 44, 0, '', 12);
        timeTxt.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(timeTxt);

        if (timed == true)
            timeLeft = 120000; // two minutes in milliseconds

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

        generateQuestion();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        input.hasFocus = true;

        scoreTxt.text = 'Score: $score';

        if (FlxG.keys.justPressed.ENTER && input.text != '')
            checkAnswer();

        if (FlxG.keys.justPressed.SPACE)
            generateQuestion();

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new states.games.TheSimpleMathGame.MainMenuState());

        if (FlxG.keys.justPressed.END) // end game
            FlxG.switchState(new states.games.TheSimpleMathGame.GameOverState(score));

        if (timed == true)
        {
            timeLeft -= 1;

            timeTxt.text = 'Time Left: $timeLeft';

            if (timeLeft == 0)
                FlxG.switchState(new states.games.TheSimpleMathGame.GameOverState(score));
        }
    }

    private function generateQuestion()
    {
        randomNum1 = FlxG.random.int(0, difficulty == 1 ? 20 : 10);
        randomNum2 = FlxG.random.int(0, difficulty == 1 ? 20 : 10);

        var chance:Int = FlxG.random.int(1, 5);

        switch (chance)
        {
            case 1: // addition
                correctAnswer = randomNum1 + randomNum2;
                symbol = '+';
            case 2: // subtraction
                correctAnswer = randomNum1 - randomNum2;
                symbol = '-';
            case 3: // multiplication
                correctAnswer = randomNum1 * randomNum2;
                symbol = '*';
            case 4: // division
                correctAnswer = randomNum1 * randomNum2;
                randomNum1 = correctAnswer; // swap for division
                correctAnswer = randomNum1 / randomNum2;
                symbol = '/';
            case 5: // exponentiation
                correctAnswer = Math.pow(randomNum1, randomNum2);
                symbol = '^';
        }

        math.text = 'What is ' + '$randomNum1 $symbol $randomNum2' + ' ?';
        input.text = '';
    }

    private function checkAnswer()
    {
        var userAnswer:Float = Std.parseFloat(input.text);

        if (userAnswer == correctAnswer)
        {
            FlxG.camera.flash(FlxColor.GREEN, 1);
            FlxG.sound.play(Paths.sound('math/correct'));
            math.text = 'Correct!\nThat was the answer!';
            score += 1;
        }
        else
        {
            FlxG.camera.flash(FlxColor.RED, 1);
            FlxG.sound.play(Paths.sound('math/incorrect'));
            math.text = 'Wrong!\nThe answer was $correctAnswer!';
            score -= 1;
        }

        new FlxTimer().start(2.5, function(tmr:FlxTimer)
        {
            generateQuestion();
        });
    }
}