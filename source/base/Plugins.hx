package base;

// TO-DO: Completely rewrite the plugins system because what is this
class Plugins
{
    public static function loadPlugins()
    {
        var config = Json.parse(File.getContent(Paths.plugin("config.json"))).plugins;
        for (path in config) loadPlugin(path);
    }

    private static function loadPlugin(path:String)
    {
        var plugin = Paths.plugin(path + ".hx");

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