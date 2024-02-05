package;

import flixel.FlxGame;

import openfl.Lib;

#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
#end

import display.ToastCore;
import display.Info;

#if linux
import lime.graphics.Image;
#end

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

using StringTools;

class Main extends openfl.display.Sprite
{
	public static final gameVersion:String = '0.5.0';

	public static var toast:ToastCore;
	public static var fpsDisplay:Info;

	public function new()
	{
		super();

		#if windows
		util.Windows.darkMode(true);
		#end

		addChild(new FlxGame(1280, 720, states.BootState, #if (flixel < "5.0.0") -1, #end 60, 60, true, false));

		fpsDisplay = new Info(10, 3, 0xFFFFFFFF);
		addChild(fpsDisplay);

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		toast = new ToastCore();
		addChild(toast);
	}

	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
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

		Application.current.window.alert(errMsg, "Error!");
		Sys.exit(0);
	}
	#end
}