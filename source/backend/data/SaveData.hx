package backend.data;

class SaveData {
	public static var settings:Map<String, Dynamic> = [ // name, value
		// strings
		"timeFormat" => '%r',
		"theme" => 'daylight',
		"lang" => 'en',
		"username" => 'blue',
		"profile" => 'blue',
		// ints
		"framerate" => 60,
		"colorBlindFilter" => -1,
		// bools
		"fpsCounter" => true,
		#if desktop
		"fullscreen" => false,
		#end
		// controls
		"keyboardBinds" => ['LEFT', 'DOWN', 'UP', 'RIGHT', 'ENTER', 'ESCAPE'],
		"gamepadBinds" => ['DPAD_LEFT', 'DPAD_DOWN', 'DPAD_UP', 'DPAD_RIGHT', 'A', 'B']
	];

	public static function saveSettings() {
		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('settings');
		settingsSave.data.settings = settings;
		settingsSave.close();

		trace('settings saved!');
	}

	public static function init() {
		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('settings');
		if (settingsSave != null) {
			if (settingsSave.data.settings != null) {
				var savedMap:Map<String, Dynamic> = settingsSave.data.settings;
				for (name => value in savedMap) {
					switch (name) {
						case "framerate":
							Main.updateFramerate(value);
					}
					settings.set(name, value);
				}
			}
		}
		settingsSave.destroy();
	}
}