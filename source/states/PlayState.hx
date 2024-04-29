package states;

import flixel.addons.display.FlxBackdrop;

typedef Game = {
    var img:String;
    var desc:String;
    var title:String;
}

class GameThumbnail extends FlxSprite
{
    public var lerpSpeed:Float = 6;
    public var posX:Float = 0;

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        x = FlxMath.lerp(x, (FlxG.width - width) / 2 + posX * 760, CoolUtil.boundTo(elapsed * lerpSpeed, 0, 1));
    }
}

class PlayState extends FlxState
{
    var currentIndex:Int = 0;
    var itemGrp:FlxTypedGroup<GameThumbnail>;

    var paths:Array<String> = [];
    var descs:Array<String> = [];
    var titles:Array<String> = [];

    var titleTxt:FlxText;
    var descTxt:FlxText;

    var checker:FlxBackdrop = new FlxBackdrop(Paths.image('game/grid') #if (flixel_addons < "3.0.0"), 0.2, 0.2, true, true #end);

    override public function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/'${SaveData.settings.get("theme")}));
        add(bg);

        checker.scrollFactor.set(0.07, 0);
        add(checker);

        var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('game/bars'));
        add(bars);

        var games:Array<Game> = [
            {img: "2048", desc: "2048, but if it was a clicker game!", title: "2048 Clicker"},
            {img: "dvd", desc: "No further explanation needed.", title: "DVD Screensaver"},
            {img: "jta", desc: "The journey ever!", title: "Journey Through Aubekhia"},
            {img: "painter", desc: "Let out your inner Picasso!", title: "Painter"},
            {img: "math", desc: "An endless math problem game!", title: "The Simple Math Game"},
            {img: "teturisu", desc: "It's tetris in Haxeflixel lol.", title: "Teturisu"},
            {img: "reaction", desc: "Can you click the right square?", title: "The Reaction Game"},
            {img: "blank", desc: "New phone, who dis?", title: "The Phone"}
        ];

        for (data in games)
        {
            paths.push(data.img);
            descs.push(data.desc);
            titles.push(data.title);
        }

        itemGrp = new FlxTypedGroup<GameThumbnail>();
        add(itemGrp);

        for (i in 0...paths.length)
        {
            var newItem:GameThumbnail = new GameThumbnail();
            newItem.loadGraphic(Paths.image('game/thumbnails/' + paths[i]));
            newItem.scale.set(0.6, 0.6);
            newItem.ID = i;
            itemGrp.add(newItem);
        }

        descTxt = new FlxText(50, -100, FlxG.width - 100, descs[currentIndex]);
        descTxt.setFormat(Paths.font('vcr.ttf'), 25, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        descTxt.y += 250;
        add(descTxt);

        titleTxt = new FlxText(50, 50, FlxG.width - 100, titles[currentIndex]);
        titleTxt.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        titleTxt.screenCenter(X);
        add(titleTxt);

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        checker.x -= 0.45;
        checker.y -= 0.16;

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var left = Input.is('left') || (gamepad != null ? Input.gamepadIs('gamepad_left') : false);
        var right = Input.is('right') || (gamepad != null ? Input.gamepadIs('gamepad_right') : false);
        var accept = Input.is('accept') || (gamepad != null ? Input.gamepadIs('gamepad_accept') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (exit) 
        {
            FlxG.switchState(MenuState.new);
            FlxG.sound.play(Paths.sound('cancel'));
        }

        if (left || right)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(left ? -1 : 1);
        }

        if (accept)
        {
            FlxG.sound.play(Paths.sound('confirm'));
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> 
            {
                switch (currentIndex)
                {
                    case 0:
                        FlxG.switchState(new states.games.clicker.MainMenuState());
                    case 1:
                        FlxG.switchState(new states.games.DVDScreensaver());
                    case 2:
                        FlxG.switchState(new states.games.jta.MainMenuState());
                    case 3:
                        FlxG.switchState(new states.games.Painter());
                    case 4:
                        FlxG.switchState(new states.games.TheSimpleMathGame.MainMenuState());
                    case 5:
                        FlxG.switchState(new states.games.tetris.MainMenuState());
                    case 6:
                        FlxG.switchState(new states.games.ReactionGame());
                    case 7:
                        FlxG.switchState(new states.games.Phone());
                }
            });
        }
    }

    private function changeSelection(i:Int = 0)
    {
        currentIndex = FlxMath.wrap(currentIndex + i, 0, titles.length - 1);

        descTxt.text = descs[currentIndex];
        titleTxt.text = titles[currentIndex];

        for (num => item in itemGrp)
        {
            item.posX = num++ - currentIndex;
            item.alpha = (item.ID == currentIndex) ? 1 : 0.6;
        }
    }
}