package states;

class UpdateState extends FlxState
{
    public static var mustUpdate:Bool = false;
    public static var updateVersion:String = '';

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

        var text:FlxText = new FlxText(0, 200, FlxG.width, 
            "Hey! You're running an outdated version of VisionSphere!" + "\n
            The version you're currently running is v" + Main.gameVersion + "!\n
            Press ENTER to update to v" + updateVersion + "! Otherwise, press ESCAPE." + "\n
            Thanks for playing!",
            32);
        text.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        text.screenCenter(X);
        add(text);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('accept'))
        {
            FlxG.sound.play(Paths.sound('confirm'));
            CoolUtil.browserLoad("https://github.com/Joalor64GH/VisionSphere/actions/");
        }
        else if (Input.is('exit'))
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
            {
                FlxG.switchState(new states.SplashState());
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
            var curVersion:String = Main.gameVersion.trim();
            mustUpdate = (updateVersion != curVersion) ? true : false;
        }

        http.onError = (error) ->
        {
            trace('error: $error');
        }

        http.request();
    }
}