package states;

class MenuState extends FlxState
{
    var dateText:FlxText;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/daylight'));
        add(bg);

        var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bar'));
        add(bar);

        var logo:FlxSprite = new FlxSprite(10, bar.y + 10).loadGraphic(Paths.image('menu/icon'));
        add(bg);

        add({
            var text = new FlxText(0, 0, 0, "Hello World", 64);
            text.screenCenter();
            text;
        });

        add({
            dateText = new FlxText(615, 0);
            dateText.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            dateText;
        });
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.M)
            FlxG.switchState(new states.ModsState());

        dateText.text = DateTools.format(Date.now(), "%F") + ' / ' + DateTools.format(Date.now(), "%r");
    }
}