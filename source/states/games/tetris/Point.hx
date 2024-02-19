package states.games.tetris;

class Point {
    public var row:Int;
    public var column:Int;

    public function new(r:Int, c:Int) {
        row = r;
        column = c;
    }

    public function clone() {
        return new Point(row, column);
    }
}