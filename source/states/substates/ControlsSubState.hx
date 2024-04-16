package states.substates;

import flixel.input.gamepad.FlxGamepadInputID;

/**
 * @author khuonghoanghuy
 * @see https://github.com/khuonghoanghuy/FNF-Pop-Engine-Rewrite/
 */

class ControlsSubState extends FlxSubState
{
    var init:Int = 0;
    var inChange:Bool = false;
    var keyboardMode:Bool = true;
    var controllerSpr:FlxSprite;
    var text1:FlxText;
    var text2:FlxText;

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        bg.alpha = 0.65;
        add(bg);

        controllerSpr = new FlxSprite(50, 40).loadGraphic(Paths.image('controllertype'), true, 82, 60);
        controllerSpr.animation.add('keyboard', [0], 1, false);
        controllerSpr.animation.add('gamepad', [1], 1, false);
        add(controllerSpr);

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

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        controllerSpr.animation.play(keyboardMode ? 'keyboard' : 'gamepad');
        if (FlxG.mouse.overlaps(controllerSpr))
        {
            if (FlxG.mouse.justPressed) 
            {
                keyboardMode = !keyboardMode;
                if (gamepad != null)
                    FlxG.sound.play(Paths.sound('confirm'));
                else if (gamepad == null)
                {
                    keyboardMode = true;
                    FlxG.sound.play(Paths.sound('cancel'));
                    Main.toast.create("Can't do that.", 0xFFFFFF00, "Connect a controller to edit your gamepad controls.");
                }
            }
        }

