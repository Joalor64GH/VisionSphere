package states;

class AccountState extends FlxState
{
    var usernameTxt:FlxText;
    var profileSpr:FlxSprite;
    var icons:Array<FlxSprite> = [];
    var profiles:Array<String> = ['red', 'orange', 'yellow', 'green', 'blue', 'purple', 'pink'];
    
    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        for (i in 0...profiles.length)
        {
            var icon:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/profile/' + profiles[i]));
            icon.screenCenter();
            icon.x += ((FlxG.width * 0.4) * (i % 2 == 0 ? -1 : 1)) + FlxG.random.float(-100, 100);
            icon.y = FlxG.height + 120;
            icon.alpha = 0.6;
            icon.velocity.y = FlxG.random.int(-40, -110);
            icon.visible = false;
            icon.scale.set(0.8, 0.8);
            icon.ID = i;
            icons.push(icon);
            add(icon);
        }

        for (icon in icons)
        {
            icon.y = FlxG.height + 120;
            icon.visible = true;
        }

        profileSpr = new FlxSprite(0, 50).loadGraphic(Paths.image('menu/profile/' + SaveData.profile));
        profileSpr.screenCenter(X);
        profileSpr.scale.set(2, 32);
        add(profileSpr);

        usernameTxt = new FlxText(0, profileSpr.y + 530, 0, SaveData.username, 12);
        usernameTxt.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        usernameTxt.screenCenter(X);
        add(usernameTxt);

        var daText:FlxText = new FlxText(5, FlxG.height - 24, 0, "Press LEFT/RIGHT to change your profile.", 12);
        daText.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(daText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        for (icon in icons)
        {
            icon.angle += elapsed * 12;
            if (icon.y > -160) continue;
            icon.screenCenter();
            icon.x += ((FlxG.width * 0.4) * (icon.ID % 2 == 0 ? -1 : 1)) + FlxG.random.float(-100, 100);
            icon.y = FlxG.height + FlxG.random.int(60, 120);
            icon.velocity.y = FlxG.random.int(-40, -110);
            icon.angle = FlxG.random.float(0, 360);
            icon.loadGraphic(profiles[FlxG.random.int(0, profiles.length - 1)]);
            if (icon.y > FlxG.height)
                FlxTween.tween(icon, {alpha: 0}, 1, {ease: FlxEase.quadOut});
        }

        if (FlxG.mouse.overlaps(usernameTxt) && FlxG.mouse.pressed)
        {
            openSubState(new states.substates.AccountNameSubState());
            FlxG.sound.play(Paths.sound('scroll'));
        }

        if (Input.is('right') || Input.is('left'))
            switchProfile(Input.is('right') ? 1 : -1);

        if (Input.is('exit')) 
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }

    private function switchProfile(direction:Int = 0)
    {
        var currentProfileIndex:Int = profiles.indexOf(SaveData.profile);
        var newProfileIndex:Int = (currentProfileIndex + direction) % profiles.length;
        if (newProfileIndex < 0)
            newProfileIndex += profiles.length;

        SaveData.profile = profiles[newProfileIndex];

        profileSpr.loadGraphic(Paths.image('menu/profile/' + SaveData.profile));
    }
}