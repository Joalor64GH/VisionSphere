package states;

class BootState extends FlxState
{
    override public function create()
    {
        SaveData.init();
        Localization.loadLanguages(['de', 'en', 'es', 'fr', 'it', 'pt']);

        #if desktop
        states.UpdateState.updateCheck();
        #end

        if (states.UpdateState.mustUpdate)
            FlxG.switchState(new states.UpdateState());
        else
            FlxG.switchState((FlxG.save.data.firstLaunch) ? new states.FirstLaunchState() : new states.SplashState());

        super.create();
    }
}