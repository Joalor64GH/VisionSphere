package backend.data;

class SaveData
{
    static public var defaultOptions:Array<Array<Dynamic>> = [
        // strings
        ["timeFormat", '%r'],
        ["theme", 'daylight'],
        ["lang", 'en'],
        ["username", 'user'],
        ["profile", 'blue'],
        // booleans
        ["fpsCounter", true],
        #if desktop
        ["fullscreen", false],
        #end
        // ints
        ["colorBlindFilter", -1],
        ["framerate", 60],
        // controls
        ["keyboardBinds", ['LEFT', 'DOWN', 'UP', 'RIGHT', 'ENTER', 'ESCAPE']],
        ["gamepadBinds", ['DPAD_LEFT', 'DPAD_DOWN', 'DPAD_UP', 'DPAD_RIGHT', 'A', 'B']]
    ];
    
    static public function init()
    {
        for (option in defaultOptions)
            if (getData(option[0]) == null)
                saveData(option[0], option[1]);

        for (i in 0...5)
            if (getData('keyboardBinds')[i] == null)
                saveData('keyboardBinds', ['LEFT', 'DOWN', 'UP', 'RIGHT', 'ENTER', 'ESCAPE']);

        for (i in 0...5)
            if (getData('gamepadBinds')[i] == null)
                saveData('gamepadBinds', ['DPAD_LEFT', 'DPAD_DOWN', 'DPAD_UP', 'DPAD_RIGHT', 'A', 'B']);
        
        FlxG.save.bind('VisionSphere', 'Joalor64');
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
}