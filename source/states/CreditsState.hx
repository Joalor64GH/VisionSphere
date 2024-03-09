package states;

import states.options.*;
import objects.AbsoluteSprite;

using StringTools;

typedef CreditsPrefDef = {
    var ?menuBG:String;
    var ?menuBGColor:Array<Int>;
    var ?tweenColor:Bool;
    var users:Array<CreditsUserDef>;
}

typedef CreditsUserDef = {
    var name:String;
    var iconData:Array<Dynamic>;
    var textData:Array<String>;
    var colors:Array<Int>;
    var urlData:Array<Array<String>>;
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

    var curSelected:Int;
    var curSocial:Int;

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

        if (credData.menuBG != null || credData.menuBG.length > 0)
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
        }

        curSelected = 0;
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

        if (Input.is('up') || Input.is('down'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (Input.is('left') || Input.is('right'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            updateSocial(Input.is('left') ? -1 : 1);
        }

        if (Input.is('accept') && credData.users[curSelected].urlData[curSocial][1] != null)
            CoolUtil.browserLoad(credData.users[curSelected].urlData[curSocial][1]);

        if (Input.is('exit'))
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.switchState(MiscState.new);
            Paths.clearUnusedMemory();
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

        curSelected += change;

        if (curSelected < 0)
            curSelected = credData.users.length - 1;
        else if (curSelected >= credData.users.length)
            curSelected = 0;

        if (credData.users[curSelected].sectionName.length > 1)
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