package;

import openfl.Lib;

#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
#end

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

	public function new()
	{
		super();

		#if windows
		util.Windows.darkMode(true);
		#end

		var timer = new haxe.Timer();
		timer.run = () -> {
			coloring();
			if (fpsDisplay.textColor == 0)
				fpsDisplay.textColor = -4775566;
		}

		addChild(new flixel.FlxGame(1280, 720, states.BootState, #if (flixel < "5.0.0") -1, #end 60, 60, true, false));

		fpsDisplay = new Info(10, 10, 0xFFFFFF);
		addChild(fpsDisplay);

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (e) ->
		{
			var errMsg:String = "";
			var path:String;
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString();

			dateNow = dateNow.replace(" ", "_");
			dateNow = dateNow.replace(":", "'");

			path = "./crash/" + "VisionSphere_" + dateNow + ".txt";

			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						Sys.println(stackItem);
				}
			}

			errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/Joalor64GH/VisionSphere\n\n> Crash Handler written by: sqirra-rng";

			if (!FileSystem.exists("./crash/"))
				FileSystem.createDirectory("./crash/");

			File.saveContent(path, errMsg + "\n");

			Sys.println(errMsg);
			Sys.println("Crash dump saved in " + Path.normalize(path));

			#if windows
			util.Windows.messageBox("Error!", errMsg, MSG_ERROR);
			#else
			Application.current.window.alert(errMsg, "Error!");
			#end
		
			Sys.exit(0);
		});
		#end

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

	var colArray:Array<FlxColor> = [
		FlxColor.fromRGB(216, 34, 83),
		FlxColor.fromRGB(255, 38, 0),
		FlxColor.fromRGB(255, 80, 0),
		FlxColor.fromRGB(255, 147, 0),
		FlxColor.fromRGB(255, 199, 0),
		FlxColor.fromRGB(255, 255, 0),
		FlxColor.fromRGB(202, 255, 0),
		FlxColor.fromRGB(0, 255, 0),
		FlxColor.fromRGB(0, 146, 146),
		FlxColor.fromRGB(0, 0, 255),
		FlxColor.fromRGB(82, 40, 204),
		FlxColor.fromRGB(150, 33, 146)
	];
	
	var skippedFrames:Int = 0;
	var currentColor:Int = 0;

	public function coloring():Void
	{
		if (SaveData.rainbowFps)
		{
			if (currentColor >= array.length)
				currentColor = 0;
			currentColor = Math.round(FlxMath.lerp(0, array.length, skippedFrames / SaveData.framerate));
			(cast(Lib.current.getChildAt(0), Main)).changeFPSColor(array[currentColor]);
			currentColor++;
			skippedFrames++;
			if (skippedFrames > SaveData.framerate)
				skippedFrames = 0;
		}
		else
			fpsDisplay.textColor = FlxColor.fromRGB(255, 255, 255);
	}
	inline public function changeFPSColor(color:FlxColor)
		fpsDisplay.textColor = color;
}