package states.unused.chat;

import states.unused.chat.Message;
import flixel.group.FlxSpriteGroup;

class MsgGroup extends FlxSpriteGroup
{
    private var messages:FlxTypedSpriteGroup<Message>;
    public var offsetY:Float = 10;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        messages = new FlxTypedSpriteGroup<Message>();
        add(messages);
    }

    public function addMessage(msg:Message):Void
    {
        messages.add(msg);

        messages.forEachAlive((spr:FlxSprite) ->
        {
            spr.y -= msg.height + offsetY;
            if (!spr.isOnScreen())
                spr.kill();
        });

        refreshMessages();
    }

    private function refreshMessages():Void {}
}