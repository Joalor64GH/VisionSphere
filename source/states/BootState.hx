package states;

import util.PlatformUtil;
import djFlixel.gfx.TextScroller;
import djFlixel.gfx.pal.Pal_DB32;

class BootState extends FlxState
{
    override public function create()
    {
        SaveData.init();
        Localization.loadLanguages(['de', 'en', 'es', 'fr', 'it', 'pt']);

        FlxG.sound.muteKeys = [NUMPADZERO];
        FlxG.sound.volumeDownKeys = [NUMPADMINUS];
        FlxG.sound.volumeUpKeys = [NUMPADPLUS];

        var ts:TextScroller = new TextScroller("Loading... Please Wait :)", {
                f:Paths.font('vcr.ttf'), 
                s:16, 
                c:Pal_DB32.COL[21], 
                bc:Pal_DB32.COL[1]
            }, {
                y:100, 
                speed:2, 
                loopMode:0,
                sHeight:32, 
                w0:4, 
                w1:0.06
            }
        );
        add(ts);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        new FlxTimer().start(5, function(tmr:FlxTimer)
        {
            #if desktop
            states.UpdateState.updateCheck();
            FlxG.switchState((states.UpdateState.mustUpdate) ? new states.UpdateState() : (FlxG.save.data.firstLaunch) ? new states.FirstLaunchState() : new states.SplashState());
            #else
            trace('Sorry! No update support on: ' + PlatformUtil.getPlatform() + '!')
            FlxG.switchState((FlxG.save.data.firstLaunch) ? new states.FirstLaunchState() : new states.SplashState());
            #end
        });

        super.update(elapsed);
    }
}