package states.games.rhythmo;

import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;

class Transition extends FlxSubState
{
    var transition:FlxBackdrop;

    var finishCallback(default, null):() -> Void;
    var duration(defualt, null):Float;
    var transitionIn(default, null):Bool;

    public function new(?finishCallback:() -> Void, duration:Float, transitionIn:Bool):Void
    {
        super();

        this.finishCallback = finishCallback;
        this.duration = duration;
        this.transitionIn = transitionIn;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];

        transition = new FlxBackdrop(FlxGradient.createGradientBitmapData(FlxG.width, FlxG.height, [0x0, FlxColor.BLACK], 1, transitionIn ? 90 : -90), X);
        transition.camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
        transition.alpha = 0.75;
        transition.setPosition(0, transitionIn ? -transition.height : FlxG.height);
        add(transition);

        new FlxTimer().start(duration, (timer) -> 
        {
            close();

            if (finishCallback != null)
                finishCallback();

            finishCallback = null;
        });
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        transition.y = transitionIn ? transition.y + (1450 * elapsed) : transition.y - (1450 * elapsed);
    }
}