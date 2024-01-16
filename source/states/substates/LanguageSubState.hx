package states.substates;

import objects.Alphabet;

class LanguageSubState extends FlxSubState
{
    private var iconArray:Array<IconHelper> = [];
    private var coolGrp:FlxTypedGroup<Alphabet>;

    var curSelected:Int = 0;

    var langStrings:Array<Locale> = [
        new Locale('Deutsch', 'de'),
        new Locale('English', 'en'),
        new Locale('Español', 'es'),
        new Locale('Français', 'fr'),
        new Locale('Italiano', 'it'),
        new Locale('Português', 'pt')
    ];

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);
    }
}

class Locale
{
    public var lang:String;
    public var code:String;

    public function new(lang:String, code:String)
    {
        this.lang = lang;
        this.code = code;
    }
}

class IconHelper extends FlxSprite
{
    private var ico:String = '';
    private var iconOffsets:Array<Float> = [0, 0];

    public var sprTracker:FlxSprite;

    public function new(ico:String = 'en')
    {
        super();

        loadIcon(ico);
        scrollFactor.set();
    }

    public function loadIcon(ico:String)
    {
        if (this.ico != ico) {
            var name:String = 'icons/' + ico;
            var file:Dynamic = Paths.image(name);

            loadGraphic(file);

            iconOffsets.length = 0;
            for (i in 0...Math.ceil(width / 150)) {
                iconOffsets.push((width - 150) / (i + 1));
            }

            var frames:Array<Int> = [];
            for (i in 0...iconOffsets.length) {
                frames.push(i);
            }

            loadGraphic(file, true, Math.floor(width / iconOffsets.length), Math.floor(height));
            iconOffsets.length.times(function(i) {
                iconOffsets[i] = (width - 150) / (i + 1);
            });
            updateHitbox();

            animation.add(ico, frames, 0, false);
            animation.play(ico);

            this.ico = ico;
        }
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (sprTracker != null)
            setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
    }

    override function updateHitbox()
    {
        super.updateHitbox();

        offset.x = iconOffsets[0];
        offset.y = iconOffsets[1];
    }
}