package jsonData;

import haxe.Json;
import haxe.format.JsonParser;
import modding.ModPaths;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef FunkinFile =
{
	var name:String;
	var title:String;
	var version:String;
}

class FunkinJSON
{
	public static function getJSON()
	{
		var path:String = 'mods/funkin.json';
		if (!FileSystem.exists(path))
			path = 'assets/funkin.json';

		var funkinJSON:FunkinFile = Json.parse(File.getContent(path));
	}
}
