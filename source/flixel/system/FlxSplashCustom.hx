package flixel.system;

import openfl.display.Graphics;
import openfl.display.Sprite;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class FlxSplashCustom extends FlxState
{
	var _sprite:Sprite;
	var _gfx:Graphics;
	var _text:TextField;

	var _times:Array<Float>;
	var _colors:Array<Int>;
	var _functions:Array<Void->Void>;
	var _curPart:Int = 0;

	var skipTxt:FlxText;

	override public function create():Void
	{
		_times = [0.041, 0.184, 0.334, 0.495, 0.636];
		_colors = [0x4fc3f7, 0xe1f5fe, 0xb3e5fc, 0x0288d1, 0x03a9f4];
		_functions = [drawOne, drawTwo, drawThree, drawFour, drawFive];

		for (time in _times)
			new FlxTimer().start(time, timerCallback);

		_sprite = new Sprite();
		FlxG.stage.addChild(_sprite);
		_gfx = _sprite.graphics;

		_text = new TextField();
		_text.selectable = false;
		_text.embedFonts = true;
		var dtf = new TextFormat(FlxAssets.FONT_DEFAULT, 20, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		_text.defaultTextFormat = dtf;
		_text.text = "";
		FlxG.stage.addChild(_text);

		FlxG.sound.load(Paths.sound("flixel")).play();

		skipTxt = new FlxText(5, FlxG.height - 24, 0, 'Press ENTER to skip.', 12);
		skipTxt.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		skipTxt.borderSize = 1.5;
		skipTxt.scrollFactor.set();
		skipTxt.alpha = 0;
		add(skipTxt);

		FlxTween.tween(skipTxt, {alpha: 1}, 1);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
			onComplete(null);
		
		super.update(elapsed);
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

	function drawOne():Void
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

	function drawTwo():Void
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

	function drawThree():Void
	{
		_gfx.beginFill(0xb3e5fc);
		_gfx.moveTo(50, -50);
		_gfx.lineTo(25, -50);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(50, -25);
		_gfx.lineTo(50, -50);
		_gfx.endFill();
        _text.text += " Haxe";
	}

	function drawFour():Void
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

	function drawFive():Void
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
		FlxG.stage.removeChild(_sprite);
		FlxG.stage.removeChild(_text);
		FlxG.switchState(InitialState.new);
	}
}