package states.substates;

import frontend.objects.AttachedText;
import frontend.objects.Checkbox;

import backend.data.Option;

/**
 * Based off of Psych Engine's options menu
 * @author ShadowMario
 */

class BaseOptionsMenu extends FlxSubState
{
    private var curOption:Option = null;
    private var curSelected:Int = 0;

    private var optionsArray:Array<Option>;
    private var grpOptions:FlxTypedGroup<Alphabet>;
    private var checkboxGroup:FlxTypedGroup<Checkbox>;
    private var grpTexts:FlxTypedGroup<AttachedText>;

    private var descBox:FlxSprite;
    private var descText:FlxText;

    public function new()
    {
        super();
        
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        grpTexts = new FlxTypedGroup<AttachedText>();
        add(grpTexts);

        checkboxGroup = new FlxTypedGroup<Checkbox>();
        add(checkboxGroup);

        descBox = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
        descBox.alpha = 0.6;
        add(descBox);
    }
}