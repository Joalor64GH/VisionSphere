package states.games.rhythmo;

class Character extends FlxSprite
{
    public var animOffsets:Map<String, Array<Dynamic>>;

    public function new(x:Float, y:Float)
    {
        animOffsets = new Map<String, Array<Dynamic>>();
        super(x, y);
    }

    public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void
    {
        animation.play(animName, force, reversed, frame);

        var daOffset = animOffsets.get(animation.curAnim.name);
        if (animOffsets.exists(animation.curAnim.name))
            offset.set(daOffset[0], daOffset[1]);
    }

    public function addOffset(name:String, x:Float = 0, y:Float = 0)
    {
        animOffsets[name] = [x, y];
    }
}