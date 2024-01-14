package;

class PlayState extends FlxState
{
    var leDate = Date.now();
    var lowerText:FlxText;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        add({
            var text = new FlxText(0, 0, 0, "Hello World", 64);
            text.screenCenter();
            text;
        });

        add({
            lowerText = new FlxText(5, FlxG.height - 24, 0, leDate.toString(), 12);
            lowerText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            lowerText;
        });
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        lowerText.text = leDate.toString();
    }
}