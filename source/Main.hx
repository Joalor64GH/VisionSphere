package;

import flixel.addons.transition.FlxTransitionableState;

import haxe.Exception;
import haxe.CallStack;
import haxe.io.Path;

import frontend.objects.ToastCore;
import frontend.debug.Info;
import frontend.video.*;

import macros.MacroUtil;

import frontend.Colorblind;

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{
	public final config:Dynamic = {
		gameDimensions: [1280, 720],
		initialState: InitialState,
		defaultFPS: 60,
		skipSplash: true,
		startFullscreen: false
	};

	public static var hasWifi:Bool = true;

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
			System.gc();
		});

		FlxG.signals.postStateSwitch.add(() -> {
			#if cpp
			cpp.NativeGc.run(false);
			cpp.NativeGc.enable(false);
			#end
			Paths.clearUnusedMemory();
			System.gc();
		});

		coolGame = new VSGame(config.gameDimensions[0], config.gameDimensions[1], config.initialState, 
			config.defaultFPS, config.defaultFPS, config.skipSplash, config.startFullscreen);
		addChild(coolGame);

		initConfig();

		fpsDisplay = new Info(10, 10, 0xFFFFFF);
		addChild(fpsDisplay);

		var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
		var str1:String = "WEBM SHIT"; 
		var webmHandle = new WebmHandler();
		webmHandle.source(ourSource);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);

		Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);

		#if windows
		Lib.current.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (evt:openfl.events.KeyboardEvent) ->
		{
			if (evt.keyCode == openfl.ui.Keyboard.F2)
			{
				var sp = Lib.current.stage;
				var position = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);

				var image:BitmapData = new BitmapData(Std.int(position.width), Std.int(position.height), false, 0xFEFEFE);
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

	var oldVol:Float = 1.0;
	var newVol:Float = 0.3;

	var focused:Bool = true;

	var focusMusicTween:FlxTween;

	function onWindowFocusOut()
	{
		focused = false;

		if (Type.getClass(FlxG.state) != PlayState)
		{
			oldVol = FlxG.sound.volume;
			newVol = (oldVol > 0.3) ? 0.3 : (oldVol > 0.1) ? 0.1 : 0;

			trace("Game unfocused");

			if (focusMusicTween != null)
				focusMusicTween.cancel();
			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: newVol}, 0.5);

			FlxG.drawFramerate = 30;
		}
	}

	function onWindowFocusIn()
	{
		new FlxTimer().start(0.2, (timer) ->
		{
			focused = true;
		});

		if (Type.getClass(FlxG.state) != PlayState)
		{
			trace("Game focused");

			if (focusMusicTween != null)
				focusMusicTween.cancel();

			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: oldVol}, 0.5);

			FlxG.drawFramerate = config.defaultFPS;
		}
	}

	public static function checkInternet()
	{
		trace('checking internet rq');
		var http = new haxe.Http('https://www.google.com/');
		http.onStatus = (status:Int) -> {
			switch (status) {
				case 200:
					hasWifi = true;
					trace('success!');
				default:
					hasWifi = false;
					trace('offline lol');
			}
		}

		http.onError = (e) -> {
			hasWifi = false;
			trace('something happened, so we offline by default lol');
		}

		http.request();		
	}

	private static function initConfig() 
	{
		SaveData.init();

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end

		Localization.loadLanguages();
		Localization.switchLanguage(SaveData.settings.lang);

		Colorblind.updateColorBlindFilter(SaveData.settings.colorBlindFilter);

		FlxG.sound.muteKeys = [NUMPADZERO, ZERO];
		FlxG.sound.volumeDownKeys = [NUMPADMINUS, MINUS];
		FlxG.sound.volumeUpKeys = [NUMPADPLUS, PLUS];
	}

	public static function switchState(target:FlxState)
	{
		if (!FlxTransitionableState.skipNextTransIn)
		{
			FlxG.state.openSubState(new TransitionSubState(0.35, false));
			TransitionSubState.finishCallback = () -> 
			{
				FlxG.switchState(target);
			};
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		FlxTransitionableState.skipNextTransOut = false;
		FlxG.switchState(target);
	}

	public static function updateFramerate(newFramerate:Int)
	{
		if (newFramerate > FlxG.updateFramerate)
		{
			FlxG.updateFramerate = newFramerate;
			FlxG.drawFramerate = newFramerate;
		}
		else
		{
			FlxG.drawFramerate = newFramerate;
			FlxG.updateFramerate = newFramerate;
		}
	}
}

class VSGame extends FlxGame
{
	var _viewingCrash:Bool = false;

	public function new(gameWidth:Int = 0, gameHeight:Int = 0, initialState:Class<FlxState>, updateFramerate:Int = 60, drawFramerate:Int = 60, skipSplash:Bool = false, startFullscreen:Bool = false) 
	{
		super(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen);
		_customSoundTray = VSSoundTray;
	}

	override function create(_):Void {
		try {
			super.create(_);
			
			removeChild(soundTray);
			addChild(soundTray);
		}
		catch (e:Exception)
			return exceptionCaught(e, 'create');
	}

	override function onFocus(_):Void {
		try super.onFocus(_) catch (e:Exception)
			return exceptionCaught(e, 'onFocus');
	}

	override function onFocusLost(_):Void {
		try super.onFocusLost(_) catch (e:Exception)
			return exceptionCaught(e, 'onFocusLost');
	}

	override function onEnterFrame(_):Void {
		try super.onEnterFrame(_) catch (e:Exception)
			return exceptionCaught(e, 'onEnterFrame');
	}

	override function update():Void {
		if (_viewingCrash) return;
		try super.update() catch (e:Exception)
			return exceptionCaught(e, 'update');
	}

	override function draw():Void {
		try super.draw() catch (e:Exception)
			return exceptionCaught(e, 'draw');
	}

	@:allow(flixel.FlxG)
	override function onResize(_):Void {
		if (_viewingCrash) return;
		super.onResize(_);
	}

	private function exceptionCaught(e:Exception, ?func:String = null)
	{
		#if CRASH_HANDLER
		if (_viewingCrash) return;

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

class VSSoundTray extends flixel.system.ui.FlxSoundTray 
{
	var _bar:Bitmap;

	public function new()
	{
		super();
		removeChildren();

		final bg = new Bitmap(new BitmapData(80, 25, false, 0xff3f3f3f));
		addChild(bg);

		_bar = new Bitmap(new BitmapData(75, 25, false, 0xffffffff));
		_bar.x = 2.5;
		addChild(_bar);

		final tmp:Bitmap = new Bitmap(Assets.getBitmapData("assets/images/objects/soundtray.png", false), null, true);
		addChild(tmp);

		screenCenter();

		tmp.scaleX = 0.5;
		tmp.scaleY = 0.5;
		tmp.x -= tmp.width * 0.2;
		tmp.y -= 5;

		y = -height;
		visible = false;
	}

	override function update(elapsed:Float) {
		super.update(elapsed * 4);
	}

	override function show(up:Bool = false) 
	{
		if (!silent)
		{
			final sound = flixel.system.FlxAssets.getSound("assets/sounds/scroll");
			if (sound != null) FlxG.sound.load(sound).play();
		}

		_timer = 4;
		y = 0;
		visible = active = true;
		_bar.scaleX = FlxG.sound.muted ? 0 : FlxG.sound.volume;
	}

	override function screenCenter()
	{
		_defaultScale = Math.min(FlxG.stage.stageWidth / FlxG.width, FlxG.stage.stageHeight / FlxG.height) * 2;
		super.screenCenter();
	}
}