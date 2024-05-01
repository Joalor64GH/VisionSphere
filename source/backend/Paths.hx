package backend;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;

import openfl.media.Sound;

/**
 * @author ShadowMario
 * @see https://github.com/ShadowMario/FNF-PsychEngine/
 */

@:access(openfl.display.BitmapData)
class Paths
{
	#if MODS_ALLOWED
	public static var ignoreModFolders:Array<String> = [
		'_append',
		'languages',
		'data',
		'music',
		'sounds',
		'images',
		'fonts'
	];
	#end

	public static var localTrackedAssets:Array<String> = [];
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];

	static public var currentModDirectory:String = '';

	public static function clearUnusedMemory() 
	{
		for (key in currentTrackedAssets.keys()) 
		{
			if (!localTrackedAssets.contains(key))
			{
				destroyGraphic(currentTrackedAssets.get(key));
				currentTrackedAssets.remove(key);
			}
		}
		openfl.system.System.gc();
	}

	@:access(flixel.system.frontEnds.BitmapFrontEnd._cache)
	public static function clearStoredMemory() 
	{
		for (key in FlxG.bitmap._cache.keys())
		{
			if (!currentTrackedAssets.exists(key))
				destroyGraphic(FlxG.bitmap.get(key));
		}

		for (key => asset in currentTrackedSounds) 
		{
			if (!localTrackedAssets.contains(key) && asset != null) 
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		localTrackedAssets = [];
	}

	inline static function destroyGraphic(graphic:FlxGraphic)
	{
		if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null)
			graphic.bitmap.__texture.dispose();
		FlxG.bitmap.remove(graphic);
	}

	private static var trackedBitmaps:Map<String, BitmapData> = new Map();

	public static function setBitmap(id:String, ?bitmap:BitmapData):BitmapData
	{
		if (!trackedBitmaps.exists(id) && bitmap != null)
			trackedBitmaps.set(id, bitmap);
		pushTracked(id);
		return trackedBitmaps.get(id);
	}

	public static function disposeBitmap(id:String)
	{
		var obj:Null<BitmapData> = trackedBitmaps.get(id);
		if (obj != null)
		{
			obj.dispose();
			obj.disposeImage();
			obj = null;
			trackedBitmaps.remove(id);
		}
	}

	public static function pushTracked(file:String)
	{
		if (!localTrackedAssets.contains(file))
			localTrackedAssets.push(file);
	}

	public static function getPath(file:String, ?modsAllowed:Bool = false):String
	{
		#if MODS_ALLOWED
		if (modsAllowed)
			if (FileSystem.exists(modFolders(file))) return modFolders(file);
		#end
		return 'assets/$file';
	}

	inline static public function txt(key:String)
		return getPath('data/$key.txt');

	inline static public function xml(key:String)
		return getPath('data/$key.xml');

	inline static public function json(key:String)
		return getPath('data/$key.json');

	#if yaml
	inline static public function yaml(key:String)
		return getPath('data/$key.yaml');
	#end

	inline static public function video(key:String) 
	{
		#if MODS_ALLOWED
		if (FileSystem.exists(modsVideo(key))) return modsVideo(key);
		#end
		return getPath('videos/$key.webm');
	}

	inline static public function videoSound(key:String)
		return getPath('videos/$key.ogg');

	static public function sound(key:String):Sound
		return returnSound('sounds', key);
	
	inline static public function soundRandom(key:String, min:Int, max:Int)
		return sound(key + FlxG.random.int(min, max));

	inline static public function music(key:String):Sound
		return returnSound('music', key);

	inline static public function image(key:String):FlxGraphic
		return returnGraphic(key);

	inline static public function font(key:String)
	{
		#if MODS_ALLOWED
		if (FileSystem.exists(modsFont(key))) return modsFont(key);
		#end
		return getPath('fonts/$key');
	}

	inline static public function getSparrowAtlas(key:String):FlxAtlasFrames
	{
		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = returnGraphic(key);

		return FlxAtlasFrames.fromSparrow(
			(imageLoaded != null ? imageLoaded : image(key)),
			(FileSystem.exists(modsXml(key)) ? File.getContent(modsXml(key)) : getPath('images/$key.xml'))
		);
		#else
		return FlxAtlasFrames.fromSparrow(image(key), getPath('images/$key.xml'));
		#end
	}

	inline static public function getPackerAtlas(key:String)
	{
		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = returnGraphic(key);
		var txtExists:Bool = FileSystem.exists(modFolders('images/$key.txt'));

		return FlxAtlasFrames.fromSpriteSheetPacker((imageLoaded != null ? imageLoaded : image(key)),
			(txtExists ? File.getContent(modFolders('images/$key.txt')) : getPath('images/$key.txt')));
		#else
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), getPath('images/$key.txt'));
		#end
	}

	public static function fileExists(key:String, ?ignoreMods:Bool = false)
	{
		#if MODS_ALLOWED
		if (!ignoreMods) 
		{
			for (mod in getGlobalMods())
				if (FileSystem.exists(mods('$mod/$key')))
					return true;

			if (FileSystem.exists(mods('$currentModDirectory/$key')) || FileSystem.exists(mods(key)))
				return true;
			
			if (FileSystem.exists(mods('$key')))
				return true;
		}
		#end
		
		return (Assets.exists(getPath(key, false))) ? true : false;
	}

	inline static public function exists(asset:String)
	{
		#if sys 
		return FileSystem.exists(asset);
		#else
		return Assets.exists(asset);
		#end
	}

	inline static public function getContent(asset:String):Null<String> 
	{
		#if sys
		if (FileSystem.exists(asset))
			return File.getContent(asset);
		#else
		if (Assets.exists(asset))
			return Assets.getText(asset);
		#end

		return null;
	}

	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key)))
			return File.getContent(modFolders(key));
		#end

		if (FileSystem.exists(getPath(key)))
			return File.getContent(getPath(key));
		#end
		
		return (Assets.exists(getPath(key))) ? Assets.getText(getPath(key)) : null;
	}

	public static function getGraphic(path:String):FlxGraphic
	{
		return FlxGraphic.fromBitmapData(BitmapData.fromFile(path), false, path);
	}

	public static function returnGraphic(key:String)
	{
		#if MODS_ALLOWED
		var modKey:String = modsImages(key);
		if (FileSystem.exists(modKey))
		{
			if (!currentTrackedAssets.exists(modKey)) {
				var newGraphic:FlxGraphic = getGraphic(modKey);
				newGraphic.persist = true;
				currentTrackedAssets.set(modKey, newGraphic);
			}
			localTrackedAssets.push(modKey);
			return currentTrackedAssets.get(modKey);
		}
		#end

		var path = getPath('images/$key.png');
		if (Assets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var newGraphic:FlxGraphic = getGraphic(path);
				newGraphic.persist = true;
				currentTrackedAssets.set(path, newGraphic);
			}
			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}
		trace('oh no!! $key returned null!');
		return null;
	}

	public static function returnSoundPath(path:String, key:String)
	{
		#if MODS_ALLOWED
		if (FileSystem.exists(modsSounds(path, key))) return modsSounds(path, key);
		#end
		return getPath('$path/$key.ogg');
	}

	public static function returnSound(path:String, key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsSounds(path, key);
		if (FileSystem.exists(file))
		{
			if (!currentTrackedSounds.exists(file))
				currentTrackedSounds.set(file, Sound.fromFile(file));
			
			localTrackedAssets.push(key);
			return currentTrackedSounds.get(file);
		}
		#end
		var gottenPath:String = getPath('$path/$key.ogg');
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		if (!currentTrackedSounds.exists(gottenPath))
			#if MODS_ALLOWED
			currentTrackedSounds.set(gottenPath, Sound.fromFile('./$gottenPath'));
			#else
			currentTrackedSounds.set(gottenPath, Assets.getSound(getPath('$path/$key.ogg')));
			#end
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}
	
	#if MODS_ALLOWED
	inline static public function mods(key:String = '')
		return 'mods/$key';
	
	inline static public function modsFont(key:String)
		return modFolders('fonts/$key');

	inline static public function modsJson(key:String)
		return modFolders('data/$key.json');

	inline static public function modsVideo(key:String)
		return modFolders('videos/$key.webm');
	
	inline static public function modsVideoSound(key:String)
		return modFolders('videos/$key.ogg');

	inline static public function modsSounds(path:String, key:String)
		return modFolders('$path/$key.ogg');

	inline static public function modsImages(key:String)
		return modFolders('images/$key.png');

	inline static public function modsXml(key:String)
		return modFolders('images/$key.xml');

	inline static public function modsTxt(key:String)
		return modFolders('images/$key.txt');

	static public function modFolders(key:String) {
		if (currentModDirectory != null && currentModDirectory.length > 0)
			if (FileSystem.exists(mods('$currentModDirectory/$key')))
				return mods('$currentModDirectory/$key');

		for (mod in getGlobalMods())
			if (FileSystem.exists(mods('$mod/$key')))
				return mods('$mod/$key');
		
		return 'mods/$key';
	}

	public static var globalMods:Array<String> = [];

	static public function getGlobalMods()
		return globalMods;

	static public function pushGlobalMods()
	{
		globalMods = [];
		var path:String = 'modsList.txt';
		if (FileSystem.exists(path))
		{
			var list:Array<String> = CoolUtil.getText(path);
			for (i in list)
			{
				var dat = i.split("|");
				if (dat[1] == "1")
				{
					var folder = dat[0];
					var path = mods('$folder/pack.json');
					if (FileSystem.exists(path)) {
						try {
							var rawJson:String = File.getContent(path);
							if (rawJson != null && rawJson.length > 0) {
								var stuff:Dynamic = Json.parse(rawJson);
								var global:Bool = Reflect.getProperty(stuff, "runsGlobally");
								if (global) globalMods.push(dat[0]);
							}
						} catch(e:Dynamic) {
							trace(e);
						}
					}
				}
			}
		}
		else
		{
			trace("Oops! Could not find 'modsList.txt'! Creating a new file...");
			File.saveContent(path, 'my-mod|1');
		}
		return globalMods;
	}

	static public function getModDirectories():Array<String> {
		var list:Array<String> = [];
		var modsFolder:String = mods();
		if (FileSystem.exists(modsFolder)) {
			for (folder in FileSystem.readDirectory(modsFolder))
				if (FileSystem.isDirectory(haxe.io.Path.join([modsFolder, folder])) 
					&& !ignoreModFolders.contains(folder) && !list.contains(folder))
					list.push(folder);
		}
		return list;
	}
	#end
}