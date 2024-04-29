package backend.data;

typedef SaveSettings = {
	var timeFormat:String;
	var theme:String;
	var lang:String;
	var username:String;
	var profile:String;
	var framerate:Int;
	var colorBlindFilter:Int;
	var fpsCounter:Bool;
	#if desktop
	var fullscreen:Bool;
	#end
	var keyboardBinds:Array<FlxKey>;
	var gamepadBinds:Array<FlxGamepadInputID>;
}

class SaveDataV2 {
	public static var settings:SaveSettings = {
		timeFormat: '%r',
		theme: 'daylight',
		lang: 'en',
		username: 'user',
		profile: 'blue',
		framerate: 60,
		colorBlindFilter: -1,
		fpsCounter: true,
		fullscreen: false,
		keyboardBinds: [LEFT, DOWN, UP, RIGHT, ENTER, ESCAPE],
		gamepadBinds: [DPAD_LEFT, DPAD_DOWN, DPAD_UP, DPAD_RIGHT, A, B]
	};

	public static function init() {
		for (key in Reflect.fields(settings))
			Reflect.setField(settings, key, Reflect.field(FlxG.save.data, key));
		
		if (Main.fpsDisplay != null)
			Main.fpsDisplay.visible = settings.fpsCounter;
		
		Main.updateFramerate(settings.framerate);
	}

	public static function saveSettings() {
		for (key in Reflect.fields(settings))
			Reflect.setField(FlxG.save.data, key, Reflect.field(settings, key));
			
		FlxG.save.flush();

		trace('settings saved!');
	}
}