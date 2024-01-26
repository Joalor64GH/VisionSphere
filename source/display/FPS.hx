package display;

import external.memory.Memory;

class FPS extends openfl.text.TextField
{
	public var fps:Int = 0;
	public var _fps:Int = 0;
	public var memUsage:Float = 0.0;
	public var memUsagePeak:Float = 0.0;
	public var curTime:Float = 0.0;

	public function new(x:Float = 10, y:Float = 3, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		width = 1280;
		height = 720;

		selectable = mouseEnabled = false;
		defaultTextFormat = new openfl.text.TextFormat(Paths.font('vcr.ttf'), 16, color);

		FlxG.signals.postDraw.add(update);
	}

	public function update():Void
	{
		curTime += FlxG.elapsed;

		if (_fps < FlxG.stage.frameRate)
			_fps += 1;
		
		if (curTime >= 1.0)
		{
			fps = _fps = 0;
			curTime = 0.0;
		}

		memUsage = Std.parseFloat(CoolUtil.formatBytes(Memory.getCurrentUsage(), true));
		memUsagePeak = Std.parseFloat(CoolUtil.formatBytes(Memory.getPeakUsage(), true));

		text = "FPS: + fps + "\n"
			+ CoolUtil.formatBytes(Memory.getCurrentUsage()) + " / " + CoolUtil.formatBytes(Memory.getPeakUsage());
	}
}