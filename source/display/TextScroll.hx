package display;

class TextScroll {
    var text:String;
    var letters:Array<FlxText> = [];
    var width:Int;
    var nextLetterIndex:Int = 0;
    var cc:Float = 0;

    public var onLoop:Void->Void;

    public function new(text:String, x:Int = 0, y:Int = 32, width:Int = 0) {
        super(x, y);

        this.text = text;
        this.width = (width == 0) ? FlxG.width - 1 : width;

        for (i in 0...Math.ceil(width / FlxText.fieldHeight) + 1)
            add(new FlxText(0, 0, 0, '')).exists = false;

        updateDisplay(x, y);
    }

    function fireNextLetter():Void {
        var l = letters[nextLetterIndex % letters.length];
        l.ID = l.x = nextLetterIndex % text.length;
        l.exists = true;
        l.text = text.charAt(l.ID);
        l.y = letters[0].y + Math.cos((2 * Math.PI) / width * (l.x - letters[0].x) - cc) * 16;
        nextLetterIndex++;
    }

    private function onLetterExit(l:FlxText):Void {
        l.exists = false;
    }

    private function resetLetters():Void {
        for (l in letters)
            l.exists = false;
    }

    private function updateDisplay(x:Int, y:Int):Void
    {
        for (l in letters) {
            l.x -= 1;
            l.y = y + Math.cos((2 * Math.PI) / width * (l.x - x) - cc) * 16;

            if (l.x < x - FlxText.fieldWidth)
                onLetterExit(l);
        }

        if (letters[0].x < (x + width - FlxText.fieldWidth))
            fireNextLetter();
        else if (letters[letters.length - 1].ID == text.length - 1 && onLoop != null) {
            onLoop();
            resetLetters();
        }
    }

    public function update(elapsed:Float):Void {
        super.update(elapsed);

        cc += 0.02;
        updateDisplay(0, 32);
    }
}