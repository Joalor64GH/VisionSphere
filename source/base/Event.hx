package base;

import haxe.Exception;

/**
 * @author Sirox228
 * @see https://github.com/Sirox228/CustomEvents/
 */

class Event<T>
{
    public function new() {
        trace("did your new Event work? if it did, good! otherwise, report the problem.");
    }

    public function createEvent(event:String) {
        if (!Reflect.hasField(this, event))
            Reflect.setProperty(this, event, event);
    }

    public function addEventCallback(callback:T, event:String) {
        if (!Reflect.hasField(this, event))
            throw new Exception("no such Event, use createEvent to add one");
        else
            Reflect.setProperty(this, event + "callback", callback);
    }

    public function trigger(event:String, args:Array<Dynamic>):Dynamic {
        if (Reflect.hasField(this, event) && Reflect.hasField(this, event + "callback"))
            return Reflect.callMethod(this, Reflect.getProperty(this, event + "callback"), args);
        else {
            if (!Reflect.hasField(this, event) && Reflect.hasField(this, event + "callback"))
                throw new Exception("no such Event, use createEvent to add one");
            else if (!Reflect.hasField(this, event + "callback") && Reflect.hasField(this, event))
                throw new Exception("no such Event, use addEventCallback to add one");
            else
                throw new Exception("no such event or callback, use createEvent, then addEventCallback to add them");
        }

        return "haxe won't compile without this return so idk"; 
    }
}