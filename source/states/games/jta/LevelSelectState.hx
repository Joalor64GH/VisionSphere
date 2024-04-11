package states.games.jta;

class LevelSelectState extends FlxState
{
    var levels:Array<String> = ["Level 1", "Level 2", "Level 3"];
    var lvlGrp:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;

    override public function create()
    {   
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/jta/bgLevelSelect'));
        bg.screenCenter();
        add(bg);

        lvlGrp = new FlxTypedGroup<FlxText>();
        add(lvlGrp);

        for (i in 0...levels.length)
        {
            var lvlText:FlxText = new FlxText(0, 50 + (i * 130), 0, levels[i], 100);
            lvlText.screenCenter(X);
            lvlText.ID = i;
            lvlGrp.add(lvlText);
        }

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var up = Input.is('up') || (gamepad != null ? Input.gamepadIs('gamepad_up') : false);
        var down = Input.is('down') || (gamepad != null ? Input.gamepadIs('gamepad_down') : false);
        var accept = Input.is('enter') || (gamepad != null ? Input.gamepadIs('a') : false);
        var exit = Input.is('escape') || (gamepad != null ? Input.gamepadIs('b') : false);

        if (up || down)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(up ? -1 : 1);
        }

        if (accept)
        {
            FlxG.sound.play(Paths.sound('jta/play'));
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> 
            {
                switch (levels[curSelected])
                {
                    case "Level 1":
                        FlxG.switchState(new states.games.jta.PlayState(1));
                    case "Level 2":
                        FlxG.switchState(new states.games.jta.PlayState(2));
                    case "Level 3":
                        FlxG.switchState(new states.games.jta.PlayState(3));
                }
            });
        }

        if (exit)
        {
            FlxG.sound.play(Paths.sound('jta/exit'));
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
        }
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, levels.length - 1);

        lvlGrp.forEach((txt:FlxText) ->
        {
            txt.color = (txt.ID == curSelected) ? FlxColor.CYAN : FlxColor.WHITE;
        });
    }
}