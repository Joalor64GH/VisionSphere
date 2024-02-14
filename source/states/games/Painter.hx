package states.games;

import flixel.FlxCamera;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
import flixel.addons.ui.FlxUISlider;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.JPEGEncoderOptions;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;

/*
 * @author CaptainBaldi
 * @see https://github.com/CaptainBaldi/HaxeFlixel-PixelPainter
 */

class Painter extends FlxState
{
    var camHUD:FlxCamera;
    var background:FlxSprite;
    var backgroundAlphaSlider:FlxUISlider;
    var colorWheel:FlxSprite;
    var selectedColor:FlxColor;
    var selectedColorVisualizer:FlxSprite;
    var enabled:Bool;
    var enableVisualizer:FlxSprite;
    var brushSize:Float;
    var brushSizeSlider:FlxUISlider;
    var saveJPEGButton:FlxButton;
    var savePNGButton:FlxButton;
    var pxGroup:FlxTypedGroup<FlxSprite>;

    override function create():Void
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;
        FlxG.cameras.add(camHUD, false);

        colorWheel = new FlxSprite(0, 0, Paths.image('game/painter/colorWheel'));
        colorWheel.camera = camHUD;
        colorWheel.scale.set(0.25, 0.25);
        colorWheel.updateHitbox();
        add(colorWheel);

        selectedColor = FlxColor.WHITE;

        selectedColorVisualizer = new FlxSprite().makeGraphic(30, 30);
        selectedColorVisualizer.camera = camHUD;
        selectedColorVisualizer.color = selectedColor;
        selectedColorVisualizer.setPosition(colorWheel.x + 100, colorWheel.y);
        add(selectedColorVisualizer);

        enabled = true;

        enableVisualizer = new FlxSprite().makeGraphic(30, 30);
        enableVisualizer.camera = camHUD;
        enableVisualizer.color = enabled ? FlxColor.LIME : FlxColor.RED;
        enableVisualizer.setPosition(selectedColorVisualizer.x + 45, selectedColorVisualizer.y);
        add(enableVisualizer);

        brushSize = 50;

        brushSizeSlider = new FlxUISlider(this, "brushSize", 0, 0, 0, 100, 100, 15, 3, FlxColor.WHITE, 0xFF828282);
        brushSizeSlider.camera = camHUD;
        brushSizeSlider.nameLabel.text = "Brush Size";
        brushSizeSlider.setPosition(colorWheel.x, colorWheel.y + 100);
        add(brushSizeSlider);

        saveJPEGButton = new FlxButton(0, 0, "Save to JPEG", function()
        {
            saveArt(true);
        });
        saveJPEGButton.camera = camHUD;
        saveJPEGButton.setPosition(10, (FlxG.height - saveJPEGButton.height) - 45);
        add(saveJPEGButton);

        savePNGButton = new FlxButton(0, 0, "Save to PNG", function()
        {
            saveArt();
        });
        savePNGButton.camera = camHUD;
        savePNGButton.setPosition(10, (saveJPEGButton.y + savePNGButton.height) + 10);
        add(savePNGButton);

        pxGroup = new FlxTypedGroup<FlxSprite>();
        add(pxGroup);

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (Input.is('accept'))
        {
            enabled = !enabled;

            enableVisualizer.color = enabled ? FlxColor.LIME : FlxColor.RED;
        }

        var isMouseOverUI:Bool = FlxG.mouse.overlaps(enableVisualizer, camHUD)
            || FlxG.mouse.overlaps(brushSizeSlider, camHUD)
            || FlxG.mouse.overlaps(saveJPEGButton, camHUD)
            || FlxG.mouse.overlaps(savePNGButton, camHUD);

        if (FlxG.mouse.pressed && !isMouseOverUI)
        {
            if (enabled)
            {
                var px:FlxSprite = new FlxSprite().makeGraphic(Std.int(brushSize), Std.int(brushSize), selectedColor);
                px.immovable = true;
                px.setPosition(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
                pxGroup.add(px);
            }
            else
            {
                for (px in pxGroup.members)
                {
                    if (FlxG.mouse.overlaps(px))
                    {
                        px.destroy();
                        pxGroup.members.remove(px);
                    }
                }
            }
        }

        if (FlxG.mouse.pressed && FlxG.mouse.overlaps(colorWheel, camHUD))
        {
            var mousePosition:FlxPoint = FlxPoint.get(FlxG.mouse.getWorldPosition(camHUD).x, FlxG.mouse.getWorldPosition(camHUD).y);

            var color:Null<FlxColor> = colorWheel.getPixelAtScreen(mousePosition, camHUD);

            if (color == FlxColor.TRANSPARENT)
                color = FlxColor.BLACK;

            selectedColor = color;

            selectedColorVisualizer.color = selectedColor;
        }

        for (px in pxGroup.members)
            px.alpha = FlxG.mouse.pressedRight ? 0.5 : 1;

        if (Input.is('r'))
            FlxG.resetState();
        else if (Input.is('exit')) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }

    function saveArt(?jpeg:Bool = false):Void
    {
        var bitmap:Bitmap = new Bitmap(BitmapData.fromImage(FlxG.stage.window.readPixels()));

        var bytes:ByteArray = bitmap.bitmapData.encode(bitmap.bitmapData.rect, jpeg ? new JPEGEncoderOptions() : new PNGEncoderOptions());

        if (!sys.FileSystem.exists("./art/"))
            sys.FileSystem.createDirectory("./art/");

        File.saveBytes("art/art_" + Date.now().toString().split(":").join("-") + (jpeg ? ".jpeg" : ".png"), bytes);
    }
}