package states.games.rhythmo;

import openfl.utils.Assets;
import states.games.rhythmo.Section.SectionArray;

using StringTools;

typedef Cantando = {
    var song:String;
    var notes:Array<SectionArray>;
    var bpm:Int;
    var sections:Int;
    var sectionLengths:Array<Dynamic>;
    var needsVoices:Bool;
    var speed:Float;

    var player1:String;
    var player2:String;
}

class Song
{
    public var song:String;
    public var notes:Array<SectionArray>;
    public var bpm:Int;
    public var sections:Int;
    public var sectionLengths:Array<Dynamic> = [];
    public var needsVoices:Bool = true;
    public var speed:Float = 1;

    public var player1:String = 'dude';
    public var player2:String = 'guy';

    public function new(song, notes, bpm, sections)
    {
        this.song = song;
        this.notes = notes;
        this.bpm = bpm;
        this.sections = sections;

        for (i in 0...notes.length)
            this.sectionLengths.push(notes[i]);
    }

    public static function loadFromJSON(file:String, ?folder:String):Cantando
    {
        var rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + file.toLowerCase())).trim();

        while (!rawJson.endsWith("}"))
            rawJson = rawJson.substr(0, rawJson.length - 1);

        var swagger:Cantando = cast Json.parse(rawJson).song;
        return swagger;
    }
}