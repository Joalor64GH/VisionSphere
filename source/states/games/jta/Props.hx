package states.games.jta;

import states.games.jta.Vector;

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
            ease: FlxEase.circOut, onComplete: function(_) {
                exists = false;
            }
        });
    }
}

class Flag extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('game/jta/flag-AB'), true, 16, 16);

        animation.add("wave", [1, 2, 3, 4, 5, 0], 12, true);
        animation.add("stop", [0], 12, true);
        animation.play("wave");
    }
}

class Player extends FlxSprite
{
    public var direction:Vector = new Vector(0, 0);
    public var speed:Vector = new Vector(0, 0);

    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic(Paths.image('game/jta/player'), true, 16, 16);

        animation.add("idle", [0], 1);
        animation.add("walk", [1, 0], 12);
        animation.play("idle");
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        this.x += direction.dx * speed.dx;
        this.y += direction.dy * speed.dy;
    }
}

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