package utils;

import dependency.ClientPrefs;
import dependency.Logs;
import dependency.Paths;
import flixel.FlxG;
import flixel.input.mouse.FlxMouse;
import haxe.iterators.StringKeyValueIterator;
import lime.utils.Assets;
import states.PlayState;
import utils.CoolUtil;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function formatSong(diff:Int):String
	{
		return difficultyArray[diff];
	}

	public static function arrayTextFile(path:String):Array<String>
	{
		var daList:Array<String> = File.getContent(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
