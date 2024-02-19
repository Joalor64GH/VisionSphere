package states.games.tetris;

import states.games.tetris.Point;

class Piece
{
    public var id(default, null):Int;

    var offset:Point;
    var initialOffset:Point;
    var rotation:Int;
    var tiles:Array<Array<Point>>;

    public function new() {
        rotation = 0;
    }

    public function getTilePoints()
    {
        var points = [];
        for (i in tiles[rotation])
            points.push(new Point(i.row + offset.row, i.column + offset.column));
        return points;
    }

    public function rotateClockwise() {
        rotation = (rotation + 1) % tiles.length;
    }

    public function rotateCounterClockwise() {
        rotation = (rotation == 0 ? tiles.length : rotation) - 1;
    }

    public function move(r:Int, c:Int)
    {
        offset.row += r;
        offset.column += c;
    }

    public function reset()
    {
        rotation = 0;
        offset.row = initialOffset.row;
        offset.column = initialOffset.column;
    }
}

class I extends Piece {
    public function new() {
        super();

        id = 1;
        offset = new Point(-1, 3);
        initialOffset = offset.clone();
        tiles = [
            [new Point(1, 0), new Point(1, 1), new Point(1, 2), new Point(1, 3)],
            [new Point(0, 2), new Point(1, 2), new Point(2, 2), new Point(3, 2)],
            [new Point(2, 0), new Point(2, 1), new Point(2, 2), new Point(2, 3)],
            [new Point(0, 1), new Point(1, 1), new Point(2, 1), new Point(3, 1)]
        ];
    }
}

class J extends Piece {
    public function new() {
        super();

        id = 2;
        offset = new Point(0, 3);
        initialOffset = offset.clone();
        tiles = [
            [new Point(0, 0), new Point(1, 0), new Point(1, 1), new Point(1, 2)],
            [new Point(0, 1), new Point(0, 2), new Point(1, 1), new Point(2, 1)],
            [new Point(1, 0), new Point(1, 1), new Point(1, 2), new Point(2, 2)],
            [new Point(0, 1), new Point(1, 1), new Point(2, 0), new Point(2, 1)]
        ];
    }
}

class L extends Piece {
    public function new() {
        super();

        id = 3;
        offset = new Point(0, 3);
        initialOffset = offset.clone();
        tiles = [
            [new Point(0, 2), new Point(1, 0), new Point(1, 1), new Point(1, 2)],
            [new Point(0, 1), new Point(1, 1), new Point(2, 1), new Point(2, 2)],
            [new Point(1, 0), new Point(1, 1), new Point(1, 2), new Point(2, 0)],
            [new Point(0, 0), new Point(0, 1), new Point(1, 1), new Point(2, 1)]
        ];
    }
}

class O extends Piece {
    public function new() {
        super();

        id = 4;
        offset = new Point(0, 4);
        initialOffset = offset.clone();
        tiles = [
            [new Point(0, 0), new Point(0, 1), new Point(1, 0), new Point(1, 1)]
        ];
    }
}

class S extends Piece {
    public function new() {
        super();

        id = 5;
        offset = new Point(0, 3);
        initialOffset = offset.clone();
        tiles = [
            [new Point(0, 1), new Point(0, 2), new Point(1, 0), new Point(1, 1)],
            [new Point(0, 1), new Point(1, 1), new Point(1, 2), new Point(2, 2)],
            [new Point(1, 1), new Point(1, 2), new Point(2, 0), new Point(2, 1)],
            [new Point(0, 0), new Point(1, 0), new Point(1, 1), new Point(2, 1)]
        ];
    }
}

class T extends Piece {
    public function new() {
        super();

        id = 6;
        offset = new Point(0, 3);
        initialOffset = offset.clone();
        tiles = [
            [new Point(0, 2), new Point(1, 0), new Point(1, 1), new Point(1, 2)],
            [new Point(0, 1), new Point(1, 1), new Point(1, 2), new Point(2, 1)],
            [new Point(1, 0), new Point(1, 1), new Point(1, 2), new Point(2, 1)],
            [new Point(0, 1), new Point(1, 0), new Point(1, 1), new Point(2, 1)]
        ];
    }
}

class Z extends Piece {
    public function new() {
        super();

        id = 7;
        offset = new Point(0, 3);
        initialOffset = offset.clone();
        tiles = [
            [new Point(0, 0), new Point(0, 1), new Point(1, 1), new Point(1, 2)],
            [new Point(0, 2), new Point(1, 1), new Point(1, 2), new Point(2, 1)],
            [new Point(1, 0), new Point(1, 1), new Point(2, 1), new Point(2, 2)],
            [new Point(0, 1), new Point(1, 0), new Point(1, 1), new Point(2, 0)]
        ];
    }
}