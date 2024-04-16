package states.unused.chat;

import states.unused.chat.ChatLogs;
import states.unused.chat.MsgGroup;
import states.unused.chat.Message;

import flixel.addons.ui.FlxInputText;

class ChatState extends FlxState // this is broken and idk why
{
    private var mess:MsgGroup;
    private var txtInput:FlxInputText;

    override public function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/${SaveData.getData('theme')}'));
        add(bg);
        
        mess = new MsgGroup(25, FlxG.height - 70);
        add(mess);

        txtInput = new FlxInputText(25, FlxG.height - 55, 300);
        txtInput.height *= 2;
        add(txtInput);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('exit'))
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.switchState(MenuState.new);
        }

        if (txtInput.hasFocus && Input.is('accept'))
        {
            mess.addMessage(new Message(8, 0, "you", txtInput.text, FlxColor.WHITE, true));

            txtInput.text = "";
            txtInput.caretIndex = 0;
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