package dependency;

import flash.media.Sound;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
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

class ModPaths
{
	inline static public function hscript(key:String)
	{
		return Paths.getModPath('$key.hx');
	}

	inline static public function music(key:String)
	{
		return Paths.getModPath('musics/${key}.${Paths.SOUND_EXT}');
	}

	inline static public function sound(key:String)
	{
		return Paths.getModPath('sounds/${key}.${Paths.SOUND_EXT}');
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
		return Paths.getModPath('data/songs/${song.toLowerCase()}/audio/Voices.${Paths.SOUND_EXT}');
	}

	inline static public function inst(song:String)
	{
		return Paths.getModPath('data/songs/${song.toLowerCase()}/audio/Inst.${Paths.SOUND_EXT}');
	}

	inline static public function getSparrowAtlas(key:String)
	{
		var existsXML:Bool = false;
		var xmlFile = Paths.file('images/$key.xml');
		if (FileSystem.exists(file('images/$key.xml')))
		{
			existsXML = true;
			xmlFile = File.getContent(file('images/$key.xml'));
		}

		return FlxAtlasFrames.fromSparrow(image(key), xmlFile);
	}

	inline static public function getPackerAtlas(key:String)
	{
		var existsTEXT:Bool = false;
		var txtFile = Paths.file('images/$key.txt');
		if (FileSystem.exists(file('images/$key.txt')))
		{
			existsTEXT = true;
			txtFile = File.getContent(file('images/$key.txt'));
		}

		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), txtFile);
	}

	inline static public function xml(key:String)
	{
		return Paths.getModPath('data/$key.xml');
	}
}
