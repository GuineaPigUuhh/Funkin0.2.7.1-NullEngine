package data;

import dependency.Paths;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef Song =
{
	var name:String;
	var icon:String;
	var color:String;
}

typedef Week =
{
	var songs:Array<Song>;

	var image:String;
	var characters:Array<String>;
	var title:String;
	var hideOnStoryMode:Bool;
	var hideOnFreeplay:Bool;
}

class WeeksData
{
	public static var weekFiles:Map<String, Week> = [];
	public static var weekList:Array<String> = [];

	public static function getFiles()
	{
		weekFiles = new Map<String, Week>();

		if (FileSystem.exists(Paths.getPreloadPath("weeks/weekList.txt")))
			weekList = File.getContent(Paths.getPreloadPath("weeks/weekList.txt")).split('\n');
		else
		{
			weekList = 'week0, week1, week2, week3, week4, week5, week6'.split(', ');
		}

		for (file in FileSystem.readDirectory(Paths.getPreloadPath("weeks/")))
		{
			if (file.endsWith(".json"))
			{
				var weekData:Week = Json.parse(File.getContent(Paths.getPreloadPath("weeks/" + file)));
				weekFiles.set(file.replace(".json", ""), weekData);
			}
		}
	}
}
