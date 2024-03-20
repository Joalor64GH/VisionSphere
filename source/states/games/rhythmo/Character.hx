package states.games.rhythmo;

class Character extends FlxSprite
{
    public var animOffsets:Map<String, Array<Dynamic>>;

    public var isPlayer:Bool = false;
    public var curCharacter:String = 'player';

    public var holdTimer:Float = 0;

    public function new(x:Float, y:Float, ?character:String = 'player', ?isPlayer:Bool = false)
    {
        animOffsets = new Map<String, Array<Dynamic>>();
        super(x, y);

        curCharacter = character;
        this.isPlayer = isPlayer;
    }

    public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void
    {
        animation.play(animName, force, reversed, frame);

        var daOffset = animOffsets.get(animation.curAnim.name);
        if (animOffsets.exists(animation.curAnim.name))
            offset.set(daOffset[0], daOffset[1]);
    }

    override function update(elapsed:Float)
    {
        if (!curCharacter.startsWith('player'))
        {
            if (animation.curAnim.name.startsWith('sing'))
                holdTimer += elapsed;
            
            var youCanFloatToo:Float = 4;

            if (curCharacter == 'opponent')
                youCanFloatToo = 6.1;
            if (holdTimer >= Conductor.stepCrochet * youCanFloatToo * 0.001)
            {
                playAnim('idle');
                holdTimer = 0;
            }
        }
    }

    public function addOffset(name:String, x:Float = 0, y:Float = 0)
    {
        animOffsets[name] = [x, y];
    }
}