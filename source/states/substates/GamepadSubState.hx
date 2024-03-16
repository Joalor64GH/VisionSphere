package states.substates;

import flixel.input.gamepad.FlxGamepadInputID;

class GamepadSubState extends FlxSubState
{
    var init:Int = 0;
    var inChange:Bool = false;
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
        controllerSpr.animation.play('gamepad');
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

        if (FlxG.mouse.overlaps(controllerSpr))
        {
            if (FlxG.mouse.justPressed) 
            {
                close();
                openSubState(new ControlsSubState());
            }
        }

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