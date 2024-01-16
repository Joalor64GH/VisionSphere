package states.substates;

import flixel.ui.FlxButton;

class PromptSubState extends FlxSubState
{
    public var question:String;
    public var callbackYes:Void->Void;
    public var callbackNo:Void->Void;

    public function new(question:String, callbackYes:Void->Void, callbackNo:Void->Void)
    {
        super();

        this.question = question;
        this.callbackYes = callbackYes;
        this.callbackNo = callbackNo;

        var width:Float = FlxG.width * 0.75;
        var height:Float = FlxG.height * 0.5;
        var box:FlxSprite = new FlxSprite().makeGraphic(width, height, 0xFF000000);
        box.screenCenter(XY);
        add(box);

        var questionTxt:FlxText = new FlxText(box.x, box.y + 20, box.width, question);
        questionTxt.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(questionTxt);

        var btnYes:FlxButton = new FlxButton(box.x + 20, box.y + height - 50, "Yes", callbackYes);
        add(btnYes);

        var btnNo:FlxButton = new FlxButton(box.x + box.width - 100, box.y + height - 50, "No", callbackNo);
        add(btnNo);
    }
}