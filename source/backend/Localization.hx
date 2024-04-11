package backend;

/**
 * A simple localization system.
 * Please credit me if you use it!
 * @author Joalor64GH
 */

class Localization 
{
    private static var data:Map<String, Dynamic>;
    private static var currentLanguage:String;
    private static var DEFAULT_LANGUAGE:String = "en";

    public static function loadLanguages():Bool
    {
        var allLoaded:Bool = true;

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
            if (FileSystem.exists(path)) {
                var listContent:String = File.getContent(path);
                var languages:Array<String> = listContent.split('\n');

                for (language in languages) {
                    var languageData:Dynamic = loadLanguageData(language.trim());
                    if (languageData != null) {
                        trace("successfully loaded language: " + language + "!");
                        data.set(language, languageData);
                    } else {
                        trace("oh no! failed to load language: " + language + "!");
                        allLoaded = false;
                    }
                }
            }
        }

        return allLoaded;
    }

    private static function loadLanguageData(language:String):Dynamic
    {
        var jsonContent:String = null;
        var path:String = Paths.getPath("languages/" + language + ".json");

        #if MODS_ALLOWED
        var modPath:String = Paths.modFolders("languages/" + language + ".json");
        
        if (FileSystem.exists(modPath)) {
            jsonContent = File.getContent(modPath);
            currentLanguage = language;
        } else if (FileSystem.exists(path)) {
            jsonContent = File.getContent(path);
            currentLanguage = language;
        }
        #else
        if (FileSystem.exists(path)) {
            jsonContent = File.getContent(path);
            currentLanguage = language;
        } 
        #end
        else {
            trace("oops! file not found for: " + language + "!");
            jsonContent = File.getContent(Paths.getPath("languages/" + DEFAULT_LANGUAGE + ".json"));
            currentLanguage = DEFAULT_LANGUAGE;
        }

        return Json.parse(jsonContent);
    }

    public static function switchLanguage(newLanguage:String):Bool
    {
        if (newLanguage == currentLanguage) {
            trace("hey! you're already using the language: " + newLanguage);
            return true;
        }

        var languageData:Dynamic = loadLanguageData(newLanguage);

        if (languageData != null) {
            trace("yay! successfully loaded data for: " + newLanguage);
            currentLanguage = newLanguage;
            data.set(newLanguage, languageData);
            return true;
        } else {
            trace("whoops! failed to load data for: " + newLanguage);
            return false;
        }

        return false;
    }

    public static function get(key:String, language:String = "en"):String
    {
        var targetLanguage:String = language.toLowerCase();
        var languageData = data.get(targetLanguage);
        if (data != null) {
            if (data.exists(targetLanguage)) {
                if (languageData != null && Reflect.hasField(languageData, key)) {
                    return Reflect.field(languageData, key);
                }
            }
        }

        return Reflect.field(languageData, key) ?? 'missing key: $key';
    }
}