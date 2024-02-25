package states.games.jta;

class LevelSelectState extends FlxState
{
    var levels:Array<String> = ["Level 1", "Level 2", "Level 3"];
    var lvlGrp:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;

    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/jta/bgLevelSelect'));
        bg.screenCenter();
        add(bg);

        lvlGrp = new FlxTypedGroup<FlxText>();
        add(lvlGrp);

        for (i in 0...levels.length)
        {
            var lvlText:FlxText = new FlxText(0, 50 + (i * 120), 0, levels[i], 100);
            lvlText.screenCenter(X);
            lvlText.ID = i;
            lvlGrp.add(lvlText);
        }

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        if (Input.is('up') || Input.is('down'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (Input.is('enter'))
        {
            FlxG.sound.play(Paths.sound('confirm'));

            switch (levels[curSelected])
            {
                case "Level 1":
                    FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
                    {
                        FlxG.switchState(new states.games.jta.PlayState(1));
                    });
                case "Level 2":
                    FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
                    {
                        FlxG.switchState(new states.games.jta.PlayState(2));
                    });
                case "Level 3":
                    FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
                    {
                        FlxG.switchState(new states.games.jta.PlayState(3));
                    });
            }
        }

        if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
            {
                FlxG.switchState(new states.games.jta.MainMenuState());
            });
            FlxG.sound.play(Paths.sound('jta/exit'));
        }
    }

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = lvlGrp.length - 1;
        if (curSelected >= lvlGrp.length)
            curSelected = 0;

        lvlGrp.forEach(function(txt:FlxText) 
        {
            txt.color = (txt.ID == curSelected) ? FlxColor.CYAN : FlxColor.WHITE;
        });
    }
}