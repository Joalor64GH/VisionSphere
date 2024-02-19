package display;

import haxe.Timer;

class Info extends openfl.text.TextField
{
	public var memPeak:Float = 0;
	public var times:Array<Float> = [];

	public function new(x:Float = 10, y:Float = 3, color:Int = 0xFFFFFF)
	{
		super();

		text = "";

		this.x = x;
		this.y = y;
		width = 1280;
		height = 720;
		selectable = false;
		defaultTextFormat = new openfl.text.TextFormat(Paths.font('vcr.ttf'), 16, color);
		addEventListener(openfl.events.Event.ENTER_FRAME, (_) ->
		{
			var now:Float = Timer.stamp();
			times.push(now);
			while (times[0] < now - 1)
				times.shift();

			var mem:Float = Math.abs(Math.round(openfl.system.System.totalMemory / 1024 / 1024 * 100) / 100);

			if (mem > memPeak)
				memPeak = mem;
			
			text = (visible) ? 
				"FPS: " + times.length + "\nMemory: " + mem + " MB\nMemory Peak: " + memPeak + " MB\nVersion: " + Application.current.meta.get('version') : "";
		});
	}
}