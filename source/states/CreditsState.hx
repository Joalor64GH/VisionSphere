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
    var bgSprite:String;
    var bgAntialiasing:Bool;
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
    var groupTxt:FlxText;

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

        gradBG = new GradSprite(FlxG.width, FlxG.height, [0xFF000000, 0xFFffffff]);
        add(gradBG);
        
        if (credData.bgSprite != null || credData.bgSprite.length > 0) {
            menuBck = new FlxSprite().loadGraphic(Paths.image(credData.bgSprite));
            menuBck.updateHitbox();
        }
        else
            menuBck = new FlxSprite().loadGraphic(Paths.image('desatBG'));
        menuBck.blend = MULTIPLY;
        add(menuBck);

        bDrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
        bDrop.velocity.x = 30;
        bDrop.velocity.y = 30;
        bDrop.screenCenter();
        add(bDrop);

        iconHolder = new FlxSprite(100, 170).makeGraphic(300, 400, 0x00000000);
        FlxSpriteUtil.drawRoundRect(iconHolder, 0, 0, 300, 400, 10, 10, 0x88000000);
        iconHolder.scrollFactor.set(0, 0);
        add(iconHolder);

        iconSprite = new AttachedSprite();
        iconSprite.scrollFactor.set(0, 0);
        add(iconSprite);

        userText = new FlxText(0, 0, 0, "N/A", 25);
        userText.setFormat(Paths.font('vcr.ttf'), 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        userText.scrollFactor.set(0, 0);
        add(userText);

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
        socialSprite.frames = Paths.getSparrowAtlas('PlatformIcons');
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

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        bDrop.alpha = 0.5;

        if (Input.is('up') || Input.is('down'))
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (Input.is('exit'))
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.switchState(new states.options.MiscState());
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = credData.users.length - 1;
        if (curSelected >= credData.users.length)
            curSelected = 0;

        descTxt.text = credits[curSelected].desc;
        
        var something:Int = 0;

        for (item in credsGrp.members)
        {
            item.targetY = something - curSelected;
            something++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    function updateSocial(huh:Int = 0)
    {
        //
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