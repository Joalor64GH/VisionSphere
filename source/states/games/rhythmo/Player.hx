package states.games.rhythmo;

import states.games.rhythmo.Character;

class Player extends Character
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('game/rhythmo/player');
        animation.addByPrefix('idle', 'Idle', 24);
        animation.addByPrefix('singUP', 'Up', 24);
        animation.addByPrefix('singDOWN', 'Down', 24);
        animation.addByPrefix('singLEFT', 'Left', 24);
        animation.addByPrefix('singRIGHT', 'RIGHT', 24);

        playAnim('idle');

        addOffset('idle', 0, -10);
        addOffset('singUP', -45, 11);
        addOffset('singDOWN', -48, -31);
        addOffset('singLEFT', 33, -6);
        addOffset('singRIGHT', -61, -14);

        flipX = true;
    }
}