package states.games.rhythmo;

import flixel.util.FlxStringUtil;

using StringTools;

class ChartParser
{
    static public function parse(songName:String, section:Int):Array<Dynamic>
    {
        var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");

        var csvData = FlxStringUtil.imageToCSV(Paths.file('data/rhythmo/$songName/$songName_section$section.png'));

        var lines:Array<String> = regex.split(csvData);
        var rows:Array<String> = lines.filter((line) -> return line != "");
        csvData.replace("\n", ',');

        var heightInTiles = rows.length;
        var widthInTiles = 0;

        var row:Int = 0;

        var daArray:Array<Int> = [];
        while (row < heightInTiles)
        {
            var rowString = rows[row];
            if (rowString.endsWith(","))
                rowString = rowString.substr(0, rowString.length - 1);
            
            var columns = rowString.split(",");
            if (columns.length == 0)
            {
                heightInTiles--;
                continue;
            }

            if (widthInTiles == 0)
                widthInTiles = columns.length;

            var column = 0;
            var pushedInColumn:Bool = false;
            while (column < widthInTiles)
            {
                var columnString = columns[column];
                var curTile = Std.parseInt(columnString);
                if (curTile == null)
                    throw 'String in row $row, column $column is not a valid integer: "$columnString"';
                
                if (curTile == 1)
                {
                    if (column < 4)
                        daArray.push(column + 1);
                    else
                    {
                        var tempCol = (column + 1) * -1;
                        tempCol += 4;
                        daArray.push(tempCol);
                    }

                    pushedInColumn = true;
                }

                column++;
            }

            if (!pushedInColumn)
                daArray.push(0);

            row++;
        }
        return daArray;
    }
}