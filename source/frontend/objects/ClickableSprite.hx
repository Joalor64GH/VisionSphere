package frontend.objects;

class ClickableSprite extends FlxSprite
{
    public var clickCallback:Void->Void;

    public function new(x:Float = 0, y:Float = 0, file:String = null, clickCallback:Void->Void)
    {
        super(x, y);

        this.clickCallback = clickCallback;

        loadGraphic(Paths.image(file));
        
        scrollFactor.set();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) 
        {
            if (clickCallback != null)
                clickCallback();
        }
    }
}

class Button extends flixel.group.FlxSpriteGroup
{
    public var clickCallback:Void->Void;
    public var text:Alphabet;
    public var btn:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, btnText:String = 'balls', clickCallback:Void->Void)
    {
        super(x, y);

        this.clickCallback = clickCallback;

        btn = new FlxSprite();
        btn.frames = Paths.getSparrowAtlas('buttonSprite');
        btn.animation.addByPrefix('loop', 'buttonSprite', 24);
        btn.animation.play('loop');
        btn.scale.set(0.6);
        add(btn);

        text = new Alphabet(0, 0, btnText, false);
        positionInCenter(text, btn);
        add(text);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        btn.color = FlxColor.WHITE;

        if (FlxG.mouse.overlaps(btn)) 
        {
            btn.color = FlxColor.YELLOW;
            
            if (FlxG.mouse.justPressed) 
            {
                if (clickCallback != null)
                    clickCallback();
            }
        }
    }

    function positionInCenter(object:FlxObject, object2:FlxObject, setToPosition:Bool = false)
    {
        object.x = (object2.width - object.width) * .5;
        object.y = (object2.height - object.height) * .5;
        if (setToPosition)
        {
            object.x += object2.x;
            object.y += object2.y;
        }
    }
}