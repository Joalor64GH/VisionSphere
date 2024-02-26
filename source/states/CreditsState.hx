package states;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;

import flixel.group.FlxGroup;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

import flash.display.BitmapData;
import openfl.display.BlendMode;

using StringTools;

typedef CreditsPrefDef = {
    var users:Array<CreditsUserDef>;
}

typedef CreditsUserDef = {
    var name:String;
    var icon:String;
    var textData:Array<String>;
    var colors:Array<Int>;
    var urlData:Dynamic;
    var sectionName:String;
}

class CreditsState extends FlxState
{
    var userData:CreditsUserDef;
    var credData:CreditsPrefDef;

    var curSelected:Int = 0;
    var curSocial:Int = 0;

    var descTxt:FlxText;
    var descBG:FlxSprite;

    var menuBck:FlxSprite;
    var bckTween:FlxTween;
    var bDrop:FlxBackdrop;

    var socialsHolder:FlxSprite;
    var socialSprite:FlxSprite;

    var iconHolder:FlxSprite;
    var iconSprite:AttachedSprite;

    var userText:FlxText;
    var quoteText:FlxText;
    var labelText:FlxText;

    var gradBG:GradSprite;

    var mediaAnimsArray:Array<String> = ['NG', 'Twitter', 'Twitch', 'YT', 'GitHub'];

    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        // now this is swaggy
        if (FileSystem.exists(Paths.json('credits'))) {
            try {
                credData = Json.parse(Paths.json('credits'));
            } catch (e:Dynamic) {
                trace('$e');
            }
        }

        generateBackground();

        iconHolder = new FlxSprite(100, 170).makeGraphic(300, 400, 0x00000000);
        FlxSpriteUtil.drawRoundRect(iconHolder, 0, 0, 300, 400, 10, 10, 0x88000000);
        iconHolder.scrollFactor.set(0, 0);
        add(iconHolder);

        iconSprite = new AttachedSprite();
        iconSprite.scrollFactor.set(0, 0);
        add(iconSprite);

        generateUserText("N/A", 25);
        quoteText = new FlxText(0, 0, 0, "SALMON", 32);
        quoteText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        quoteText.scrollFactor.set(0, 0);
        add(quoteText);

        labelText = new FlxText(0, 0, 0, "UNKNOWN", 40);
        labelText.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        labelText.scrollFactor.set(0, 0);
        add(labelText);

        socialsHolder = new FlxSprite(iconHolder.x + iconHolder.width + 100, 170).makeGraphic(600, 400, 0x00000000);
        FlxSpriteUtil.drawRoundRect(socialsHolder, 0, 0, 600, 400, 10, 10, 0x88000000);
        socialsHolder.scrollFactor.set(0, 0);
        add(socialsHolder);

        socialSprite = new FlxSprite(0, 0);
        socialSprite.frames = Paths.getSparrowAtlas('menu/credits/PlatformIcons');
        for (anim in mediaAnimsArray)
            socialsHolder.animation.addByPrefix('$anim', '$anim', 24, true);
        socialSprite.scale.set(0.6, 0.6);
        socialSprite.updateHitbox();
        socialSprite.x = socialsHolder.x + socialsHolder.width / 2 - socialSprite.width / 2;
        add(socialSprite);

        descTxt = new FlxText(0, 0, 0, "shrimp alfredo", 32);
        descTxt.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        descTxt.scrollFactor.set(0, 0);
        add(descTxt);

        var bar1:FlxSprite = new FlxSprite(0, -70).makeGraphic(FlxG.width + 100, 200, 0xFF000000);
        bar1.scrollFactor.set(0, 0);
        add(bar1);

        var bar2:FlxSprite = new FlxSprite(-20, FlxG.height - 120).makeGraphic(FlxG.width + 120, 200, 0xFF000000);
        bar2.scrollFactor.set(0, 0);
        add(bar2);

        changeSelection();
        updateSocial(0);

