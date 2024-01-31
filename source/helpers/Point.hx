package helpers;

import flixel.math.FlxPoint;

class Point
{
    public var x:Float = 0.0;
    public var y:Float = 0.0;

    public function new(x:Float = 0.0, y:Float = 0.0)
    {
        this.x = x;
        this.y = y;
    }

    public function set(?x:Float, ?y:Float)
    {
        if (x != null)
            this.x = x;
        if (y != null)
            this.y = y;
    }

    public static inline function fromFlxPoint(point:FlxPoint) {
        return new Point(point.x, point.y);
    }

    public inline static function getInterpolationFunction(enumValue:Interpolation) {
        return switch enumValue {
            case Linear:
                function(a:Float, b:Float, t:Float):Float {
                    return a + (b - a) * Math.min(t, 1);
                }
            case Bilinear:
                function(a:Float, b:Float, t:Float):Float
                {
                    var a = a * (1 - t) + b * t;
                    var b = a * (1 - t) + b * t;
                    return a * (1 - t) + b * t;
                }
        }
    }
}

enum Interpolation {
    Linear;
    Bilinear;
}