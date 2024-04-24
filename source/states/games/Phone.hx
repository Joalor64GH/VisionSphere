package states.games;

import frontend.video.VideoState;

/**
 * @author ROYALEPRO
 * @see https://github.com/ROYALEPRO/soni-main-public
 */

class Phone extends FlxState
{
    var nokia:FlxSprite;
    var numbers:FlxTypedGroup<FlxSprite>;
    
    var code:FlxText;
    var selection:Int;
    var canSelect:Bool = true;

    override function create()
    {
        nokia = new FlxSprite().loadGraphic(Paths.image('game/phone/Nokia_png_full_hd'));
        nokia.screenCenter();
        add(nokia);

        numbers = new FlxTypedGroup<FlxSprite>();
        add(numbers);

        for (i in 0...10)
        {
            var button:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/phone/Boton_$i'));
            switch (i)
            {
                case 0:
                    button.setPosition(617, 617);
                    button.setGraphicSize(58, 33);
                case 1:
                    button.setPosition(542, 555);
                    button.setGraphicSize(56, 40);
                case 2:
                    button.setPosition(617, 570);
                    button.setGraphicSize(58, 34);
                case 3:
                    button.setPosition(693 ,557);
                    button.setGraphicSize(55, 38);
                case 4:
                    button.setPosition(540, 512);
                    button.setGraphicSize(53, 36);
                case 5:
                    button.setPosition(617, 525);
                    button.setGraphicSize(57, 33);
                case 6:
                    button.setPosition(697, 511);
                    button.setGraphicSize(54, 37);
                case 7:
                    button.setPosition(536, 463);
                    button.setGraphicSize(57, 39);
                case 8:
                    button.setPosition(616, 476);
                    button.setGraphicSize(59, 35);
                case 9:
                    button.setPosition(699, 463);
                    button.setGraphicSize(56, 39);
            }
            button.ID = i;
            button.updateHitbox();
            button.y -= 5;
            numbers.add(button);
        }

        code = new FlxText(565, 231, 200, "", 80);
        code.setFormat(Paths.font("vcr.ttf"), 80, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        code.text = '';
        code.screenCenter(X);
        code.x += 3;
        add(code);

        super.create();
    }

    override function update(elapsed:Float)
    {
        numbers.forEach((spr:FlxSprite) -> 
        {
            if (FlxG.mouse.overlaps(spr))
                selection = spr.ID;
        });

        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var accept = Input.is('accept') || (gamepad != null ? Input.gamepadIs('gamepad_accept') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (exit && canSelect) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(MenuState.new);
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }

        for (i in numbers)
            if (FlxG.mouse.overlaps(i) && canSelect)
                if (code.text.length < 4)
                    if (FlxG.mouse.justPressed)
                        code.text += selection;
        
        if (accept && code.text != '')
        {
            switch (code.text) 
            {
                case '1026':
                    FlxG.switchState(new VideoState('paint', () -> {
                        #if (sys || cpp)
                        Sys.exit(0);
                        #else
                        System.exit(0);
                        #end
                    }));
                    canSelect = false;
                default:
                    code.text = '';
                    if (canSelect)
                        FlxG.camera.shake(0.015, 0.2);
            }
        }
    }
}