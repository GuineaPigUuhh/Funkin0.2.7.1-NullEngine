package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class ModPaths
{
	inline static public function hscript(key:String)
	{
		return Paths.getModPath('$key.hx');
	}

	inline static public function music(key:String)
	{
		return Paths.getModPath('musics/$key.ogg');
	}

	inline static public function sound(key:String)
	{
		return Paths.getModPath('sounds/$key.ogg');
	}

	inline static public function image(key:String)
	{
		return Paths.getModPath('images/$key.png');
	}

	inline static public function font(key:String)
	{
		return Paths.getModPath('fonts/$key');
	}

	inline static public function file(key:String)
	{
		return Paths.getModPath('$key');
	}

	inline static public function json(key:String)
	{
		return Paths.getModPath('data/$key.json');
	}

	inline static public function txt(key:String)
	{
		return Paths.getModPath('data/$key.txt');
	}

	inline static public function video(key:String)
	{
		return Paths.getModPath('data/videos/$key');
	}

	inline static public function voices(song:String)
	{
		return Paths.getModPath('data/songs/${song.toLowerCase()}/audio/Voices.ogg');
	}

	inline static public function inst(song:String)
	{
		return Paths.getModPath('data/songs/${song.toLowerCase()}/audio/Inst.ogg');
	}

	inline static public function getSparrowAtlas(key:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key), Paths.getModPath('images/$key.xml'));
	}

	inline static public function getPackerAtlas(key:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), file('images/$key.txt'));
	}

	inline static public function xml(key:String)
	{
		return Paths.getModPath('data/$key.xml');
	}
}
