package states;

import util.PlatformUtil;

class BootState extends FlxState
{
    override public function create()
    {
        SaveData.init();

        // Plugins.loadPlugins();

        #if desktop
        states.UpdateState.updateCheck();
        FlxG.switchState((states.UpdateState.mustUpdate) ? new states.UpdateState() : new states.SplashState());
        #else
        trace('Sorry! No update support on: ' + PlatformUtil.getPlatform() + '!')
        FlxG.switchState(new states.SplashState());
        #end
        
        Localization.loadLanguages(['de', 'en', 'es', 'fr', 'it', 'pt']);
        Localization.switchLanguage(FlxG.save.data.lang);

        FlxG.sound.muteKeys = [NUMPADZERO];
        FlxG.sound.volumeDownKeys = [NUMPADMINUS];
        FlxG.sound.volumeUpKeys = [NUMPADPLUS];

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}