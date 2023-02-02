package;

import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef ListJson =
{
	var opponents:Array<String>;
	var boyfriends:Array<String>;
	var girlfriends:Array<String>;
	var stages:Array<String>;
}

class ChartJSON
{
	public static var opponents:Array<String>;
	public static var boyfriends:Array<String>;
	public static var girlfriends:Array<String>;
	public static var stages:Array<String>;

	public static function getJSON(filePath:String)
	{
		var path:String = ModPaths.json(filePath);
		if (!FileSystem.exists(path))
			path = Paths.json(filePath);

		var chartJSON:ListJson = Json.parse(File.getContent(path));

		opponents = chartJSON.opponents;
		boyfriends = chartJSON.boyfriends;
		girlfriends = chartJSON.girlfriends;
		stages = chartJSON.stages;
	}
}
