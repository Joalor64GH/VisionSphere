package;

import flixel.FlxGame;
import openfl.display.Sprite;

#if linux
import lime.graphics.Image;
#end

class Main extends Sprite
{
	public static var gameWidth:Int = 1280;
	public static var gameHeight:Int = 720;

	public function new()
	{
		super();

		addChild(new FlxGame(gameWidth, gameHeight, SplashState, #if (flixel < "5.0.0") -1, #end 60, 60, true, false));

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end
	}
}