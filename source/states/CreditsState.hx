package states;

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
    private var credsGrp:FlxTypedGroup<Alphabet>;

    var credits:Array<CreditsMetadata> = [];

    var userData:CreditsUserDef;
    var credData:CreditsPrefDef;

    var curSelected:Int = 0;
    var curSocial:Int = 0;

    var desc:FlxText;
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
        
        // this is even swaggier
        var initCredits = CoolUtil.getText(Paths.txt('credits'));

        if (FileSystem.exists(Paths.txt('credits')))
        {
            initCredits = CoolUtil.getText(Paths.txt('credits'));

            for (i in 0...initCredits.length)
            {
                initCredits[i] = initCredits[i].trim();
            }
        }
        else
        {
            trace("Oops! Could not find 'credits.txt'!");
            trace("Replacing with normal credits...");
            initCredits = "person:what they did idk\n
                engine start:no problem".trim().split('\n');
            
            for (i in 0...initCredits.length)
            {
                initCredits[i] = initCredits[i].trim();
            }
        }

        for (i in 0...initCredits.length)
        {
            var data:Array<String> = initCredits[i].split(':');
            credits.push(new CreditsMetadata(data[0], data[1]));
        }

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        credsGrp = new FlxTypedGroup<Alphabet>();
        add(credsGrp);

        for (i in 0...credits.length)
        {
            var creditsText:Alphabet = new Alphabet(90, 320, credits[i].name, true);
            creditsText.isMenuItem = true;
            creditsText.targetY = i - curSelected;
            credsGrp.add(creditsText);
        }

        descTxt = new FlxText(50, 600, 1180, "", 32);
        descTxt.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        descTxt.borderSize = 24; // looks weird, but adds a cool effect
        add(descTxt);

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

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

    private function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = credsGrp.length - 1;
        if (curSelected >= credsGrp.length)
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
}

class CreditsMetadata
{
    public var name:String = "";
    public var desc:String = "";

    public function new(name:String, desc:String)
    {
        this.name = name;
        this.desc = desc;
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