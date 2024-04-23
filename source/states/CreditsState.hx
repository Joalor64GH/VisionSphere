package states;

typedef CreditsPrefDef = {
    var ?menuBG:String;
    var ?menuBGColor:Array<Int>;
    var ?tweenColor:Bool;
    var users:Array<CreditsUserDef>;
}

typedef CreditsUserDef = {
    var name:String;
    var iconData:Array<Dynamic>; // icon name, x offset, y offset
    var textData:Array<String>; // description, quote
    var colors:Array<Int>;
    var urlData:Array<Array<String>>; // social name, link
    var ?sectionName:String;
}

/**
 * @author crowplexus (formerly BeastlyGhost)
 * @see https://github.com/Joalor64GH/ForeverUnderscore-backup/
 */

class CreditsState extends FlxState
{
    var credData:CreditsPrefDef;
    var credsGrp:FlxTypedGroup<Alphabet>;

    var curSelected:Int = -1;
    var curSocial:Int = -1;

    var menuBG:FlxSprite;
    var menuColorTween:FlxTween;

    var iconArray:Array<AbsoluteSprite> = [];

    var topBar:FlxSprite;
    var topMarker:FlxText;
    var rightMarker:FlxText;
    var bottomMarker:FlxText;
    var centerMarker:FlxText;

    override public function create()
    {
        super.create();

        credData = Json.parse(Paths.getTextFromFile('data/credits.json'));

        if (credData.menuBG != null && credData.menuBG.length > 0)
            menuBG = new FlxSprite().loadGraphic(Paths.image(credData.menuBG));
        else
            menuBG = new FlxSprite().loadGraphic(Paths.image('desatBG'));
        add(menuBG);

        var finalColor:FlxColor = FlxColor.fromRGB(credData.menuBGColor[0], credData.menuBGColor[1], credData.menuBGColor[2]);
        if (!credData.tweenColor)
            menuBG.color = finalColor;

        credsGrp = new FlxTypedGroup<Alphabet>();
        add(credsGrp);

        for (i in 0...credData.users.length)
        {
            var name:Alphabet = new Alphabet(90, 320, credData.users[i].name, false);
            name.isMenuItem = true;
            name.disableX = true;
            name.targetY = i;
            credsGrp.add(name);

            var icon:AbsoluteSprite = new AbsoluteSprite("menu/credits/" + credData.users[i].iconData[0], name, credData.users[i].iconData[1], credData.users[i].iconData[2]);
            
            if (credData.users[i].iconData[3] != null)
                icon.setGraphicSize(Std.int(icon.width * credData.users[i].iconData[3]));
            if (credData.users[i].iconData.length <= 1 || credData.users[i].iconData == null)
                icon.visible = false;
            
            iconArray.push(icon);
            add(icon);

            if (curSelected == -1)
                curSelected = i;
        }

        if (curSocial == -1)
            curSocial = 0;

        topBar = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        topBar.setGraphicSize(FlxG.width, 48);
        topBar.updateHitbox();
        topBar.screenCenter(X);
        add(topBar);
        topBar.y -= topBar.height;

        topMarker = new FlxText(8, 8, 0, "CREDITS").setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE);
        topMarker.alpha = 0;
        add(topMarker);

