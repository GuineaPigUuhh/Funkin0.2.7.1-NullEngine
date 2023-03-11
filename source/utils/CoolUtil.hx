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

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	inline public static function absoluteDirectory(file:String):Array<String>
	{
		if (!file.endsWith('/'))
			file = '$file/';

		var path:String = Paths.file(file);

		var absolutePath:String = FileSystem.absolutePath(path);
		var directory:Array<String> = FileSystem.readDirectory(absolutePath);

		if (directory != null)
		{
			var dirCopy:Array<String> = directory.copy();

			for (i in dirCopy)
			{
				var index:Int = dirCopy.indexOf(i);
				var file:String = '$path$i';
				dirCopy.remove(i);
				dirCopy.insert(index, file);
			}

			directory = dirCopy;
		}

		return if (directory != null) directory else [];
	}

	public static function formatSong(diff:Int):String
	{
		var coolDiff:String = difficultyArray[diff];

		var formatedSong:String = coolDiff;

		return formatedSong;
	}

	public static function getInst(song:String):String
	{
		var inst = Paths.inst(song);

		if (!FileSystem.exists(inst))
		{
			trace("ERROR: don't have the instrument");
			return null;
		}

		return inst;
	}

	public static function getVocal(song:String):String
	{
		var vocal = Paths.voices(song);

		if (!FileSystem.exists(vocal))
		{
			trace("ERROR: don't have the voices");
			return null;
		}

		return vocal;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

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
