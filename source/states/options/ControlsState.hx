package states.options;

/**
 * @author khuonghoanghuy
 * @see https://github.com/khuonghoanghuy/FNF-Pop-Engine-Rewrite/
 */

class ControlsState extends FlxState
{
    var init:Int = 0;
    var inChange:Bool = false;
    var text1:FlxText;
    var text2:FlxText;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        var instructionsTxt:FlxText = new FlxText(5, FlxG.height - 24, 0, "Press LEFT/RIGHT to scroll through keys.", 12);
        instructionsTxt.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(instructionsTxt);

        text1 = new FlxText(0, 0, 0, "", 64);
        text1.screenCenter(Y);
        text1.x += 100;
        text1.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(text1);

        text2 = new FlxText(5, FlxG.height - 54, 0, "", 32);
        text2.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(text2);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if ((Input.is('exit') || Input.is('backspace')) && !inChange)
        {
            FlxG.switchState(new states.options.OptionsState());
            FlxG.sound.play(Paths.sound('cancel'));
            if (!Input.is('backspace'))
            {
                SaveData.saveSettings();
                trace('settings saved!');
            }
            else
                trace('settings not saved!');
        }

        if (Input.is('accept'))
        {
            inChange = true;
            text2.text = "PRESS ANY KEY TO CONTINUE";
        }

        if (Input.is('left') && !inChange)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            if (init == 0)
                init = 5;
            else
                init--;
        }

        if (Input.is('right') && !inChange)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            if (init == 5)
                init = 0;
            else
                init++;
        }

        switch (init)
        {
            case 0:
                text1.text = "LEFT KEY: " + SaveData.leftKey;
            case 1:
                text1.text = "RIGHT KEY: " + SaveData.rightKey;
            case 2:
                text1.text = "DOWN KEY: " + SaveData.downKey;
            case 3:
                text1.text = "UP KEY: " + SaveData.upKey;
            case 4:
                text1.text = "ACCEPT KEY: " + SaveData.acceptKey;
            case 5:
                text1.text = "EXIT KEY: " + SaveData.exitKey;
        }

        if (inChange)
        {
            if (!Input.is('accept') && !Input.is('exit') && Input.is('any')) 
            {
                switch (init)
                {
                    case 0:
                        SaveData.leftKey = FlxG.keys.getIsDown()[0].ID.toString();
                        Input.actionMap.set("left", SaveData.leftKey);
                    case 1:
                        SaveData.rightKey = FlxG.keys.getIsDown()[0].ID.toString();
                        Input.actionMap.set("right", SaveData.rightKey);
                    case 2:
                        SaveData.downKey = FlxG.keys.getIsDown()[0].ID.toString();
                        Input.actionMap.set("down", SaveData.downKey);
                    case 3:
                        SaveData.upKey = FlxG.keys.getIsDown()[0].ID.toString();
                        Input.actionMap.set("up", SaveData.upKey);
                    case 4:
                        SaveData.acceptKey = FlxG.keys.getIsDown()[0].ID.toString();
                        Input.actionMap.set("accept", SaveData.acceptKey);
                    case 5:
                        SaveData.exitKey = FlxG.keys.getIsDown()[0].ID.toString();
                        Input.actionMap.set("exit", SaveData.exitKey);
                }
                FlxG.sound.play(Paths.sound('scroll'));
                text2.text = "";
                inChange = false;
            }
        }
    }
}