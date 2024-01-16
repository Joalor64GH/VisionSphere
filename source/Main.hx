package;

import flixel.FlxGame;
import openfl.display.Sprite;

import display.ToastCore;
import display.FPS;

#if linux
import lime.graphics.Image;
#end

class Main extends Sprite
{
	public static var gameWidth:Int = 1280;
	public static var gameHeight:Int = 720;
	public static var toast:ToastCore;
	public static var fps:FPS;

	public function new()
	{
		super();

		addChild(new FlxGame(gameWidth, gameHeight, states.SplashState, #if (flixel < "5.0.0") -1, #end 60, 60, true, false));

		fps = new FPS(10, 3, 0xFFFFFF);
		addChild(fps);

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		toast = new ToastCore();
		addChild(toast);
	}
}