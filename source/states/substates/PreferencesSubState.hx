package states.substates;

import backend.data.Option;
import frontend.Colorblind;

class PreferencesSubState extends BaseOptionsMenu
{
    var bg:FlxSprite;

    public function new()
    {
        super();

        bg = new FlxSprite().loadGraphic(Paths.image('theme/' + SaveData.theme));
        add(bg);

        #if desktop
        var option:Option = new Option('Fullscreen',
            'Simply enables or disables fullscreen. (Desktop Only)',
            'fullscreen',
            'bool',
            false);
        addOption(option);
        option.onChange = () -> optionOnChange;
        #end

        var option:Option = new Option('FPS Counter',
            'Toggles the FPS counter.',
            'fullscreen',
            'bool',
            true);
        addOption(option);

        var option:Option = new Option('Colorblind Mode:',
            'What color blindness do you have?',
            'colorBlindFilter',
            'string',
            'None',
            [
                'None', 
                'Deuteranopia', 
                'Protanopia', 
                'Tritanopia', 
                'Gameboy', 
                'Vitrual Boy', 
                'Black and White',
                'Inverted',
                'What Even'
            ]);
        addOption(option);
        option.onChange = () -> optionOnChange;

        var option:Option = new Option('Colorblind Intensity:',
            'How intense should the colorblind filters be?',
            'colorBlindIntensity',
            'percent',
            0);
        addOption(option);
        option.onChange = () -> optionOnChange;
        option.scrollSpeed = 1.6;
        option.minValue = 0.1;
        option.maxValue = 1.0;
        option.changeValue = 0.1;
        option.decimals = 1;

        var option:Option = new Option('Time Format:',
            'Choose a time format.',
            'timeFormat',
            'string',
            '%r',
            ['%r', '%T']);
        addOption(option);

        var option:Option = new Option('Framerate:',
            "Isn't it obvious?",
            'framerate',
            'int',
            60);
        addOption(option);
        option.onChange = () -> optionOnChange;
        option.minValue = 60;
        option.maxValue = 240;
        option.displayFormat = '%v FPS';
        option.scrollSpeed = 10;

        var option:Option = new Option('Theme:',
            'Would you like a different theme?',
            'theme',
            'string',
            'daylight',
            ['daylight', 'night', 'dreamcast', 'ps3', 'xp']);
        addOption(option);
        option.onChange = () -> optionOnChange;
    }

    function optionOnChange(name:String)
    {
        switch (name)
        {
            #if desktop
            case 'Fullscreen':
                FlxG.fullscreen = SaveData.fullscreen;
            #end
            case 'FPS Counter':
                if (Main.fpsDisplay != null)
			        Main.fpsDisplay.visible = SaveData.fpsCounter;
            case 'Colorblind Mode:' | 'Colorblind Intensity:':
                var index = ['None', 'Deuteranopia', 'Protanopia', 'Tritanopia', 'Gameboy', 
                    'Vitrual Boy', 'Black and White', 'Inverted', 'What Even'].indexOf(SaveData.colorBlindFilter);
                Colorblind.updateColorBlindFilter(index, SaveData.colorBlindIntensity);
            case 'Theme:':
                var index = ['daylight', 'night', 'dreamcast', 'ps3', 'xp'].indexOf(SaveData.theme);
                bg.loadGraphic(Paths.image('theme/' + index));
            case 'Framerate:':
                FlxG.updateFramerate = (SaveData.framerate > FlxG.drawFramerate) ? SaveData.framerate : SaveData.framerate;
                FlxG.drawFramerate = (SaveData.framerate > FlxG.drawFramerate) ? SaveData.framerate : SaveData.framerate;
                FlxG.game.focusLostFramerate = Math.ceil(SaveData.framerate / 2);
        }
    }
}