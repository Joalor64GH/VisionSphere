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

        event = new Event<String->String>(function(str:String):String {
            var tmp:String = str;
            tmp = tmp.substr(2, 3);
            return tmp;
        });

        // setup event
        event.createEvent("EVENT_PARSE");
        event.addEventCallback(function(str:String) {
            return "Modified Text: " + str;
        }, "EVENT_PARSE");

        // trigger event
        something = event.trigger("EVENT_PARSE", [text]);
        trace(something);

        var text2 = new FlxText(0, 0, 0, something, 64);
        text2.screenCenter();
        add(text2);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}