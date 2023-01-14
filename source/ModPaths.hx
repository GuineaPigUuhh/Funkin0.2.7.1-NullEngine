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
		return Paths.getModPath('$key.hx', ModState.curMod);
	}

	inline static public function music(key:String)
	{
		return Paths.getModPath('musics/$key.ogg', ModState.curMod);
	}

	inline static public function sound(key:String)
	{
		return Paths.getModPath('sounds/$key.ogg', ModState.curMod);
	}

	inline static public function image(key:String)
	{
		return Paths.getModPath('images/$key.png', ModState.curMod);
	}

	inline static public function json(key:String)
	{
		return Paths.getModPath('data/$key.json', ModState.curMod);
	}

	inline static public function txt(key:String)
	{
		return Paths.getModPath('data/$key.txt', ModState.curMod);
	}

	inline static public function voices(song:String)
	{
		return 'mods/${ModState.curMod}/songs/${song.toLowerCase()}/Voices.ogg';
	}

	inline static public function inst(song:String)
	{
		return 'mods/${ModState.curMod}/songs/${song.toLowerCase()}/Inst.ogg';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key), Paths.getModPath('images/$key.xml', ModState.curMod));
	}

	inline static public function xml(key:String)
	{
		return Paths.getModPath('data/$key.xml', ModState.curMod);
	}
}
