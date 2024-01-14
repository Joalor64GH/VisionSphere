package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var gameWidth:Int = 1280;
	public static var gameHeight:Int = 720;

	public function new()
	{
		super();

		addChild(new FlxGame(gameWidth, gameHeight, PlayState));
	}
}
