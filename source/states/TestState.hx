package states;

// this is just a simple event test
class TestState extends FlxState
{
    // setup variables
    var something:String = "";
    var text:String = "abcdefghijklmnopqrstuvwxyz";
    var event:Event<String->String>;

    override function create()
    {
        super.create();

        // setup event
        event = new Event<String->String>();
        event.createEvent("EVENT_PARSE");
        event.addEventCallback((str:String) -> {
            var tmp:String = str;
            tmp = tmp.substr(2, 3);
            return tmp;
        }, "EVENT_PARSE");

        // trigger event
        something = event.trigger("EVENT_PARSE", [text]);
        trace(something);

        add(new FlxText("Hello World", 64).screenCenter());
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
            FlxG.switchState(MenuState.new);
    }
}