package;

import openfl.Lib;

import haxe.Exception;
import haxe.CallStack;
import haxe.io.Path;

import frontend.objects.ToastCore;
import frontend.debug.Info;

import backend.MacroUtil;

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends openfl.display.Sprite
{
	public static final gameVersion:String = '0.7.0';

	public static var buildNum(default, never):Int = MacroUtil.get_build_num();
	public static var commitId(default, never):String = MacroUtil.get_commit_id();

	public static var toast:ToastCore;
	public static var fpsDisplay:Info;
	
	public static var instance:Main;

	private var coolGame:VSGame;

	public static function main():Void
		Lib.current.addChild(new Main());

	public function new()
	{
		super();

		instance = this;

		#if windows
		backend.system.Windows.darkMode(true);
		#end

		FlxG.signals.preStateSwitch.add(() -> {
			#if cpp
			cpp.NativeGc.run(true);
			cpp.NativeGc.enable(true);
			#end
			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearUnused();
			Paths.clearStoredMemory();
			openfl.system.System.gc();
		});

		FlxG.signals.postStateSwitch.add(() -> {
			#if cpp
			cpp.NativeGc.run(false);
			cpp.NativeGc.enable(false);
			#end
			Paths.clearUnusedMemory();
			openfl.system.System.gc();
		});

		coolGame = new VSGame(1280, 720, InitialState, #if (flixel < "5.0.0") -1, #end 60, 60, true, false);
		addChild(coolGame);

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

	public function setFramerate(value:Float)
    {
        Lib.current.stage.frameRate = value;
    }
}

class VSGame extends flixel.FlxGame
{
	var _viewingCrash:Bool = false;

	override function create(_):Void {
		try
			super.create(_)
		catch (e:Exception)
			return exceptionCaught(e, 'create');
	}

	override function onFocus(_):Void {
		try
			super.onFocus(_)
		catch (e:Exception)
			return exceptionCaught(e, 'onFocus');
	}

	override function onFocusLost(_):Void {
		try
			super.onFocusLost(_)
		catch (e:Exception)
			return exceptionCaught(e, 'onFocusLost');
	}

	override function onEnterFrame(_):Void {
		try
			super.onEnterFrame(_)
		catch (e:Exception)
			return exceptionCaught(e, 'onEnterFrame');
	}

	override function update():Void {
		if (_viewingCrash)
			return;
		try
			super.update()
		catch (e:Exception)
			return exceptionCaught(e, 'update');
	}

	override function draw():Void {
		try
			super.draw()
		catch (e:Exception)
			return exceptionCaught(e, 'draw');
	}

	@:allow(flixel.FlxG)
	override function onResize(_):Void {
		if (_viewingCrash)
			return;
		super.onResize(_);
	}

	private function exceptionCaught(e:Exception, ?func:String = null)
	{
		#if CRASH_HANDLER
		if (_viewingCrash)
			return;

		var path:String;
		var fileStack:Array<String> = [];
		var dateNow:String = Date.now().toString();
		var println = #if sys Sys.println #else trace #end;

		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		path = 'crash/VisionSphere_${dateNow}.txt';

		for (stackItem in CallStack.exceptionStack(true)) {
			switch (stackItem) {
				case CFunction:
					fileStack.push('Non-Haxe (C) Function');
				case Module(moduleName):
					fileStack.push('Module (${moduleName})');
				case FilePos(s, file, line, col):
					fileStack.push('${file} (line ${line})');
				case Method(className, method):
					fileStack.push('${className} (method ${method})');
				case LocalFunction(name):
					fileStack.push('Local Function (${name})');
			}

			println(stackItem);
		}

		fileStack.insert(0, "Exception: " + e.message);

		final msg:String = fileStack.join('\n');

		if (!FileSystem.exists("crash/"))
			FileSystem.createDirectory("crash/");
		File.saveContent(path, '${msg}\n');

		final funcThrew:String = '${func != null ? ' thrown at "${func}" function' : ""}';

		println(msg + funcThrew);
		println(e.message);
		println('Crash dump saved in ${Path.normalize(path)}');

		FlxG.bitmap.dumpCache();
		FlxG.bitmap.clearCache();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		Main.instance.addChild(new backend.CrashHandler(e.details()));
		_viewingCrash = true;
		#else
		throw e;
		#end
	}
}