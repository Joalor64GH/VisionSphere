package states.games.tetris;

class MainMenuState extends FlxState 
{
    var playBtn:FlxSprite;
    var exitBtn:FlxSprite;

    var playSelect:Bool = true;

    override public function create()
    {
        super.create();

        var daLogo:FlxSprite = new FlxSprite(0, 30).loadGraphic(Paths.image('game/teturisu/logo'));
        daLogo.screenCenter(X);
        add(daLogo);

        playBtn = new FlxSprite(FlxG.width * 0.28, FlxG.height * 0.7).loadGraphic(Paths.image('game/teturisu/buttons'), true, 200, 200);
        playBtn.animation.add('idle', [0], 1);
        playBtn.animation.add('selected', [1], 1);
        playBtn.animation.play('selected');
        add(playBtn);

        exitBtn = new FlxSprite(FlxG.width * 0.58, playBtn.y).loadGraphic(Paths.image('game/teturisu/buttons'), true, 200, 200);
        exitBtn.animation.add('idle', [2], 1);
        exitBtn.animation.add('selected', [3], 1);
        exitBtn.animation.play('idle');
        add(exitBtn);

        var scoreTxt:FlxText = new FlxText(5, FlxG.height - 444, 0, 
            'Controls:\nRight/Left/Down - Move Piece\nUp - Rotate Clockwise\nZ - Rotate Counterclockwise\nC - Hold Piece\nEnter/Space - Drop Piece', 12);
        scoreTxt.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(scoreTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('left') || Input.is('right'))
            changeSelection();

        if (Input.is('accept'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState((playSelect) ? new states.games.tetris.PlayState() : new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('confirm'));
        }
    }

    function changeSelection():Void
    {
        playSelect = !playSelect;

        exitBtn.animation.play((playSelect) ? 'idle' : 'selected');
        playBtn.animation.play((playSelect) ? 'selected' : 'idle');
    }
}