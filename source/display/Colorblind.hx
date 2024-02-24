package display;

import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;

class Colorblind 
{
    public static var filters:Array<BitmapFilter> = [];

    public function new() 
    {
        if (filters.length > 0)
            FlxG.game.setFilters(filters);
    }

    public static var colorBlindFilters:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}> = [
        "Deuteranopia" => {
            var matrix:Array<Float> = [
                0.43, 0.72, -.15, 0, 0,
                0.34, 0.57, 0.09, 0, 0,
                -.02, 0.03,    1, 0, 0,
                   0,    0,    0, 1, 0,
            ];

            {filter: new ColorMatrixFilter(matrix)}
        },
        "Protanopia" => {
            var matrix:Array<Float> = [
                0.20, 0.99, -.19, 0, 0,
                0.16, 0.79, 0.04, 0, 0,
                0.01, -.01,    1, 0, 0,
                   0,    0,    0, 1, 0,
            ];

            {filter: new ColorMatrixFilter(matrix)}
        },
        "Tritanopia" => {
            var matrix:Array<Float> = [
                0.97, 0.11, -.08, 0, 0,
                0.02, 0.82, 0.16, 0, 0,
                0.06, 0.88, 0.18, 0, 0,
                   0,    0,    0, 1, 0,
            ];

            {filter: new ColorMatrixFilter(matrix)}
        }
    ];

    public static function updateFilter()
    {
        filters = [];
        FlxG.game.setFilters(filters);

        var curFilter = SaveData.colorBlindFilter;
        if (colorBlindFilters.get(curFilter) != null) {
            var daFilter = colorBlindFilters.get(curFilter).filter;

            if (daFilter != null)
                filters.push(daFilter);
        }

        FlxG.game.setFilters(filters);
    }
}