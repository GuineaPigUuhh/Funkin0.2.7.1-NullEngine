package data;

import dependency.ModPaths;
import dependency.Paths;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef WeekList =
{
	var weeks:Array<Week>;
}

typedef Week =
{
	var weekSongs:Array<String>;
	var weekPath:String;
	var weekTitle:String;
	var weekCharacters:Array<String>;
	var songIcons:Array<String>;
	var songColor:String;
	var hideInFreePlay:Bool;
	var hideInStoryMode:Bool;
}

class WeekData
{
	public static var weeks:Array<Week>;

	public static function getJSON()
	{
		var path:String = ModPaths.json('weekList');
		if (!FileSystem.exists(path))
			path = Paths.json('weekList');

		var weekJSON:WeekList = Json.parse(File.getContent(path));

		weeks = weekJSON.weeks;
	}
}
