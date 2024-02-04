package states;

import util.PlatformUtil;
import djFlixel.gfx.TextScroller;
import djFlixel.gfx.pal.Pal_CPCBoy;

class BootState extends FlxState
{
    override function create()
    {
        SaveData.init();
        Localization.loadLanguages(['de', 'en', 'es', 'fr', 'it', 'pt']);

        FlxG.sound.muteKeys = [NUMPADZERO];
        FlxG.sound.volumeDownKeys = [NUMPADMINUS];
        FlxG.sound.volumeUpKeys = [NUMPADPLUS];

        var ts = new TextScroller("Loading... Please Wait :)", 
            {f:Paths.font('vcr.ttf'), s:16, bc:Pal_CPCBoy.COL[2]}, 
            {y:100, speed:2, loopMode:0, sHeight:32, w1:0.06, w0:4}
        );
        add(ts);

        new FlxTimer().start(8, function(timer)
        {
            #if desktop
            states.UpdateState.updateCheck();
            FlxG.switchState((states.UpdateState.mustUpdate) ? new states.UpdateState() : new states.SplashState());
            #else
            trace('Sorry! No update support on: ' + PlatformUtil.getPlatform() + '!')
            FlxG.switchState(new states.SplashState());
            #end
        });

        super.create();
    }

    override function update(elapsed)
    {
        super.update(elapsed);
    }
}