package states;

import flixel.addons.ui.FlxUI9SliceSprite;

import flash.geom.Rectangle;

class AccountState extends FlxState
{
    var usernameTxt:FlxText;
    var profileSpr:FlxSprite;

    var profiles:Array<String> = ['red', 'orange', 'yellow', 'green', 'blue', 'purple', 'pink'];
    
    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        profileSpr = new FlxSprite(0, 50).loadGraphic(Paths.image('menu/profile/' + SaveData.profile));
        profileSpr.screenCenter(X);
        add(profileSpr);

        usernameTxt = new FlxText(0, profileSpr.y + 100, 0, SaveData.username, 12);
        usernameTxt.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        usernameTxt.screenCenter(X);
        add(usernameTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(usernameTxt) && FlxG.mouse.pressed) {}

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