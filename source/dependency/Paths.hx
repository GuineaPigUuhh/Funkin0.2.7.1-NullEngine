package dependency;

import dependency.Logs;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library/$file';
	}

	inline static public function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		return getPreloadPath('songs/${song.toLowerCase()}/audio/Voices.$SOUND_EXT');
	}

	inline static public function inst(song:String)
	{
		return getPreloadPath('songs/${song.toLowerCase()}/audio/Inst.$SOUND_EXT');
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return getPreloadPath('fonts/$key');
	}

	inline static public function video(key:String)
	{
		return 'assets/videos/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function getJsonAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromTexturePackerJson(image(key, library), file('images/$key.json', library));
	}

	static public function characterPaths(char:String, aa:String):Any
	{
		switch (aa)
		{
			case "icon":
				return getPreloadPath('characters/$char/icon.png');

			case "spriteSheet.xml":
				return FlxAtlasFrames.fromSparrow(getPreloadPath('characters/$char/spritesheet.png'), getPreloadPath('characters/$char/spritesheet.xml'));

			case "spriteSheet.txt":
				return FlxAtlasFrames.fromSpriteSheetPacker(getPreloadPath('characters/$char/spritesheet.png'),
					getPreloadPath('characters/$char/spritesheet.txt'));

			case "spriteSheet.json":
				return FlxAtlasFrames.fromTexturePackerJson(getPreloadPath('characters/$char/spritesheet.png'),
					getPreloadPath('characters/$char/spritesheet.json'));

			default:
				Logs.error("THIS FORMAT DOESN'T EXIST");
		}
		return null;
	}
}
