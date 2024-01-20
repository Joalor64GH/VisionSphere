package states;

import flixel.addons.display.FlxBackdrop;

typedef Game = 
{
    var img:String;
    var desc:String;
    var title:String;
    var color:Int;
}

class PlayState extends FlxState
{
    var dvdLogo:FlxSprite;

    var colors = [
        [255, 255, 255],
        [128, 128, 128],
        [0, 128, 0],
        [0, 255, 0],
        [255, 255, 0],
        [255, 165, 0],
        [255, 0, 0],
        [128, 0, 128],
        [0, 0, 255],
        [139, 69, 19],
        [255, 192, 203],
        [255, 0, 255],
        [0, 255, 255]
    ];

    var curColor:Int = 0;

    var games:Array<Game> = [];

    override public function create()
    {
        var text:FlxText = new FlxText(0, 0, 0, "Built-in games soon!", 64);
        text.screenCenter();
        add(text);

        dvdLogo = new FlxSprite(0, 0).loadGraphic(Paths.image('dvd'));
        dvdLogo.setGraphicSize(200, 5);
        dvdLogo.scale.y = dvdLogo.scale.x;
        dvdLogo.updateHitbox();
        dvdLogo.velocity.set(135, 95);
        dvdLogo.setColorTransform(0, 0, 0, 1, 255, 255, 255);
        add(dvdLogo);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) 
        {
            FlxG.switchState(new states.MenuState());
            FlxG.sound.play(Paths.sound('cancel'));
        }
        
        if (dvdLogo.x > FlxG.width - dvdLogo.width || dvdLogo.x < 0)
        {
            dvdLogo.velocity.x = -dvdLogo.velocity.x;
            switchColor();
        }

        if (dvdLogo.y > FlxG.height - dvdLogo.height || dvdLogo.y < 0)
        {
            dvdLogo.velocity.y = -dvdLogo.velocity.y;
            switchColor();
        }
    }

    private function switchColor()
    {
        curColor = (curColor + 1) % colors.length;
        dvdLogo.setColorTransform(0, 0, 0, 1, colors[curColor][0], colors[curColor][1], colors[curColor][2]);
    }
}