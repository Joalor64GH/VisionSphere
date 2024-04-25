package states;

class UpdateState extends FlxState
{
    public static var mustUpdate:Bool = false;
    public static var updateVersion:String = '';

    override public function create()
    {
        super.create();

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

        var text:FlxText = new FlxText(0, 0, FlxG.width, 
            "Hey! You're running an outdated version of VisionSphere!"
            + '\nThe version you're currently running is v${Lib.application.meta.get('version')}!'
            + '\nPress ENTER to update to v${updateVersion}! Otherwise, press ESCAPE.'
            + "\nThanks for playing!",
            32);
        text.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter(XY);
        add(text);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var accept = Input.is('accept') || (gamepad != null ? Input.gamepadIs('gamepad_accept') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (accept)
        {
            FlxG.sound.play(Paths.sound('confirm'));
            CoolUtil.browserLoad("https://github.com/Joalor64GH/VisionSphere/actions/");
        }
        else if (exit)
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(SplashState.new);
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }

    public static function updateCheck()
    {
        var http = new haxe.Http("https://raw.githubusercontent.com/Joalor64GH/VisionSphere/main/compileData/gitVersion.txt");

        http.onData = (data:String) ->
        {
            updateVersion = data.split('\n')[0].trim();
            mustUpdate = (updateVersion != Lib.application.meta.get('version')) ? true : false;
        }

        http.onError = (error) ->
        {
            trace('error: $error');
        }

        http.request();
    }
}