package display;

import openfl.Lib;
import openfl.display.FPS;
import openfl.events.Event;
import openfl.system.System;

class FPS extends openfl.text.TextField
{
	public var memPeak:Float = 0;
	public var curFps:Int = 0;

	public var fps:FPS = 0.0;

	public function new(x:Float = 10, y:Float = 3, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		width = 1280;
		height = 720;

		selectable = false;
		defaultTextFormat = new openfl.text.TextFormat(Paths.font('vcr.ttf'), 16, color);

		fps = new FPS(10000, 10000, color);
		fps.visible = false;
		Lib.current.addChild(fps);

		addEventListener(Event.ENTER_FRAME, onEnter);
	}

	private function onEnter(event:Event)
	{
		curFPS = fps.currentFPS;
		text = (visible) ? "FPS: " + curFPS + "\n" + memFunc() : "";
	}

	function memFunc()
	{
		var mem:Float = Math.abs(Math.round(System.totalMemory / 1024 / 1024 * 100) / 100);

		if (mem > memPeak)
			memPeak = mem;

		text += "Memory: " + mem + " MB\n" + "Memory Peak: " + memPeak + " MB";
	}
}