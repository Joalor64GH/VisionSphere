package states.games.clicker;

class PlayState extends FlxState
{
    var number:FlxSprite;
    var infinity:FlxSprite;

    var clicks:Int = 0;
    var clicksTxt:FlxText;

    var coolText:FlxText;

    public var win:Bool = false;
    public var cheat:Bool = false;

    override public function create()
    {
        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}