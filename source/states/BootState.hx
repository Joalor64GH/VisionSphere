package states;

class BootState extends FlxState
{
    override public function create()
    {
        SaveData.init();
        Localization.loadLanguages(['de', 'en', 'es', 'fr', 'it', 'pt']);

        FlxG.switchState((FlxG.save.data.firstLaunch) ? new states.FirstLaunchState() : new states.SplashState());

        super.create();
    }
}