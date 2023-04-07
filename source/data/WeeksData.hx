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

		if (FileSystem.exists(Paths.getObjectsPath("weeks/weekList.txt")))
			weekList = File.getContent(Paths.getObjectsPath("weeks/weekList.txt")).split('\n');
		else
		{
			weekList = 'week0, week1, week2, week3, week4, week5, week6'.split(', ');
		}

		for (name in FileSystem.readDirectory(Paths.getObjectsPath("weeks/")))
		{
			var weekData:Week = Json.parse(File.getContent(Paths.getObjectsPath("weeks/" + name + '/data.json')));
			weekFiles.set(name, weekData);
		}
	}
}
