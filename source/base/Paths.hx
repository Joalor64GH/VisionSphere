package base;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;

import flash.media.Sound;

import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as Assets;
import openfl.display.BitmapData;

using StringTools;

/**
 * Paths.hx, but with a modding extension based off of Psych Engine.
 * @author ShadowMario
 * @see https://github.com/ShadowMario/FNF-PsychEngine/
 */

class Paths
{
	#if MODS_ALLOWED
	public static var ignoreModFolders:Array<String> = [
		'data',
		'music',
		'sounds',
		'images',
		'fonts',
		'languages'
	];
	#end

	public static function clearUnusedMemory() 
	{
		for (key in currentTrackedAssets.keys()) 
		{
			if (!localTrackedAssets.contains(key)) {
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) 
				{
					Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}
		System.gc();
	}

	public static function removeBitmap(key)
	{
		var obj = currentTrackedAssets.get(key);
		@:privateAccess
		if (obj != null)
		{
			Assets.cache.removeBitmapData(key);
			FlxG.bitmap._cache.remove(key);
			obj.destroy();
			currentTrackedAssets.remove(key);
		}
	}

	public static var localTrackedAssets:Array<String> = [];
	public static function clearStoredMemory() 
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)) 
			{
				Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		for (key in currentTrackedSounds.keys()) 
		{
			if (!localTrackedAssets.contains(key) && key != null) 
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		localTrackedAssets = [];
		Assets.cache.clear("songs");
	}

	static var currentLevel:String;
	static public var currentModDirectory:String = '';

	public static function getPath(file:String, ?type:AssetType)
	{
		return getPreloadPath(file);
	}

	inline public static function getPreloadPath(file:String = '')
	{
		var path = 'assets/$file';
		if (currentLevel != null && Assets.exists('$currentLevel:$path'))
			return '$currentLevel:$path';
		return path;
	}

	inline static public function txt(key:String)
	{
		return getPath('data/$key.txt', TEXT);
	}

	inline static public function xml(key:String)
	{
		return getPath('data/$key.xml', TEXT);
	}

	inline static public function json(key:String)
	{
		return getPath('data/$key.json', TEXT);
	}

	inline static public function exists(asset:String, ?type:lime.utils.AssetType)
	{
		#if sys 
		return FileSystem.exists(asset);
		#else
		return Assets.exists(asset, type);
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

	#if html5
	static var pathMap = new Map<String, Array<String>>();

	public static function initPaths() 
	{	
		pathMap.clear();

		for (path in Assets.list())
		{
			var file = path.split("/").pop();
			var parent = path.substr(0, path.length - (file.length + 1));

			if (pathMap.exists(parent))
				pathMap.get(parent).push(file);
			else
				pathMap.set(parent, [file]);
		}

		return pathMap;
	}
	
	inline static public function iterateDirectory(Directory:String, Func)
	{
		var dir:String = Directory.endsWith("/") ? Directory.substr(0, -1) : Directory;

		if (!pathMap.exists(dir))
			return;

		for (i in pathMap.get(dir))
			Func(i);
	}
	#else
	inline static public function iterateDirectory(Directory:String, Func):Bool
	{
		if (!FileSystem.exists(Directory) || !FileSystem.isDirectory(Directory))
			return false;
		
		for (i in FileSystem.readDirectory(Directory))
			Func(i);

		return true;
	}
	#end

	static public function sound(key:String):Sound
	{
		var sound:Sound = returnSound('sounds', key);
		return sound;
	}
	
	inline static public function soundRandom(key:String, min:Int, max:Int)
	{
		return sound(key + FlxG.random.int(min, max));
	}

	inline static public function music(key:String):Sound
	{
		var file:Sound = returnSound('music', key);
		return file;
	}

	inline static public function image(key:String):FlxGraphic
	{
		var returnAsset:FlxGraphic = returnGraphic(key);
		return returnAsset;
	}
	
	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key)))
			return File.getContent(modFolders(key));
		#end

		if (FileSystem.exists(getPreloadPath(key)))
			return File.getContent(getPreloadPath(key));
		#end
		
		return Assets.getText(getPath(key, TEXT));
	}

	inline static public function font(key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsFont(key);
		if(FileSystem.exists(file)) {
			return file;
		}
		#end
		return 'assets/fonts/$key';
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false)
	{
		#if MODS_ALLOWED
		if (FileSystem.exists(mods(currentModDirectory + '/' + key)) || FileSystem.exists(mods(key)))
			return true;
		#end
		
		return Paths.exists(getPath(key, type));
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

	inline static public function formatToSongPath(path:String) {
		return path.toLowerCase().replace(' ', '-');
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static function getGraphic(path:String):FlxGraphic
	{
		#if html5
		return FlxG.bitmap.add(path, false, path);
		#elseif sys
		return FlxGraphic.fromBitmapData(BitmapData.fromFile(path), false, path);
		#end
	}

	public static function returnGraphic(key:String)
	{
		#if MODS_ALLOWED
		var modKey:String = modsImages(key);
		if (FileSystem.exists(modKey))
		{
			if (!currentTrackedAssets.exists(modKey)){
				var newGraphic:FlxGraphic = getGraphic(modKey);
				newGraphic.persist = true;
				currentTrackedAssets.set(modKey, newGraphic);
			}
			localTrackedAssets.push(modKey);
			return currentTrackedAssets.get(modKey);
		}
		#end

		var path = getPath('images/$key.png', IMAGE);
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
		trace('oh no!!' + '$key' + 'returned null!');
		return null;
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];

	public static function returnSoundPath(path:String, key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsSounds(path, key);
		if (FileSystem.exists(file))
			return file;
		
		#end
		var gottenPath:String = getPath('$path/$key.ogg', SOUND);
		return gottenPath;
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
		var gottenPath:String = getPath('$path/$key.ogg', SOUND);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		if (!currentTrackedSounds.exists(gottenPath))
			#if MODS_ALLOWED
			currentTrackedSounds.set(gottenPath, Sound.fromFile('./$gottenPath'));
			#else
				currentTrackedSounds.set(
					gottenPath, 
					Assets.getSound(getPath('$path/$key.ogg', SOUND))
				);
			#end
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}
	
	#if MODS_ALLOWED
	static final modFolderPath:String = "mods/";

	inline static public function mods(key:String = '')
		return modFolderPath + key;
	
	inline static public function modsFont(key:String)
		return modFolders('fonts/' + key);

	inline static public function modsJson(key:String)
		return modFolders('data/' + key + '.json');

	inline static public function modsSounds(path:String, key:String)
		return modFolders(path + '/' + key + '.ogg');

	inline static public function modsImages(key:String)
		return modFolders('images/' + key + '.png');

	inline static public function modsXml(key:String)
		return modFolders('images/' + key + '.xml');

	inline static public function modsTxt(key:String)
		return modFolders('images/' + key + '.txt');

	static public function modFolders(key:String) {
		if(currentModDirectory != null && currentModDirectory.length > 0) {
			var fileToCheck:String = mods(currentModDirectory + '/' + key);
			if(FileSystem.exists(fileToCheck)) {
				return fileToCheck;
			}
		}

		for(mod in getGlobalMods()){
			var fileToCheck:String = mods(mod + '/' + key);
			if(FileSystem.exists(fileToCheck))
				return fileToCheck;

		}
		return 'mods/' + key;
	}

	public static var globalMods:Array<String> = [];

	static public function getGlobalMods()
		return globalMods;

	static public function pushGlobalMods()
	{
		globalMods = [];
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var list:Array<String> = CoolUtil.getText(path);
			for (i in list)
			{
				var dat = i.split("|");
				if (dat[1] == "1")
				{
					var folder = dat[0];
					var path = Paths.mods(folder + '/pack.json');
					if(FileSystem.exists(path)) {
						try{
							var rawJson:String = File.getContent(path);
							if(rawJson != null && rawJson.length > 0) {
								var stuff:Dynamic = Json.parse(rawJson);
								var global:Bool = Reflect.getProperty(stuff, "runsGlobally");
								if(global)globalMods.push(dat[0]);
							}
						} catch(e:Dynamic){
							trace(e);
						}
					}
				}
			}
		}
		return globalMods;
	}

	static public function getModDirectories():Array<String> {
		var list:Array<String> = [];
		var modsFolder:String = mods();
		if(FileSystem.exists(modsFolder)) {
			for (folder in FileSystem.readDirectory(modsFolder)) {
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !ignoreModFolders.contains(folder) && !list.contains(folder)) {
					list.push(folder);
				}
			}
		}
		return list;
	}
	#end
}