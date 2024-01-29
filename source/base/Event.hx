package base;

import Reflect as Ref;
import haxe.Exception;

/**
 * @author Sirox228
 * @see https://github.com/Sirox228/CustomEvents/
 */

class Event<T>
{
    public function new() {
        trace("new Event successful");
    }

    public function createEvent(event:String) {
        if (!Ref.hasField(this, event))
            Ref.setProperty(this, event, event);
    }

    public function addEventCallback(callback:T, event:String) {
        if (!Ref.hasField(this, event))
            throw new Exception("no such Event, use createEvent to add one");
        else
            Ref.setProperty(this, event + "callback", callback);
    }

    public function trigger(event:String, args:Array<Dynamic>):Dynamic {
        if (Ref.hasField(this, event) && Ref.hasField(this, event + "callback"))
            return Ref.callMethod(this, Ref.getProperty(this, event + "callback"), args);
        else {
            if (!Ref.hasField(this, event) && Ref.hasField(this, event + "callback"))
                throw new Exception("no such Event, use createEvent to add one");
            else if (!Ref.hasField(this, event + "callback") && Ref.hasField(this, event))
                throw new Exception("no such Event, use addEventCallback to add one");
            else
                throw new Exception("no such event or callback, use createEvent, then addEventCallback to add them");
        }

        return "haxe won't compile without this return so idk"; 
    }
}