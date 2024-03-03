package;

import openfl.Lib;

import haxe.Exception;

import display.ToastCore;
import display.Info;
import util.MacroUtil;

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

using StringTools;

class Main extends openfl.display.Sprite
{
	public static final gameVersion:String = '0.6.0';

	public static var buildNum(default, never):Int = MacroUtil.get_build_num();
	public static var commitId(default, never):String = MacroUtil.get_commit_id();

	public static var toast:ToastCore;
	public static var fpsDisplay:Info;

	public static var game:CustomGame;

	public static function main():Void
		Lib.current.addChild(new Main());

	public function new()
	{
		super();

		#if windows
		util.Windows.darkMode(true);
		#end

		FlxG.signals.preStateSwitch.add(() -> {
			#if cpp
			cpp.NativeGc.run(true);
			cpp.NativeGc.enable(true);
			#end
			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearUnused();

			openfl.system.System.gc();
		});

		FlxG.signals.postStateSwitch.add(() -> {
			#if cpp
			cpp.NativeGc.run(false);
			cpp.NativeGc.enable(false);
			#end

			openfl.system.System.gc();
		});

		game = new CustomGame(1280, 720, BootState, #if (flixel < "5.0.0") -1, #end 60, 60, true, false);
		addChild(game);

		fpsDisplay = new Info(10, 10, 0xFFFFFF);
		addChild(fpsDisplay);

		#if windows
		Lib.current.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (evt:openfl.events.KeyboardEvent) ->
		{
			if (evt.keyCode == openfl.ui.Keyboard.F2)
			{
				var sp = Lib.current.stage;
				var position = new openfl.geom.Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);

				var image:flash.display.BitmapData = new flash.display.BitmapData(Std.int(position.width), Std.int(position.height), false, 0xFEFEFE);
				image.draw(sp, true);

				if (!FileSystem.exists("./screenshots/"))
					FileSystem.createDirectory("./screenshots/");

				var bytes = image.encode(position, new openfl.display.PNGEncoderOptions());

				var curDate:String = Date.now().toString();

				curDate = StringTools.replace(curDate, " ", "_");
				curDate = StringTools.replace(curDate, ":", "'");

				File.saveBytes("screenshots/Screenshot-" + curDate + ".png", bytes);
			}
		});
		#end

		#if linux
		Lib.current.stage.window.setIcon(lime.graphics.Image.fromFile("icon.png"));
		#end

		FlxG.mouse.visible = true;

		toast = new ToastCore();
		addChild(toast);
	}
}

class CustomGame extends flixel.FlxGame
{
	override function create(_):Void {
		try super.create(_)
		catch (e:Exception)
			onCrash(e);
	}

	override function onFocus(_):Void {
		try super.onFocus(_)
		catch (e:Exception)
			onCrash(e);
	}

	override function onFocusLost(_):Void {
		try super.onFocusLost(_)
		catch (e:Exception)
			onCrash(e);
	}

	override function onEnterFrame(_):Void {
		try super.onEnterFrame(_)
		catch (e:Exception)
			onCrash(e);
	}

	override function update():Void {
		#if debug // crash testing
		if (Input.is('f9') && !(FlxG.state is CrashState))
			(cast(null, FlxSprite)).draw();
		#end
		try super.update()
		catch (e:Exception)
			onCrash(e);
	}

	override function draw():Void {
		try super.draw()
		catch (e:Exception)
			onCrash(e);
	}

	private static function onCrash(e:Exception) {
		FlxG.sound.music.stop();
		FlxG.switchState(() -> new CrashState(e));
	}
}