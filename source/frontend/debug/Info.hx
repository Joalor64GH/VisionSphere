package frontend.debug;

class Info extends openfl.text.TextField
{
	public var times:Array<Float> = [];
	public var memoryMegas(get, never):Float;
	public var currentFrames(default, null):Int;

	public function new(x:Float, y:Float, color:Int, ?font:String)
	{
		super();

		text = "";
		this.x = x;
		this.y = y;
		width = 1280;
		height = 720;
		selectable = false;
		defaultTextFormat = new openfl.text.TextFormat(font != null ? font : Paths.font('vcr.ttf'), 16, 0xFFFFFF);
		addEventListener(openfl.events.Event.ENTER_FRAME, (_) ->
		{
			final now:Float = haxe.Timer.stamp() * 1000;
			times.push(now);
			while (times[0] < now - 1000) times.shift();

			currentFrames = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;

			textColor = (currentFrames < FlxG.drawFramerate * 0.5) ? 0xFFFF0000 : 0xFFFFFFFF;
			text = (visible) ? 
				"FPS: " + currentFrames + "\nMemory: " + flixel.util.FlxStringUtil.formatBytes(memoryMegas) + "\nVersion: " + Application.current.meta.get('version') : "";
		});
	}

	inline function get_memoryMegas():Float
		return cast(cast(openfl.system.System.totalMemory, UInt), Float);
}