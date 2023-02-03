package;

import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef ModOptions =
{
	var name:String;
	var desc:String;
	var color:String;
}

class ModJSON
{
	public static var modName:String;
	public static var modDesc:String;
	public static var modColor:String;

	public static function getJSON(curMOD:String)
	{
		var format:String = ".json";
		var path:String = 'mods/' + curMOD + '/mod';

		var modJSON:ModOptions = Json.parse(File.getContent(path));

		modName = modJSON.name;
		modDesc = modJSON.desc;
		modColor = modJSON.color;
	}
}
