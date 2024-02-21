package display;

import haxe.Timer;

class Info extends openfl.text.TextField
{
	private var memPeak:Float = 0;
	private var times:Array<Float> = [];

	public function new(x:Float, y:Float, color:Int)
	{
		super();

		text = "";

		this.x = x;
		this.y = y;
		width = 1280;
		height = 720;
		selectable = false;
		defaultTextFormat = new openfl.text.TextFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFF);
		addEventListener(openfl.events.Event.ENTER_FRAME, (_) ->
		{
			var now:Float = Timer.stamp();
			times.push(now);
			while (times[0] < now - 1)
				times.shift();

			var currentFrames:Int = times.length;
			if (currentFrames > SaveData.framerate)
				currentFrames = SaveData.framerate;

			textColor = (currentFrames <= SaveData.framerate / 4) ? 
				0xFFFF0000 : (currentFrames <= SaveData.framerate / 2) ?
					0xFFFFFF00 : 0xFFFFFFFF;

			var mem:Float = openfl.system.System.totalMemory;

			if (mem > memPeak)
				memPeak = mem;
			
			text = (visible) ? 
				"FPS: " + currentFrames + "\nMemory: " + mem + " MB\nMemory Peak: " + memPeak + " MB\nVersion: " + Application.current.meta.get('version') : "";
		});
	}
}