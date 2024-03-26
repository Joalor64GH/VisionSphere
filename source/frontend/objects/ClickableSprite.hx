package frontend.objects;

class ClickableSprite extends FlxSprite
{
    public var clickCallback:Void->Void;

    public function new(x:Float = 0, y:Float = 0, file:String = null, clickCallback:Void->Void, ?holdCallback:Void->Void)
    {
        super(x, y);

        this.clickCallback = clickCallback;
        this.holdCallback = holdCallback;

        loadGraphic(Paths.image(file));
        
        scrollFactor.set();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this)) 
        {
            if (holdCallback != null)
                holdCallback();
            if (FlxG.mouse.pressed) 
            {
                if (clickCallback != null)
                    clickCallback();
            }
        }
    }
}