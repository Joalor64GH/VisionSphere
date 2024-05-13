package frontend.objects;

import flixel.group.FlxGroup;

@:access(states.ControlsState)
class ControlsGroup extends FlxGroup {
    public var instance:ControlsState;

    var kbBinds:Array<FlxKey> = [];
	var gpBinds:Array<FlxGamepadInputID> = [];
	var binds:FlxSpriteGroup;

    public function new(instance:ControlsState) {
        super();
        this.instance = instance;

        binds = new FlxSpriteGroup();
        add(binds);

        refreshControls();
    }

    public static function refreshControls() {
		kbBinds = [];
		gpBinds = [];

		for (i in 0...6) {
			kbBinds.push(SaveData.settings.keyboardBinds[i]);
			gpBinds.push(SaveData.settings.gamepadBinds[i]);
		}

		kbBinds.reverse();
		gpBinds.reverse();

		binds.forEachAlive((b) -> {
			remove(b);
			b.destroy();
		});

        var bindPos = instance.text1.x + 1150 - 10;

		for (bind in kbBinds) {
			var key = new KeyIcon(bindPos, instance.text1.y + 150, bind);
			key.x -= key.iconWidth;
            bindPos -= key.iconWidth + 10;
			binds.add(key);
		}

		for (bind in gpBinds) {
			var control = new ControllerIcon(bindPos, instance.text1.y + 250, bind);
			control.x -= control.iconWidth;
            bindPos -= control.iconWidth + 10;
			binds.add(control);
		}
	}
}

/**
 * @author ThatRozebudDude
 * @see https://github.com/ThatRozebudDude/FPS-Plus-Public/
 */

class KeyIcon extends FlxSpriteGroup {
	static final customGraphicKeys:Array<FlxKey> = [
		ALT, BACKSPACE, BREAK, CAPSLOCK, CONTROL, DELETE, DOWN, END, ENTER, ESCAPE, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, GRAVEACCENT, HOME,
		INSERT, LEFT, MENU, NUMLOCK, PAGEUP, PAGEDOWN, PRINTSCREEN, RIGHT, SCROLL_LOCK, SHIFT, SPACE, TAB, UP, WINDOWS
	];

	public var key:FlxKey;

	public var iconWidth:Float = 80;
	public var iconHeight:Float = 80;

	public function new(_x:Float, _y:Float, _key:FlxKey) {
		super(_x, _y);
		key = _key;
		createGraphics();
	}

	function createGraphics() {
		if (customGraphicKeys.contains(key))
			loadKeyGraphic(key.toString().toLowerCase());
		else {
			var isKeypad:Bool = key.toString().contains("NUMPAD");
			var keyText:String = "";
			var yOffset:Float = -3;
			switch (key) {
				case BACKSLASH:
					keyText = "\\";
					yOffset += 3;
				case COMMA:
					keyText = ",";
				case LBRACKET:
					keyText = "[";
					yOffset += 4;
				case RBRACKET:
					keyText = "]";
					yOffset += 4;
				case QUOTE:
					keyText = "'";
				case SEMICOLON:
					keyText = ";";
					yOffset += 10;
				case PLUS:
					keyText = "=";
				case NUMPADPLUS:
					keyText = "+";
				case MINUS | NUMPADMINUS:
					keyText = "-";
				case NUMPADMULTIPLY:
					keyText = "*";
				case SLASH | NUMPADSLASH:
					keyText = "/";
					yOffset += 2;
				case PERIOD | NUMPADPERIOD:
					keyText = ".";
				case ZERO | NUMPADZERO:
					keyText = "0";
				case ONE | NUMPADONE:
					keyText = "1";
				case TWO | NUMPADTWO:
					keyText = "2";
				case THREE | NUMPADTHREE:
					keyText = "3";
				case FOUR | NUMPADFOUR:
					keyText = "4";
				case FIVE | NUMPADFIVE:
					keyText = "5";
				case SIX | NUMPADSIX:
					keyText = "6";
				case SEVEN | NUMPADSEVEN:
					keyText = "7";
				case EIGHT | NUMPADEIGHT:
					keyText = "8";
				case NINE | NUMPADNINE:
					keyText = "9";
				default:
					keyText = (key.toString().length == 1) ? key.toString() : "?";
			}
			generateDefaultKeyIcon(keyText, isKeypad, yOffset);
		}
	}

	function generateDefaultKeyIcon(text:String, isKeypad:Bool, yOffset:Float) {
		var keyBg = loadKeyGraphic("key" + (isKeypad ? "_kp" : "0"));

		var text = new FlxText(0, 0, 80, text, 80);
		text.setFormat(Paths.font("vcr.ttf"), 80, FlxColor.BLACK, FlxTextAlign.CENTER);
		text.y = (keyBg.height / 2) - (text.height / 2) + yOffset;
		text.text += "\n\n";
		add(text);
	}

	function loadKeyGraphic(frame:String):FlxSprite {
		var k = new FlxSprite(0, 0);
		k.frames = Paths.getSparrowAtlas("menu/controls/keyIcons");
		k.animation.addByPrefix("k", frame, 0, false);
		k.animation.play("k");
		add(k);

		iconWidth = Std.int(k.frameWidth / 10) * 10;
		iconHeight = Std.int(k.frameHeight / 10) * 10;

		return k;
	}
}

class ControllerIcon extends FlxSpriteGroup {
	static final psSkinKeys:Array<FlxGamepadInputID> = [
		A, B, X, Y, BACK, DPAD_DOWN, DPAD_LEFT, DPAD_UP, DPAD_RIGHT, LEFT_SHOULDER, LEFT_TRIGGER, RIGHT_SHOULDER, RIGHT_TRIGGER, LEFT_STICK_CLICK,
		RIGHT_STICK_CLICK, START, GUIDE
	];
	static final xSkinKeys:Array<FlxGamepadInputID> = [START, BACK, GUIDE];
	static final ninSkinKeys:Array<FlxGamepadInputID> = [
		A, B, X, Y, BACK, START, LEFT_SHOULDER, LEFT_TRIGGER, RIGHT_SHOULDER, RIGHT_TRIGGER, LEFT_STICK_CLICK, RIGHT_STICK_CLICK, EXTRA_0
	];

	public var key:FlxGamepadInputID;

	public var skin:String;

	public var iconWidth:Float = 80;
	public var iconHeight:Float = 80;

	public function new(_x:Float, _y:Float, _key:FlxGamepadInputID, ?_skin:String = "") {
		super(_x, _y);
		key = _key;
		skin = _skin;
		createGraphics();
	}

	function createGraphics() {
		var postfix:String = "0";
		if (xSkinKeys.contains(key) && skin == "x") postfix = "_x";
		if (psSkinKeys.contains(key) && skin == "ps") postfix = "_ps";
		if (ninSkinKeys.contains(key) && skin == "nin") postfix = "_nin";
		loadKeyGraphic(key.toString().toLowerCase() + postfix);
	}

	function loadKeyGraphic(frame:String):FlxSprite {
		var k = new FlxSprite(0, 0);
		k.frames = Paths.getSparrowAtlas("menu/controls/controllerIcons");
		k.animation.addByPrefix("k", frame, 0, false);
		k.animation.play("k");
		add(k);

		iconWidth = Std.int(k.frameWidth / 10) * 10;
		iconHeight = Std.int(k.frameHeight / 10) * 10;

		return k;
	}
}