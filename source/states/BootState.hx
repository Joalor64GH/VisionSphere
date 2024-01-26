package states;

import util.PlatformUtil;

class BootState extends FlxState
{
    override public function create()
    {
        SaveData.init();
        Localization.loadLanguages(['de', 'en', 'es', 'fr', 'it', 'pt']);

        #if desktop
        states.UpdateState.updateCheck();
        FlxG.switchState((states.UpdateState.mustUpdate) ? new states.UpdateState() : (FlxG.save.data.firstLaunch) ? new states.FirstLaunchState() : new states.SplashState());
        #else
        trace('Sorry! No update support on: ' + PlatformUtil.getPlatform() + '!')
        FlxG.switchState((FlxG.save.data.firstLaunch) ? new states.FirstLaunchState() : new states.SplashState());
        #end

        super.create();
    }
}