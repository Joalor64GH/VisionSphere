package states.games.tetris;

import states.games.tetris.Piece;

class PieceQueue
{
    public static var next:Piece;

    static var pieces:Array<Piece> = [
        new Piece.I(),
        new Piece.J(),
        new Piece.L(),
        new Piece.O(),
        new Piece.S(),
        new Piece.T(),
        new Piece.Z()
    ];

    public static function updatePiece() {
        next = pieces[Math.floor(Math.random() * pieces.length)];
    }

    public static function getAndUpdatePiece()
    {
        var piece = next;
        updatePiece();
        return piece;
    }
}