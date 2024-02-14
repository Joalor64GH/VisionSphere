package states.chat;

import states.chat.ChatLogs;
import states.chat.MsgGroup;
import states.chat.Message;

import flixel.addons.ui.FlxInputText;

class ChatState extends FlxState
{
    private var mess:MsgGroup;
    private var input:FlxInputText;

    override public function create()
    {
        mess = new MsgGroup(25, FlxG.height - 70);
        add(mess);

        input = new FlxInputText(25, FlxG.height - 55, 300);
        input.height *= 2;
        add(input);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
            FlxG.switchState(new MenuState());

        if (input.hasFocus && Input.is('accept'))
        {
            mess.addMessage(new Message(8, 0, "you", input.text, FlxColor.WHITE, true));

            input.text = "";
            input.caretIndex = 0;
        }

        if (FlxG.random.bool(3.5))
        {
            var curChat:Int = FlxG.random.weightedPick([70, 4, 70]);
            var curUser:String = ChatLogs.users[FlxG.random.int(0, ChatLogs.users.length)];
            var theMessage:String = ChatLogs.chat[curChat][FlxG.random.int(0, ChatLogs.chat[curChat].length)];

            mess.addMessage(new Message(8, 0, curUser, theMessage, FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)), true));
        }
    }
}