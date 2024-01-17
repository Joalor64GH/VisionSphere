package states.substates;

class SystemInfoSubState extends FlxSubState
{
    var bg:FlxSprite;

    public function new()
    {
        super();

        bg = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);
    }
}