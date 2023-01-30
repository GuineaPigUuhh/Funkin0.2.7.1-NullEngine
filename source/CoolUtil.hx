package;

import lime.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var difficultyArrayExport:Array<String> = ['-easy', "", "-hard"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function difficultyExport():String
	{
		return difficultyArrayExport[PlayState.storyDifficulty];
	}

	public static function createModFolder():Void
	{
	}

	public static function getInst(string:String):String
	{
		var inst = ModPaths.inst(string);
		if (!FileSystem.exists(inst))
			inst = Paths.inst(string);

		return inst;
	}

	public static function getVocal(string:String):String
	{
		var vocal = ModPaths.voices(string);
		if (!FileSystem.exists(vocal))
			vocal = Paths.voices(string);

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
