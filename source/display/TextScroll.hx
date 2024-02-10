package display;

import flixel.group.FlxGroup;

class TextScroll extends FlxGroup<FlxText> {
    var text:String;
    var letterWidth:Int;
    var nextLetterIndex:Int;
    var maxLetters:Int;
    var PiStep:Float;
    var lastLetter:FlxText;
    var cc:Float = 0;

    public var onLoop:Void->Void;

    public function new(text:String, x:Int = 0, y:Int = 32, width:Int = 0, speed:Int = 1, loopMode:Int = 1) {
        super(x, y);

        this.text = text;
        width = (width == 0) ? FlxG.width - 1 : width;

        maxLetters = Math.ceil(width / FlxText.fieldHeight) + 1;

        letterWidth = FlxText.fieldWidth;
        nextLetterIndex = 0;
        PiStep = (2 * Math.PI) / width;

        for (i in 0...maxLetters)
            add(new FlxText(0, 0, 0, '')).exists = false;

        fireNextLetter();
    }

    function fireNextLetter():Void {
        if (nextLetterIndex == text.length) {
            if (lastLetter != null && lastLetter.ID == text.length - 1 && onLoop) {
                if (onLoop != null) {
                    onLoop();
                    resetLetters();
                }
            }
            nextLetterIndex = 0;
        }

        var l = getFirstAvailable(FlxText);
        l.ID = nextLetterIndex;
        l.exists = true;
        l.text = text.charAt(l.ID);
        l.x = x + width;
        l.y = y + Math.cos(PiStep * (l.x - x)) * 16;
        lastLetter = l;
        nextLetterIndex++;
    }

    private function onLetterExit(l:FlxText):Void {
        l.exists = false;
    }

    private function resetLetters() {
        forEach((l:FlxText) -> l.exists = false);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        cc += 0.02;

        forEachExists((l:FlxText) -> {
            l.x -= 1;
            l.y = y + Math.cos(PiStep * (l.x - x) - cc) * 16;

            if (l.x < x - letterWidth)
                onLetterExit(l);
        });

        if (lastLetter != null && lastLetter.x < (x + width - letterWidth))
            fireNextLetter();
    }
}