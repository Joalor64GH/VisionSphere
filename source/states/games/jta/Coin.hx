package states.games.jta;

class Coin extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('game/jta/coin'), true, 16, 16);

        animation.add("floating", [0, 1, 2, 1], 12, true);
        animation.play("floating");
    }

    override function kill()
    {
        alive = false;
        FlxTween.tween(this, {alpha: 0, y: y - 16}, 0.22, {
            ease: FlxEase.circOut, onComplete: (_) -> {
                exists = false;
            }
        });
    }
}