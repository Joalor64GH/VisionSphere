package states.substates;

/**
 * @author khuonghoanghuy
 * @see https://github.com/khuonghoanghuy/FNF-Pop-Engine-Rewrite/
 */

class ControlsSubState extends FlxSubState {
	var init:Int = 0;
	var inChange:Bool = false;
	var keyboardMode:Bool = true;
	var controllerSpr:FlxSprite;
	var text1:FlxText;
	var text2:FlxText;

	var kbBinds:Array<FlxKey> = [];
	var gpBinds:Array<FlxGamepadInputID> = [];
	var binds:FlxSpriteGroup;

	public function new() {
		super();

		for (i in 0...6) {
			kbBinds.push(SaveData.settings.keyboardBinds[i]);
			gpBinds.push(SaveData.settings.gamepadBinds[i]);
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		bg.alpha = 0.65;
		add(bg);

		var title:FlxSprite = new FlxSprite();
		title.frames = Paths.getSparrowAtlas('menu/controls/title');
		title.animation.addByPrefix('idle', 'Controls', 12);
		title.animation.play('idle');
		title.screenCenter(X);
		add(title);

		controllerSpr = new FlxSprite(50, 40).loadGraphic(Paths.image('menu/controls/controllertype'), true, 82, 60);
		controllerSpr.animation.add('keyboard', [0], 1, false);
		controllerSpr.animation.add('gamepad', [1], 1, false);
		add(controllerSpr);

		var instructionsTxt:FlxText = new FlxText(5, FlxG.height - 24, 0, "Press LEFT/RIGHT to scroll through keys.", 12);
		instructionsTxt.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		instructionsTxt.screenCenter(X);
		add(instructionsTxt);

		text1 = new FlxText(0, 0, 0, "", 64);
		text1.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text1);

		text2 = new FlxText(5, FlxG.height - 54, 0, "", 32);
		text2.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text2);

		binds = new FlxSpriteGroup();
		add(binds);

		for (bind in kbBinds) {
			var key = new KeyIcon(text1.x, text1.y + 150, bind);
			key.x -= key.iconWidth * 3;
			key.screenCenter(X);
			binds.add(key);
		}

