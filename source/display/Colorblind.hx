package display;

import openfl.filters.ColorMatrixFilter;

class Colorblind {
    public static var colorBlindMode:Int = -1;
    public static function updateColorBlindFilter(type:Int = -1, intensity:Float = 1) {
        FlxG.game.setFilters([]);

        colorBlindMode = type;
        if (type == -1) return;

        var matrixThing:Array<Float> = [];
        switch (type) {
            case -1: // none
                matrixThing = [
                    1, 0, 0, 0, 0,
                    0, 1, 0, 0, 0,
                    0, 0, 1, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 0: // deuteranopia
                matrixThing = [
                    0.43, 0.72, -.15, 0, 0,
                    0.34, 0.57, 0.09, 0, 0,
                    -0.02, 0.03, 1, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 1: // protanopia
                matrixThing = [
                    0.2, 0.99, -0.19, 0, 0,
                    0.16, 0.79, 0.04, 0, 0,
                    0.01, -0.01, 1, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 2: // tritanopia
                matrixThing = [
                    0.97, 0.11, -0.08, 0, 0,
                    0.02, 0.82, 0.16, 0, 0,
                    0.06, 0.88, 0.18, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 3: // gameboy
                matrixThing = [
                    0, 0, 0, 0, 0,
                    0.33, 0.34, 0.33, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 4: // virtual boy
                matrixThing = [
                    0.34, 0.33, 0.33, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 5: // black and white
                matrixThing = [
                    0.33, 0.34, 0.33, 0, 0,
                    0.33, 0.34, 0.33, 0, 0,
                    0.33, 0.34, 0.33, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 6: // inverted
                matrixThing = [
                    0, 0.5, 0.5, 0, 0,
                    0.5, 0, 0.5, 0, 0,
                    0.5, 0.5, 0, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 7: // what even
                matrixThing = [
                    0.07, 0.9, 0.03, 0, 0,
                    0.25, 0, 0.75, 0, 0,
                    0, 0.33, 0.67, 0, 0,
                    0, 0, 0, 1, 0
                ];
            case 8: // random
                matrixThing = [
                    FlxG.random.float(0, 1), FlxG.random.float(0, 1), FlxG.random.float(0, 1), 0, 0,
                    FlxG.random.float(0, 1), FlxG.random.float(0, 1), FlxG.random.float(0, 1), 0, 0,
                    FlxG.random.float(0, 1), FlxG.random.float(0, 1), FlxG.random.float(0, 1), 0, 0,
                    0, 0, 0, 1, 0
                ];
        }

        inline function checkRange(val:Int, low:Int, high:Int)
            return (val >= low && val <= high);
        
        for (i in 0...matrixThing.length) {
            if (i % 5 == 4) continue;
            if (i > 14) break;
            if (matrixThing[i] == 0) matrixThing[i] = 0.00001;
            if ((i % 5 == 0 && checkRange(i, 0, 4)) || (i % 5 == 1 && checkRange(i, 5, 9)) || (i % 5 == 2 && checkRange(i, 10, 14))) {
                matrixThing[i] = FlxMath.lerp(matrixThing[i], 1, CoolUtil.boundTo(1 - intensity, 0, 1));
                continue;
            }
            matrixThing[i] = FlxMath.lerp(matrixThing[i], 0, CoolUtil.boundTo(1 - intensity, 0, 1));
        }

        var filter = new ColorMatrixFilter(matrixThing);
        if (filter == null) return;

        FlxG.game.setFilters([filter]);
    }
}