        if (keyboardMode) 
        {
            if ((Input.is('exit') || Input.is('backspace')) && !inChange) 
                close();

            if (Input.is('accept'))
            {
                inChange = true;
                text2.text = "PRESS ANY KEY TO CONTINUE";
            }

            if (Input.is('left') && !inChange)
            {
                FlxG.sound.play(Paths.sound('scroll'));
                (init == 0) ? init = 5 : init--;
            }

            if (Input.is('right') && !inChange)
            {
                FlxG.sound.play(Paths.sound('scroll'));
                (init == 5) ? init = 0 : init++;
            }

            switch (init)
            {
                case 0:
                    text1.text = 'LEFT KEY: ${SaveData.getData('keyboardBinds')[0]}';
                case 1:
                    text1.text = 'DOWN KEY: ${SaveData.getData('keyboardBinds')[1]}';
                case 2:
                    text1.text = 'UP KEY: ${SaveData.getData('keyboardBinds')[2]}';
                case 3:
                    text1.text = 'RIGHT KEY: ${SaveData.getData('keyboardBinds')[3]}';
                case 4:
                    text1.text = 'ACCEPT KEY: ${SaveData.getData('keyboardBinds')[4]}';
                case 5:
                    text1.text = 'EXIT KEY: ${SaveData.getData('keyboardBinds')[5]}';
            }

            if (inChange)
            {
                if (!Input.is('accept') && !Input.is('exit') && Input.is('any')) 
                {
                    switch (init)
                    {
                        case 0:
                            SaveData.saveData(SaveData.getData('keyboardBinds')[0], FlxG.keys.getIsDown()[0].ID.toString());
                            Input.actionMap.set("left", SaveData.getData('keyboardBinds')[0]);
                        case 1:
                            SaveData.saveData(SaveData.getData('keyboardBinds')[1], FlxG.keys.getIsDown()[0].ID.toString());
                            Input.actionMap.set("down", SaveData.getData('keyboardBinds')[1]);
                        case 2:
                            SaveData.saveData(SaveData.getData('keyboardBinds')[2], FlxG.keys.getIsDown()[0].ID.toString());
                            Input.actionMap.set("up", SaveData.getData('keyboardBinds')[2]);
                        case 3:
                            SaveData.saveData(SaveData.getData('keyboardBinds')[3], FlxG.keys.getIsDown()[0].ID.toString());
                            Input.actionMap.set("right", SaveData.getData('keyboardBinds')[3]);
                        case 4:
                            SaveData.saveData(SaveData.getData('keyboardBinds')[4], FlxG.keys.getIsDown()[0].ID.toString());
                            Input.actionMap.set("accept", SaveData.getData('keyboardBinds')[4]);
                        case 5:
                            SaveData.saveData(SaveData.getData('keyboardBinds')[5], FlxG.keys.getIsDown()[0].ID.toString());
                            Input.actionMap.set("exit", SaveData.getData('keyboardBinds')[5]);
                    }
                    FlxG.sound.play(Paths.sound('scroll'));
                    text2.text = "";
                    inChange = false;
                }
            }
        }
        else if (!keyboardMode)
        {
            if (gamepad != null)
            {
                if (Input.gamepadIs('gamepad_exit') && !inChange) 
                    close();

                if (Input.gamepadIs('gamepad_accept'))
                {
                    inChange = true;
                    text2.text = "PRESS ANY KEY TO CONTINUE";
                }

                if (Input.gamepadIs('gamepad_left') && !inChange)
                {
                    FlxG.sound.play(Paths.sound('scroll'));
                    (init == 0) ? init = 5 : init--;
                }

                if (Input.gamepadIs('gamepad_right') && !inChange)
                {
                    FlxG.sound.play(Paths.sound('scroll'));
                    (init == 5) ? init = 0 : init++;
                }

                switch (init)
                {
                    case 0:
                        text1.text = 'LEFT KEY: ${SaveData.getData('gamepadBinds')[0]}';
                    case 1:
                        text1.text = 'DOWN KEY: ${SaveData.getData('gamepadBinds')[1]}';
                    case 2:
                        text1.text = 'UP KEY: ${SaveData.getData('gamepadBinds')[2]}';
                    case 3:
                        text1.text = 'RIGHT KEY: ${SaveData.getData('gamepadBinds')[3]}';
                    case 4:
                        text1.text = 'ACCEPT KEY: ${SaveData.getData('gamepadBinds')[4]}';
                    case 5:
                        text1.text = 'EXIT KEY: ${SaveData.getData('gamepadBinds')[5]}';
                }

                if (inChange)
                {
                    var keyPressed:FlxGamepadInputID = gamepad.firstJustPressedID();
                    if (!Input.gamepadIs('gamepad_accept') && !Input.gamepadIs('gamepad_exit') 
                        && gamepad.anyJustPressed([ANY]) && keyPressed.toString() != NONE) 
                    {
                        switch (init)
                        {
                            case 0:
                                SaveData.saveData(SaveData.getData('gamepadBinds')[0], keyPressed);
                                Input.controllerMap.set("gamepad_left", SaveData.getData('gamepadBinds')[0]);
                            case 1:
                                SaveData.saveData(SaveData.getData('gamepadBinds')[1], keyPressed);
                                Input.controllerMap.set("gamepad_down", SaveData.getData('gamepadBinds')[1]);
                            case 2:
                                SaveData.saveData(SaveData.getData('gamepadBinds')[2], keyPressed);
                                Input.controllerMap.set("gamepad_up", SaveData.getData('gamepadBinds')[2]);
                            case 3:
                                SaveData.saveData(SaveData.getData('gamepadBinds')[3], keyPressed);
                                Input.controllerMap.set("gamepad_right", SaveData.getData('gamepadBinds')[3]);
                            case 4:
                                SaveData.saveData(SaveData.getData('gamepadBinds')[4], keyPressed);
                                Input.controllerMap.set("gamepad_accept", SaveData.getData('gamepadBinds')[4]);
                            case 5:
                                SaveData.saveData(SaveData.getData('gamepadBinds')[5], keyPressed);
                                Input.controllerMap.set("gamepad_exit", SaveData.getData('gamepadBinds')[5]);
                        }
                        FlxG.sound.play(Paths.sound('scroll'));
                        text2.text = "";
                        inChange = false;
                    }
                }
            }
        }
    }
}