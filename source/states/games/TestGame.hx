package states.games;

import flixel.tile.FlxTilemap;

class TestGame extends FlxState
{
    var tileSize:Int = 32;
    var numRows:Int = 10;
    var numCols:Int = 10;
    var tilemap:FlxTilemap;

    override public function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        generateTilemap();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Input.is('up'))
            tilemap.y -= tileSize;
        if (Input.is('down'))
            tilemap.y += tileSize;
        if (Input.is('left'))
            tilemap.x -= tileSize;
        if (Input.is('right'))
            tilemap.x += tileSize;

        if (Input.is('exit')) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }

        if (Input.is('r'))
            generateTilemap();
    }

    private function generateTilemap()
    {
        tilemap = new FlxTilemap();
        var tiles:Array<Array<Int>> = [];

        for (i in 0...numRows)
        {
            tiles[i] = [];
            for (j in 0...numCols)
                tiles[i][j] = Math.floor(Math.random() * 0xFFFFFF);
        }

        tilemap.loadMapFromArray(tiles, tileSize, tileSize, FlxTilemap.AUTO, 0, 1, 1, numCols * tileSize, numRows * tileSize);

        add(tilemap);
    }
}