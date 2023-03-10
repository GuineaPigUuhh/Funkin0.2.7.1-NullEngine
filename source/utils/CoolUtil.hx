package utils;

import flixel.FlxG;
import flixel.input.mouse.FlxMouse;
import haxe.iterators.StringKeyValueIterator;
import lime.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function setMouseSprite(mouseOb:FlxMouse, graphic:Null<Dynamic>, ?scale:Float, ?offsets:Array<Int>)
	{
		if (offsets == null)
			offsets = [0, 0];
		if (scale == null)
			scale = 1;

		mouseOb.visible = true;
		mouseOb.load(configGraphic(graphic), scale, offsets[0], offsets[1]);
	}

	public static function configGraphic(graphic:String, ?lib:String)
	{
		var _image = ModPaths.image(graphic);
		if (!FileSystem.exists(_image))
			_image = Paths.image(graphic, lib);

		return _image;
	}

	public static function configSound(lolsound:String, ?lib:String)
	{
		var _sound = ModPaths.sound(lolsound);
		if (!FileSystem.exists(_sound))
			_sound = Paths.sound(lolsound, lib);

		return _sound;
	}

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

	public static function createModFolder(modName:String):Void
	{
		var modFolders:Array<String> = ['data', 'fonts', 'images', 'musics', 'sounds'];

		trace(" - Creating Mod Folder - \n");
		FileSystem.createDirectory("mods/" + modName);
		trace("Trace: Created " + modName + " Folder");

		trace(" - Creating Folders - \n");
		for (i in 0...modFolders.length)
		{
			var folderName = modFolders[i];

			FileSystem.createDirectory("mods/" + modName + "/" + folderName);
			trace("Trace: Created " + folderName + " Folder in " + modName);
		}

		var folder:String = "mods/" + modName;

		var dataFolders:Array<String> = ["characters", "songs", "stages", "videos"];
		var imageFolders:Array<String> = ["characters", "icons", "menuDifficulties", "storymenu", "credits"];

		trace(" - Creating Others - \n");
		for (i in 0...dataFolders.length)
		{
			FileSystem.createDirectory(folder + "/data/" + dataFolders[i]);
			trace("Trace: Created " + dataFolders[i] + " Folder in " + modName + " in Data");
		}

		for (i in 0...imageFolders.length)
		{
			FileSystem.createDirectory(folder + "/images/" + imageFolders[i]);
			trace("Trace: Created " + imageFolders[i] + " Folder in " + modName + " in Image");
		}

		trace("Trace: The Mod Was Created Successfully!");
	}

	public static function formatSong(diff:Int):String
	{
		var coolDiff:String = difficultyArray[diff];

		var formatedSong:String = coolDiff;

		return formatedSong;
	}

	public static function getInst(song:String):String
	{
		var inst:Any = ModPaths.inst(song);
		if (!FileSystem.exists(inst))
			inst = Paths.inst(song);

		if (!FileSystem.exists(inst))
		{
			trace("ERROR: don't have the instrument");
			return null;
		}

		return inst;
	}

	public static function getVocal(song:String):String
	{
		var vocal:Any = ModPaths.voices(song);
		if (!FileSystem.exists(vocal))
			vocal = Paths.voices(song);

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
