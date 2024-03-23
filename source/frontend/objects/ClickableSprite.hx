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

        if (FlxG.mouse.overlaps(this) && FlxG.mouse.pressed) 
        {
            if (clickCallback != null)
                clickCallback();
        }
    }
}