        super.create();
    }

    function generateBackground()
    {
        gradBG = new GradSprite(FlxG.width, FlxG.height, [0xFF000000, 0xFFffffff]);
        add(gradBG);
        
        menuBck = new FlxSprite().loadGraphic(Paths.image('desatBG'));
        menuBck.blend = MULTIPLY;
        add(menuBck);

        bDrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
        bDrop.velocity.x = 30;
        bDrop.velocity.y = 30;
        bDrop.screenCenter();
        add(bDrop);
    }

    function generateUserText(text:Dynamic, size:Int)
    {
        userText = new FlxText(0, 0, 0, text, size);
        userText.setFormat(Paths.font('vcr.ttf'), size, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        userText.scrollFactor.set(0, 0);
        add(userText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        bDrop.alpha = 0.5;

        if (Input.is('up') || Input.is('down'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (Input.is('accept') && Reflect.field(credData.users[curSelected].urlData, mediaAnimsArray[curSocial]) != null)
            CoolUtil.browserLoad(Reflect.field(credData.users[curSelected].urlData, mediaAnimsArray[curSocial]));

        if (Input.is('exit'))
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.switchState(new states.options.MiscState());
        }
    }

    var mainColor:FlxColor = FlxColor.WHITE;

    function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = credData.users.length - 1;
        if (curSelected >= credData.users.length)
            curSelected = 0;

        var pastColor = ((credData.users[curSelected - 1] != null) ? FlxColor.fromRGB(credData.users[curSelected - 1].colors[0],
			credData.users[curSelected - 1].colors[1], credData.users[curSelected - 1].colors[2]) : 0xFFffffff);
        mainColor = FlxColor.fromRGB(credData.users[curSelected].colors[0], credData.users[curSelected].colors[1], credData.users[curSelected].colors[2]);

        gradBG.flxColorTween([pastColor, mainColor]);
        FlxTween.color(bDrop, 0.35, bDrop.color, mainColor);

        iconSprite.loadGraphic(Paths.image('menu/credits/' + credData.users[curSelected].icon));
        iconSprite.y = iconHolder.y + 2;
        iconSprite.x = iconHolder.x + iconHolder.width / 2 - iconSprite.width / 2;
        FlxTween.tween(iconSprite, {y: iconHolder.y + iconHolder.height - iconSprite.height}, 0.2, {type: BACKWARD, ease: FlxEase.elasticOut});

        userText.text = credData.users[curSelected].name;
        if (userText.width > iconHolder.width - 2)
            userText.setGraphicSize(Std.int(iconHolder.width - 2), 0);
        userText.updateHitbox();
        userText.y = iconSprite.y + iconSprite.height + 2;
        userText.x = iconHolder.x + iconHolder.width / 2 - userText.width / 2;
        FlxTween.tween(userText, {y: (iconHolder.y + iconHolder.height - userText.height)}, 0.2, {type: BACKWARD, ease: FlxEase.elasticOut});

        quoteText.text = credData.users[curSelected].textData[1];
        if (quoteText.width > iconHolder.width - 2)
            quoteText.setGraphicSize(Std.int(iconHolder.width - 2), 0);
        quoteText.updateHitbox();
        quoteText.y = userText.y + userText.height + 2;
        quoteText.x = iconHolder.x + iconHolder.width / 2 - quoteText.width / 2;
        FlxTween.tween(quoteText, {y: (iconHolder.y + iconHolder.height - quoteText.height)}, 0.2, {type: BACKWARD, ease: FlxEase.elasticOut});

        descTxt.text = credData.users[curSelected].textData[0] + '\n';
        if (descTxt.width > socialsHolder.width - 2)
            descTxt.setGraphicSize(Std.int(socialsHolder.width - 2), 0);
        descTxt.updateHitbox();
        descTxt.y = socialsHolder.y + socialsHolder.height / 2 - descTxt.height / 2;
        descTxt.x = socialsHolder.x + socialsHolder.width / 2 - descTxt.width / 2;
        FlxTween.tween(descTxt, {y: (socialsHolder.y + socialsHolder.height - descTxt.height)}, 0.2, {type: BACKWARD, ease: FlxEase.elasticOut});

        if (credData.users[curSelected].sectionName != null && credData.users[curSelected].sectionName.length > 0)
            labelText.text = credData.users[curSelected].sectionName;
        if (labelText.width > iconHolder.width - 2)
            labelText.setGraphicSize(Std.int(iconHolder.width - 2), 0);
        labelText.updateHitbox();
        labelText.y = iconHolder.y + iconHolder.height - labelText.height - 9;
        labelText.x = iconHolder.x + 2;
        if (labelText.text == credData.users[curSelected].sectionName)
            FlxTween.tween(labelText, {x: (iconHolder.x - labelText.width)}, 0.2, {type: BACKWARD, ease: FlxEase.elasticOut});
        
        curSocial = 0;
        updateSocial(0);
    }

    function updateSocial(huh:Int = 0)
    {
        curSocial += huh;
        mediaAnimsArray = Reflect.fields(credData.users[curSelected].urlData);

        if (curSocial < 0)
            curSocial = mediaAnimsArray.length - 1;
        if (curSocial >= mediaAnimsArray.length)
            curSocial = 0;

        socialSprite.animation.play(mediaAnimsArray[curSocial]);
        socialSprite.x = socialsHolder.x + socialsHolder.width / 2 - socialSprite.width / 2;
        socialSprite.y = socialsHolder.y;
    }
}

class GradSprite extends FlxSprite
{
    var _width:Int;
    var _height:Int;
    var _bitmap:BitmapData;

    public var _colors:Array<FlxColor>;

    public function new(w:Int, h:Int, colors:Array<FlxColor>)
    {
        super();

        _width = w;
        _height = h;
        updateColors(colors);
    }

    public function updateColors(colors:Array<FlxColor>)
    {
        _colors = colors;
        _bitmap = FlxGradient.createGradientBitmapData(_width, _height, colors);
        pixels = _bitmap;
        pixels.lock();
    }

    public function flxColorTween(colors:Array<FlxColor>, duration:Float = 0.35)
    {
        for (i in 0...colors.length)
        {
            var formerColor:FlxColor = _colors[i];
            FlxTween.num(0.0, 1.0, duration, {ease: FlxEase.linear}, (v:Float) ->
            {
                _colors[i] = FlxColor.interpolate(formerColor, colors[i], v);
                pixels.dispose();
                pixels.unlock();
                updateColors(_colors);
            });
        }
    }
}