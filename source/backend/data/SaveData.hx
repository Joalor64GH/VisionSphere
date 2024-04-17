package backend.data;

class SaveData
{
    static public var defaultOptions:Array<Array<Dynamic>> = [ // name, value
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
        ["leftKey", 'LEFT'],
        ["downKey", 'DOWN'],
        ["upKey", 'UP'],
        ["rightKey", 'RIGHT'],
        ["acceptKey", 'ENTER'],
        ["exitKey", 'ESCAPE'],
        ["gamepadLeftKey", 'DPAD_LEFT'],
        ["gamepadDownKey", 'DPAD_DOWN'],
        ["gamepadUpKey", 'DPAD_UP'],
        ["gamepadRightKey", 'DPAD_RIGHT'],
        ["gamepadAcceptKey", 'DPAD_A'],
        ["gamepadExitKey", 'DPAD_B']
    ];
    
    static public function init()
    {
        for (option in defaultOptions)
            if (getData(option[0]) == null)
                saveData(option[0], option[1]);
        
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