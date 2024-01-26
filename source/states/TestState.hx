package states;

// this is just a simple event test

class TestState extends FlxState
{
    // setup variables
    var something:String = "";
    var text:String = "abcdefghijklmnopqrstuvwxyz";
    var event:Event<String->String>;

    public function new()
    {
        super();

        event = new Event<String->String>;
        
        // setup event
        event.createEvent("EVENT_PARSE");
        event.addEventCallback(function(str:String) {
            var tmp:String = str;
            tmp = tmp.substr(2, 3);
            return tmp;
        }, "EVENT_PARSE");

        // trigger event
        something = event.trigger("EVENT_PARSE", "coolCallback", [text]);
        trace(something);
    }
}