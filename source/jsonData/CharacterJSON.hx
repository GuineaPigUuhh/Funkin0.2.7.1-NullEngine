package jsonData;

import haxe.Json;
import haxe.format.JsonParser;
import modding.ModPaths;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef CharacterINFO =
{
	var anims:Array<Anims>;
	// FUNKIN ANIMS SEPARATOR
	var prefs:Prefs;
}

typedef Prefs =
{
	var isGF:Bool;
	var antialiasing:Bool;
	var spriteSheet:String;
	var flipX:Bool;
	var healthBarColor:String;
	var icon:String;
	var singDuration:Float;
	var setScale:Float;
	// cam char wtf separator
	var cameraOffset:Point;
	var charOffset:Point;
}

typedef Anims =
{
	var animName:String;
	var animPrefix:String;
	var loop:Bool;
	var fps:Int;
	var indices:Array<Int>;
	var offsets:Point;
}

typedef Point =
{
	var x:Float;
	var y:Float;
}

class CharacterJSON
{
	public static var anims:Array<Anims>;
	public static var prefs:Prefs;

	public static function getJSON(char:String)
	{
		var path:String = ModPaths.json('characters/${char}');
		if (!FileSystem.exists(path))
			path = Paths.json('characters/${char}');

		var charJSON:CharacterINFO = Json.parse(File.getContent(path));

		anims = charJSON.anims;
		prefs = charJSON.prefs;
	}

	public static function jsonPath(char:String)
	{
		var path:String = ModPaths.json('characters/${char}');
		if (!FileSystem.exists(path))
			path = Paths.json('characters/${char}');

		return path;
	}
}
