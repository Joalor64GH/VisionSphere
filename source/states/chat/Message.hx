package states.chat;

import flixel.group.FlxSpriteGroup;

class Message extends FlxSpriteGroup
{
    var daMessage:FlxText;
    var username:FlxText;

    public function new(x:Float = 0, y:Float = 0, userName:String = "user", message:String, "test message", textColor:FlxColor, ?isMod:Bool = false)
    {
        super(x, y);

        var modBadge:FlxSprite = new FlxSprite().makeGraphic((isMod) ? 15, 15, FlxColor.GREEN : 1, 1, FlxColor.TRANSPARENT);
        add(modBadge);

        username = new FlxText(modBadge.width + 5, 0, 0, userName, 14);
        username.color = textColor;
        username.font = Paths.font('vcr.ttf');
        add(username);

        daMessage = new FlxText(username.x + username.width - 3, 0, 0, ": " + message, 14);
        daMessage.font = Paths.font('vcr.ttf');
        add(daMessage);
    }
}