        centerMarker = new FlxText(8, 8, 0, "< PLATFORM >").setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE);
        centerMarker.screenCenter(X);
        centerMarker.alpha = 0;
        add(centerMarker);

        rightMarker = new FlxText(8, 8, 0, "VISIONSPHERE").setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE);
        rightMarker.x = FlxG.width - (rightMarker.width + 16);
        rightMarker.alpha = 0;
        add(rightMarker);

        bottomMarker = new FlxText(5, FlxG.height - 24, 0, "", 32);
        bottomMarker.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        bottomMarker.textField.background = true;
        bottomMarker.textField.backgroundColor = FlxColor.BLACK;
        add(bottomMarker);

        FlxTween.tween(topMarker, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});
        FlxTween.tween(centerMarker, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});
        FlxTween.tween(rightMarker, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});

        changeSelection();
        updateSocial();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        topBar.y = FlxMath.lerp(topBar.y, 0, elapsed * 6);
        topMarker.y = topBar.y + 5;
        centerMarker.y = topBar.y + 5;

        rightMarker.y = topBar.y + 5;
        rightMarker.x = FlxG.width - (rightMarker.width + 16);

        bottomMarker.screenCenter(X);

        var controlArray:Array<Bool> = [
            FlxG.keys.justPressed.UP,
            FlxG.keys.justPressed.DOWN,
            Input.is('up'),
            Input.is('down'),
            FlxG.mouse.wheel == 1,
            FlxG.mouse.wheel == -1
        ];
        
        if (controlArray.contains(true))
        {
            for (i in 0...controlArray.length)
            {
                if (controlArray[i] == true)
                {
                    if (i > 1)
                    {
                        if (i == 2 || i == 4)
                            curSelected--;
                        else if (i == 3 || i == 5)
                            curSelected++;
                        FlxG.sound.play(Paths.sound('scroll'));
                    }
                    if (curSelected < 0)
                        curSelected = credData.users.length - 1;
                    if (curSelected >= credData.users.length)
                        curSelected = 0;
                    changeSelection();
                }
            }
        }

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var left = Input.is('left') || (gamepad != null ? Input.gamepadIs('gamepad_left') : false);
        var right = Input.is('right') || (gamepad != null ? Input.gamepadIs('gamepad_right') : false);
        var accept = Input.is('accept') || (gamepad != null ? Input.gamepadIs('gamepad_accept') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (left || right)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            updateSocial(left ? -1 : 1);
        }

        if (accept && credData.users[curSelected].urlData[curSocial][1] != null)
            CoolUtil.browserLoad(credData.users[curSelected].urlData[curSocial][1]);

        if (exit)
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.switchState(OptionsState.new);
            Paths.clearUnusedMemory();
        }

        if (gamepad != null) 
        {
            var controlArray:Array<Bool> = [
                gamepad.justPressed.DPAD_UP,
                gamepad.justPressed.DPAD_DOWN,
                Input.gamepadIs('gamepad_up'),
                Input.gamepadIs('gamepad_down'),
                gamepad.justPressed.LEFT_STICK_DIGITAL_UP,
                gamepad.justPressed.LEFT_STICK_DIGITAL_DOWN
            ];
        
            if (controlArray.contains(true))
            {
                for (i in 0...controlArray.length)
                {
                    if (controlArray[i] == true)
                    {
                        if (i > 1)
                        {
                            if (i == 2 || i == 4)
                                curSelected--;
                            else if (i == 3 || i == 5)
                                curSelected++;
                            FlxG.sound.play(Paths.sound('scroll'));
                        }
                        if (curSelected < 0)
                            curSelected = credData.users.length - 1;
                        if (curSelected >= credData.users.length)
                            curSelected = 0;
                        changeSelection();
                    }
                }
            }
        }

        updateBottomMarker();
    }

    function changeSelection(change:Int = 0)
    {
        for (num => item in credsGrp.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }

        if (credData.users[curSelected].sectionName.length != null)
        {
            var textValue = credData.users[curSelected].sectionName;
            if (credData.users[curSelected].sectionName == null)
                textValue = "";
            rightMarker.text = textValue;
        }

        if (credData.tweenColor)
        {
            var color:FlxColor = FlxColor.fromRGB(credData.users[curSelected].colors[0], credData.users[curSelected].colors[1], 
                credData.users[curSelected].colors[2]);

            if (menuColorTween != null)
                menuColorTween.cancel();

            if (color != menuBG.color)
            {
                menuColorTween = FlxTween.color(menuBG, 0.35, menuBG.color, color, {onComplete: (tween:FlxTween) -> {
                    menuColorTween = null;
                }});
            }
        }

        // resets social because dumb
        curSocial = 0;
        updateSocial();
    }

    function updateSocial(huh:Int = 0)
    {
        if (credData.users[curSelected].urlData[curSocial][0] == null)
            return;
        
        curSocial += huh;
        if (curSocial < 0)
            curSocial = credData.users[curSelected].urlData[0].length - 1;
        if (curSocial >= credData.users[curSelected].urlData.length)
            curSocial = 0;

        if (credData.users[curSelected].urlData[curSocial][0] != null)
        {
            var textValue = '< ' + credData.users[curSelected].urlData[curSocial][0] + ' >';
            if (credData.users[curSelected].urlData[curSocial][0] == null)
                textValue = "";
            centerMarker.text = textValue;
        }
    }

    function updateBottomMarker()
    {
        var textData = credData.users[curSelected].textData;
        var fullText:String = '';

        if (textData[0] != null && textData[0].length >= 1)
            fullText += textData[0];
        
        if (textData[1] != null && textData[1].length >= 1)
            fullText += ' - "' + textData[1] + '"';
        
        bottomMarker.text = fullText;
    }
}