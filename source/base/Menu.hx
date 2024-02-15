package base;

typedef MenuSelection = 
{
    id:Int,
    text:String
}

class Menu extends FlxSubState
{
    public static var title:String;
    public static var options:Array<String>;
    public static var includeExitBtn:Bool = true;
    public static var callback:MenuSelection->Void;
    public static var instance:Menu;

    public var cb:MenuSelection->Void;

    var ready:Bool = false;
    var cursor:FlxSprite;
    var uhhhh:Float = 1;
    var maxOptions:Int;
    var currentOption:Int = 0;
    var justPressedEnter:Bool;

    var optionsT = new FlxText(0, 0, 0, "placeholder", 32, true);
    var flashTimer:FlxTimer = null;

    public override function create()
    {
        openfl.system.System.gc();

        instance = this;

        cb = callback.bind(_);

        var titleT = new FlxText(20, 0, 0, title, 40, true);
        titleT.screenCenter(X);
        add(titleT);

        optionsT.alignment = CENTER;
        var tempString = "";
        for (option in options)
            tempString = tempString + option + "\n";
        
        if (includeExitBtn)
            tempString = tempString + "Exit Menu";

        optionsT.text = tempString;
        optionsT.screenCenter();
        add(optionsT);

        maxOptions = options.length - 1;

        cursor = new FlxSprite.loadGraphic(Paths.image('arrow'), false, 512, 512, false);
        cursor.setGraphicSize(45);
        cursor.updateHitbox();
        cursor.x = optionsT.x + optionsT.width;
        cursor.y = optionsT.y;
        add(cursor);

        trace('DEBUG SAYS:\nArrow Positions: [${cursor.x}, ${cursor.y}]\nCurrent Menu Options: [${options}]');

        ready = true;
    }

    
}