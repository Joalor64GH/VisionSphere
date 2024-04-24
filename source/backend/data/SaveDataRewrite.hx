package backend.data;

class SaveDataRewrite
{
	static public function init()
	{
		for (option in defaultSettings)
			if (getData(option[0]) == null)
				saveData(option[0], option[1]);
	}

	static public function saveData(save:String, value:Dynamic)
	{
		Reflect.setProperty(FlxG.save.data, save, value);
		FlxG.save.flush();
	}

	static public function getData(save:String):Dynamic
	{
		return Reflect.getProperty(FlxG.save.data, save);
	}

	static public function resetData()
	{
		FlxG.save.erase();
		init();
	}

	static public var defaultSettings:Array<Array<Dynamic>> = [
		["option1", true],
		["option2", 0],
		["option3", 'etc']
	];
}