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
	var modName:String = ModState.curMod;

	inline static public function music(key:String)
	{
		return Paths.getModPath('musics/$key.ogg', modName);
	}

	inline static public function sound(key:String)
	{
		return Paths.getModPath('sounds/$key.ogg', modName);
	}

	inline static public function image(key:String)
	{
		return Paths.getModPath('images/$key.png', modName);
	}

	inline static public function json(key:String)
	{
		return Paths.getModPath('data/$key.json', modName);
	}

	inline static public function txt(key:String)
	{
		return Paths.getModPath('data/$key.txt', modName);
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key), Paths.getModPath('images/$key.xml', modName););
	}

	inline static public function xml(key:String)
	{
		return Paths.getModPath('data/$key.xml', modName);
	}
}
