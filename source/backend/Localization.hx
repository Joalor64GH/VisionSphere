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

        var listPath:String = Paths.txt('languagesList');
        var languages:Array<String> = [];

        if (FileSystem.exists(listPath)) {
            var listContent:String = File.getContent(listPath);
            languages = listContent.split("\n");
        } else {
            trace("uh oh! Couldn't find languagesList.txt!");
            return false;
        }

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

        return allLoaded;
    }

    private static function loadLanguageData(language:String):Dynamic
    {
        var jsonContent:String;
        var path:String = Paths.getPath("languages/" + language + ".json");

        if (FileSystem.exists(path)) {
            jsonContent = File.getContent(path);
            currentLanguage = language;
        } else {
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

        return Reflect.field(languageData, key) ?? 'missing key';
    }
}