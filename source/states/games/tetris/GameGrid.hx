package states.games.tetris;

import flixel.group.FlxSpriteGroup;
import states.games.tetris.Point;

class GameGrid
{
    public static var rows:Int = 22;
    public static var columns:Int = 10;

    public static var grid:Array<Array<Int>> = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ];

    public static function get(r:Int, c:Int) 
    {
        if (!isValid(r, c))
            return null;

        return grid[r][c];
    }

    public static function set(r:Int, c:Int, value:Int) 
    {
        if (!isValid(r, c))
            return null;

        return grid[r][c] = value;
    }

    public static function isEmpty(r:Int, c:Int) {
        return isValid(r, c) && grid[r][c] == 0;
    }

    public static function isValid(r:Int, c:Int) {
        return r >= 0 && r < rows && c >= 0 && c < columns;
    }

    public static function isRowFull(r:Int) 
    {
        for (c in 0...columns) {
            if (grid[r][c] == 0)
                return false;
        }

        return true;
    }

    public static function isRowEmpty(r: Int) 
    {
        for (c in 0...columns) 
        {
            if (grid[r][c] != 0)
                return false;
        }

        return true;
    }

    public static function clear() 
    {
        grid = [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ];
    }

    public static function clearRows() 
    {
        var cleared = 0;

        var r = rows - 1;
        while (r >= 0) {
            if (isRowFull(r)) {
                for (c in 0...columns)
                    grid[r][c] = 0;
                cleared++;
            } else if (cleared > 0) {
                for (c in 0...columns) {
                    grid[r + cleared][c] = grid[r][c];
                    grid[r][c] = 0;
                }
            }

            r--;
        }

        return cleared;
    }
}

class Sprites extends FlxSpriteGroup 
{
    public static var hiddenRows:Int = 2;
    public static var cellSize:Int = 36;
    public static var outlineWidth:Int = 2;

    public static var blockColors:Array<Int> = [
        0xFF000000,
        0xFF00FFFF,
        0xFF0000FF,
        0xFFFFA500,
        0xFFFFFF00,
        0xFF00FF00,
        0xFF800080,
        0xFFFF0000
    ];

    public function new(x:Float = 0, y:Float = 0) 
    {
        super(x, y);

        updateSprites();
    }

    public function updateSprites() {
        clear();

        // unfinished lmao
    }
}