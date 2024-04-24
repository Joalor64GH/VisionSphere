package backend;

#if openfl
import openfl.system.Capabilities;
#end

/**
 * A simple localization system.
 * Please credit me if you use it!
 * @author Joalor64GH
 */

class Localization 
{
    private static var data:Map<String, Dynamic>;
    private static var currentLanguage:String;

    public static var DEFAULT_LANGUAGE:String = "en";
    public static var systemLanguage(get, never):String;

    public static function get_systemLanguage()
    {
        #if openfl
        return Capabilities.language;
        #else
        return throw "This is only for OpenFl!";
        #end
    }

    public static function loadLanguages()
    {
        data = new Map<String, Dynamic>();

        var foldersToCheck:Array<String> = [Paths.getPath('data/')];

        #if MODS_ALLOWED
        foldersToCheck.insert(0, Paths.mods("data/"));
        if (Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
            foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + "/data/"));
        
        for (mod in Paths.getGlobalMods())
            foldersToCheck.insert(0, Paths.mods(mod + "/data/"));
        #end

        for (folder in foldersToCheck) {
            var path:String = folder + "languagesList.txt";
            if (FileAssets.exists(path)) {
                var listContent:String = getFile(path);
                var languages:Array<String> = listContent.split('\n');

                for (language in languages) {
                    var languageData:Dynamic = loadLanguageData(language.trim());
                    data.set(language, languageData);
                }
            }
        }
    }

    private static function loadLanguageData(language:String):Dynamic
    {
        var jsonContent:String = null;
        var path:String = Paths.getPath("languages/" + language + ".json");

        #if MODS_ALLOWED
        var modPath:String = Paths.modFolders("languages/" + language + ".json");
        
        if (FileAssets.exists(modPath)) {
            jsonContent = getFile(modPath);
            currentLanguage = language;
        } else if (FileAssets.exists(path)) {
            jsonContent = getFile(path);
            currentLanguage = language;
        }
        #else
        if (FileAssets.exists(path)) {
            jsonContent = getFile(path);
            currentLanguage = language;
        } 
        #end
        else {
            trace("oops! file not found for: " + language + "!");
            jsonContent = getFile(Paths.getPath("languages/" + DEFAULT_LANGUAGE + ".json"));
            currentLanguage = DEFAULT_LANGUAGE;
        }

        return Json.parse(jsonContent);
    }

    public static function switchLanguage(newLanguage:String)
    {
        if (newLanguage == currentLanguage)
            return;

        var languageData:Dynamic = loadLanguageData(newLanguage);

        currentLanguage = newLanguage;
        data.set(newLanguage, languageData);
        trace('Language switched to $newLanguage');
    }

    public static function get(key:String, ?language:String):String
    {
        var targetLanguage:String = language ?? currentLanguage;
        var languageData = data.get(targetLanguage);

        if (data == null)
            return null;

        if (data.exists(targetLanguage))
            if (Reflect.hasField(languageData, key))
                return Reflect.field(languageData, key);

        return null;
    }

    private static function getFile(file:String)
    {
        #if sys
        File.getContent(file);
        #else
        Assets.getText(file);
        #end
    }
}

typedef FileAssets = #if sys FileSystem; #else Assets; #end