package states.games.jta;

import states.games.jta.Vector;

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