		for (bind in gpBinds) {
			var control = new ControllerIcon(text1.x, text1.y + 250, bind);
			control.x -= control.iconWidth * 3;
			control.screenCenter(X);
			binds.add(control);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		text1.screenCenter(XY);
		text2.screenCenter(X);

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		controllerSpr.animation.play(keyboardMode ? 'keyboard' : 'gamepad');
		if (FlxG.mouse.overlaps(controllerSpr)) {
			if (FlxG.mouse.justPressed) {
				keyboardMode = !keyboardMode;
				if (gamepad != null)
					FlxG.sound.play(Paths.sound('confirm'));
				else if (gamepad == null) {
					keyboardMode = true;
					FlxG.sound.play(Paths.sound('cancel'));
					Main.toast.create("Can't do that.", 0xFFFFFF00, "Connect a controller to edit your gamepad controls.");
				}
			}
		}

		if (keyboardMode) {
			if ((Input.is('exit') || Input.is('backspace')) && !inChange)
				close();

			if (Input.is('accept')) {
				inChange = true;
				text2.text = "PRESS ANY KEY TO CONTINUE";
			}

			if (Input.is('left') && !inChange) {
				FlxG.sound.play(Paths.sound('scroll'));
				(init == 0) ? init = 5 : init--;
			}

			if (Input.is('right') && !inChange) {
				FlxG.sound.play(Paths.sound('scroll'));
				(init == 5) ? init = 0 : init++;
			}

			switch (init) {
				case 0:
					text1.text = "LEFT KEY: " + SaveData.settings.keyboardBinds[0].toString();
				case 1:
					text1.text = "DOWN KEY: " + SaveData.settings.keyboardBinds[1].toString();
				case 2:
					text1.text = "UP KEY: " + SaveData.settings.keyboardBinds[2].toString();
				case 3:
					text1.text = "RIGHT KEY: " + SaveData.settings.keyboardBinds[3].toString();
				case 4:
					text1.text = "ACCEPT KEY: " + SaveData.settings.keyboardBinds[4].toString();
				case 5:
					text1.text = "EXIT KEY: " + SaveData.settings.keyboardBinds[5].toString();
			}

			if (inChange) {
				if (!Input.is('accept') && !Input.is('exit') && Input.is('any')) {
					switch (init) {
						case 0:
							SaveData.settings.keyboardBinds[0] = FlxG.keys.getIsDown()[0].ID.toString();
							Input.actionMap.set("left", SaveData.settings.keyboardBinds[0]);
						case 1:
							SaveData.settings.keyboardBinds[1] = FlxG.keys.getIsDown()[0].ID.toString();
							Input.actionMap.set("down", SaveData.settings.keyboardBinds[1]);
						case 2:
							SaveData.settings.keyboardBinds[2] = FlxG.keys.getIsDown()[0].ID.toString();
							Input.actionMap.set("up", SaveData.settings.keyboardBinds[2]);
						case 3:
							SaveData.settings.keyboardBinds[3] = FlxG.keys.getIsDown()[0].ID.toString();
							Input.actionMap.set("right", SaveData.settings.keyboardBinds[3]);
						case 4:
							SaveData.settings.keyboardBinds[4] = FlxG.keys.getIsDown()[0].ID.toString();
							Input.actionMap.set("accept", SaveData.settings.keyboardBinds[4]);
						case 5:
							SaveData.settings.keyboardBinds[5] = FlxG.keys.getIsDown()[0].ID.toString();
							Input.actionMap.set("exit", SaveData.settings.keyboardBinds[5]);
					}
					refreshControls();
					FlxG.sound.play(Paths.sound('scroll'));
					text2.text = "";
					inChange = false;
				}
			}
		} else if (!keyboardMode) {
			if (gamepad != null) {
				if (Input.gamepadIs('gamepad_exit') || Input.gamepadIs('x') && !inChange)
					close();

				if (Input.gamepadIs('gamepad_accept')) {
					inChange = true;
					text2.text = "PRESS ANY KEY TO CONTINUE";
				}

				if (Input.gamepadIs('gamepad_left') && !inChange) {
					FlxG.sound.play(Paths.sound('scroll'));
					(init == 0) ? init = 5 : init--;
				}

				if (Input.gamepadIs('gamepad_right') && !inChange) {
					FlxG.sound.play(Paths.sound('scroll'));
					(init == 5) ? init = 0 : init++;
				}

				switch (init) {
					case 0:
						text1.text = "LEFT KEY: " + SaveData.settings.gamepadBinds[0].toString();
					case 1:
						text1.text = "DOWN KEY: " + SaveData.settings.gamepadBinds[1].toString();
					case 2:
						text1.text = "UP KEY: " + SaveData.settings.gamepadBinds[2].toString();
					case 3:
						text1.text = "RIGHT KEY: " + SaveData.settings.gamepadBinds[3].toString();
					case 4:
						text1.text = "ACCEPT KEY: " + SaveData.settings.gamepadBinds[4].toString();
					case 5:
						text1.text = "EXIT KEY: " + SaveData.settings.gamepadBinds[5].toString();
				}

				if (inChange) {
					var keyPressed:FlxGamepadInputID = gamepad.firstJustPressedID();
					if (!Input.gamepadIs('gamepad_accept') && !Input.gamepadIs('gamepad_exit') && gamepad.anyJustPressed([ANY])
						&& keyPressed.toString() != NONE) {
						switch (init) {
							case 0:
								SaveData.settings.gamepadBinds[0] = keyPressed;
								Input.controllerMap.set("gamepad_left", SaveData.settings.gamepadBinds[0]);
							case 1:
								SaveData.settings.gamepadBinds[1] = keyPressed;
								Input.controllerMap.set("gamepad_down", SaveData.settings.gamepadBinds[1]);
							case 2:
								SaveData.settings.gamepadBinds[2] = keyPressed;
								Input.controllerMap.set("gamepad_up", SaveData.settings.gamepadBinds[2]);
							case 3:
								SaveData.settings.gamepadBinds[3] = keyPressed;
								Input.controllerMap.set("gamepad_right", SaveData.settings.gamepadBinds[3]);
							case 4:
								SaveData.settings.gamepadBinds[4] = keyPressed;
								Input.controllerMap.set("gamepad_accept", SaveData.settings.gamepadBinds[4]);
							case 5:
								SaveData.settings.gamepadBinds[5] = keyPressed;
								Input.controllerMap.set("gamepad_exit", SaveData.settings.gamepadBinds[5]);
						}
						refreshControls();
						FlxG.sound.play(Paths.sound('scroll'));
						text2.text = "";
						inChange = false;
					}
				}
			}
		}
	}

	private function refreshControls() {
		kbBinds = [];
		gpBinds = [];

		for (i in 0...6) {
			kbBinds.push(SaveData.settings.keyboardBinds[i]);
			gpBinds.push(SaveData.settings.gamepadBinds[i]);
		}

		binds.forEachAlive((b) -> {
			remove(b);
			b.destroy();
		});

		for (bind in kbBinds) {
			var key = new KeyIcon(text1.x, text1.y + 150, bind);
			key.x -= key.iconWidth * 3;
			key.screenCenter(X);
			binds.add(key);
		}

		for (bind in gpBinds) {
			var control = new ControllerIcon(text1.x, text1.y + 250, bind);
			control.x -= control.iconWidth * 3;
			control.screenCenter(X);
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
					yOffset -= 10;
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

	public function new(_x:Float, _y:Float, _key:FlxGamepadInputID, ?_skin = "") {
		super(_x, _y);
		key = _key;
		skin = _skin;
		createGraphics();
	}

	function createGraphics() {
		var postfix:String = "0";
		if (xSkinKeys.contains(key) && skin == "XINPUT") postfix = "_x";
		if (psSkinKeys.contains(key) && skin == "PS4") postfix = "_ps";
		if (ninSkinKeys.contains(key) && skin == "SWITCH_PRO") postfix = "_nin";
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