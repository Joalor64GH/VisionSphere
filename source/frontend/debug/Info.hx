package frontend.debug;

class Info extends openfl.text.TextField
{
	public var memPeak:Float;
	public var times:Array<Float> = [];

	public function new(x:Float, y:Float, color:Int, ?font:String)
	{
		super();

		text = "";
		this.x = x;
		this.y = y;
		width = 1280;
		height = 720;
		selectable = false;
		defaultTextFormat = new openfl.text.TextFormat(Paths.font((font != null) ? font : 'vcr.ttf'), 18, 0xFFFFFF);
		addEventListener(openfl.events.Event.ENTER_FRAME, (_) ->
		{
			final now:Float = haxe.Timer.stamp() * 1000;
			times.push(now);
			while (times[0] < now - 1000) times.shift();

			var mem:Float = openfl.system.System.totalMemory;
			memPeak = memPeak > mem ? memPeak : mem;

			var currentFrames:Float = times.length;
			if (currentFrames > FlxG.updateFramerate) currentFrames = FlxG.updateFramerate;

			textColor = (currentFrames <= SaveData.framerate / 4) ?
				0xFFFF0000 : (currentFrames <= SaveData.framerate / 2) ?
					0xFFFFFF00 : 0xFFFFFFFF;
			
			text = (visible) ? 
				"FPS: " + currentFrames + "\nMemory: " + flixel.util.FlxStringUtil.formatBytes(mem) + " / " + flixel.util.FlxStringUtil.formatBytes(memPeak)
				+ "\nVisionSphere v" + openfl.Lib.application.meta.get('version') : "";
		});
	}
}