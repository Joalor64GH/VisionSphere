package flixel.system;

import openfl.display.Graphics;
import openfl.display.Sprite;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class FlxSplash extends FlxState
{
	public static var nextState:Class<FlxState>;

	var _sprite:Sprite;
	var _gfx:Graphics;
	var _text:TextField;

	var _times:Array<Float>;
	var _colors:Array<Int>;
	var _functions:Array<Void->Void>;
	var _curPart:Int = 0;
	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;

	override public function create():Void
	{
		_cachedBgColor = FlxG.cameras.bgColor;
		FlxG.cameras.bgColor = FlxColor.BLACK;

		_cachedTimestep = FlxG.fixedTimestep;
		FlxG.fixedTimestep = false;

		_cachedAutoPause = FlxG.autoPause;
		FlxG.autoPause = false;

		#if FLX_KEYBOARD
		FlxG.keys.enabled = false;
		#end

		_times = [0.041, 0.184, 0.334, 0.495, 0.636];
		_colors = [0x00b922, 0xffc132, 0xf5274e, 0x3641ff, 0x04cdfb];
		_functions = [drawGreen, drawYellow, drawRed, drawBlue, drawLightBlue];

		for (time in _times)
			new FlxTimer().start(time, timerCallback);

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		_sprite = new Sprite();
		FlxG.stage.addChild(_sprite);
		_gfx = _sprite.graphics;

		_text = new TextField();
		_text.selectable = false;
		_text.embedFonts = true;
		var dtf = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		_text.defaultTextFormat = dtf;
		_text.text = "";
		FlxG.stage.addChild(_text);

		onResize(stageWidth, stageHeight);

		FlxG.sound.load(Paths.sound("flixel")).play();
	}

	override public function destroy():Void
	{
		_sprite = null;
		_gfx = null;
		_text = null;
		_times = null;
		_colors = null;
		_functions = null;
        
		super.destroy();
	}

	override public function onResize(Width:Int, Height:Int):Void
	{
		super.onResize(Width, Height);

		_sprite.x = (Width / 2);
		_sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

		_text.width = Width / FlxG.game.scaleX;
		_text.x = 0;
		_text.y = _sprite.y + 80 * FlxG.game.scaleY;

		_sprite.scaleX = _text.scaleX = FlxG.game.scaleX;
		_sprite.scaleY = _text.scaleY = FlxG.game.scaleY;
	}

	function timerCallback(Timer:FlxTimer):Void
	{
		_functions[_curPart]();
		_text.textColor = _colors[_curPart];
		_curPart++;

		if (_curPart == 5)
		{
			FlxTween.tween(_sprite, {alpha: 0}, 3.0, {ease: FlxEase.quadOut, onComplete: onComplete});
			FlxTween.tween(_text, {alpha: 0}, 3.0, {ease: FlxEase.quadOut});
		}
	}

	function drawGreen():Void
	{
		_gfx.beginFill(0x4fc3f7);
		_gfx.moveTo(0, -37);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(0, -37);
		_gfx.endFill();
        _text.text = "Made";
	}

	function drawYellow():Void
	{
		_gfx.beginFill(0xe1f5fe);
		_gfx.moveTo(-50, -50);
		_gfx.lineTo(-25, -50);
		_gfx.lineTo(0, -37);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(-50, -25);
		_gfx.lineTo(-50, -50);
		_gfx.endFill();
        _text.text += " with";
	}

	function drawRed():Void
	{
		_gfx.beginFill(0x4fc3f7);
		_gfx.moveTo(50, -50);
		_gfx.lineTo(25, -50);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(50, -25);
		_gfx.lineTo(50, -50);
		_gfx.endFill();
        _text.text += " Haxe";
	}

	function drawBlue():Void
	{
		_gfx.beginFill(0x0288d1);
		_gfx.moveTo(-50, 50);
		_gfx.lineTo(-25, 50);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-50, 25);
		_gfx.lineTo(-50, 50);
		_gfx.endFill();
        _text.text += "Flix";
	}

	function drawLightBlue():Void
	{
		_gfx.beginFill(0x03a9f4);
		_gfx.moveTo(50, 50);
		_gfx.lineTo(25, 50);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(50, 25);
		_gfx.lineTo(50, 50);
		_gfx.endFill();
        _text.text += "el";
	}

	function onComplete(Tween:FlxTween):Void
	{
		FlxG.cameras.bgColor = _cachedBgColor;
		FlxG.fixedTimestep = _cachedTimestep;
		FlxG.autoPause = _cachedAutoPause;
		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end
		FlxG.stage.removeChild(_sprite);
		FlxG.stage.removeChild(_text);
		FlxG.switchState(Type.createInstance(nextState, []));
		FlxG.game._gameJustStarted = true;
	}
}