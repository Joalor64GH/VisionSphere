package base;

import Reflect;

class Plugins // kinda broken
{
    public static function loadPlugins()
    {
        var config:Dynamic = Json.parse(Paths.plugin("config.json"));
        var pluginPaths:Array<String> = config.plugins;

        for (path in pluginPaths) {
            loadPlugin(path);
        }
    }

    private static function loadPlugin(path:String)
    {
        var plugin:Dynamic = Paths.plugin(path + ".hx");

        if (plugin != null) {
            callInitializeFunction(plugin);
            trace("plugin loaded: " + plugin);
        } 
        else
            trace("oops! failed to load plugin: " + plugin);
    }

    private static function callInitializeFunction(plugin:Dynamic)
    {
        if (Reflect.hasField(plugin, "initialize") && Reflect.isFunction(Reflect.field(plugin, "initialize")))
            Reflect.callMethod(plugin, Reflect.field(plugin, "initialize"), []);
        else
            trace("Plugin " + plugin + " does not have function 'initialize'");
    }
}