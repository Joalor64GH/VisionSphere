package states.games.jta;

class Spike extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('game/jta/spike'), true, 16, 16);

        animation.add("idle", [0], 1, true);
        animation.play("idle");
    }
}