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
                if (keyboardMode == false && gamepad != null)
                    FlxG.sound.play(Paths.sound('confirm'));
                else
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
        else if (!keyboardMode)
        {
            if (gamepad != null)
            {
                if (Input.gamepadIs('x')) 
                {
                    FlxG.sound.play(Paths.sound('confirm'));
                    keyboardMode = !keyboardMode;
                }
                
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
                        text1.text = "LEFT KEY: " + SaveData.gamepadLeftKey;
                    case 1:
                        text1.text = "RIGHT KEY: " + SaveData.gamepadRightKey;
                    case 2:
                        text1.text = "DOWN KEY: " + SaveData.gamepadDownKey;
                    case 3:
                        text1.text = "UP KEY: " + SaveData.gamepadUpKey;
                    case 4:
                        text1.text = "ACCEPT KEY: " + SaveData.gamepadAcceptKey;
                    case 5:
                        text1.text = "EXIT KEY: " + SaveData.gamepadExitKey;
                }

                if (inChange)
                {
                    var keyPressed:FlxGamepadInputID = NONE;
                    if (!Input.gamepadIs('gamepad_accept') && !Input.gamepadIs('gamepad_exit') && Input.gamepadIs('any')) 
                    {
                        keyPressed = gamepad.firstJustPressedID().toString();
                        switch (init)
                        {
                            case 0:
                                SaveData.gamepadLeftKey = keyPressed;
                                Input.controllerMap.set("gamepad_left", SaveData.gamepadLeftKey);
                            case 1:
                                SaveData.rightKey = keyPressed;
                                Input.controllerMap.set("gamepad_right", SaveData.gamepadRightKey);
                            case 2:
                                SaveData.downKey = keyPressed;
                                Input.controllerMap.set("gamepad_down", SaveData.gamepadDownKey);
                            case 3:
                                SaveData.upKey = keyPressed;
                                Input.controllerMap.set("gamepad_up", SaveData.gamepadUpKey);
                            case 4:
                                SaveData.acceptKey = keyPressed;
                                Input.controllerMap.set("gamepad_accept", SaveData.gamepadAcceptKey);
                            case 5:
                                SaveData.exitKey = keyPressed;
                                Input.controllerMap.set("gamepad_exit", SaveData.gamepadExitKey);
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