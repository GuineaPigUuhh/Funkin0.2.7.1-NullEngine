package dependency;

import dependency.Logs;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static function getPath(file:String, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		return getFunkinPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getFunkinPath(file); else if (library == "objects") getObjectsPath(file); else
			getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return 'assets/$library/$file';
	}

	inline static public function getFunkinPath(file:String)
	{
		return 'assets/funkin/$file';
	}

	inline static public function getObjectsPath(file:String)
	{
		return 'assets/objects/$file';
	}

	inline static public function file(file:String, ?library:String)
	{
		return getPath(file, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('$key.txt', library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('$key.xml', library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', library);
	}

	inline static public function voices(song:String)
	{
		return getFunkinPath('songs/${song.toLowerCase()}/audio/Voices.$SOUND_EXT');
	}

	inline static public function inst(song:String)
	{
		return getFunkinPath('songs/${song.toLowerCase()}/audio/Inst.$SOUND_EXT');
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', library);
	}

	inline static public function font(key:String)
	{
		return getLibraryPathForce('fonts/$key', "core");
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
}
