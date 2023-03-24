package dependency;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import game.Controls;
import haxe.Json;
import haxe.format.JsonParser;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class ClientPrefs
{
	public static var saveMap:Map<String, Dynamic> = [
		"ghostTapping" => true,
		"flashing" => true,
		"antialiasing" => true,
		"freeplayCutscene" => false,
		"noteSplash" => false,
		"middleScroll" => false,
		"isDownscroll" => false,
		"framerate" => 120
	];

	public static var controls:Map<String, Array<FlxKey>> = [
		"up" => [FlxKey.UP, W],
		"down" => [FlxKey.DOWN, S],
		"left" => [FlxKey.LEFT, A],
		"right" => [FlxKey.RIGHT, D]
	];

	static var logsAllowed:Bool = true;

	public static function save()
	{
		for (name => va in saveMap)
		{
			if (Reflect.getProperty(FlxG.save.data, name) == null)
				Reflect.setProperty(FlxG.save.data, name, va);

			if (logsAllowed)
			{
				Logs.create({message: "Saved " + name + " / " + Reflect.getProperty(FlxG.save.data, name), type: "SAVE", color: Logs.MAGENTA});
			}
		}
		FlxG.save.flush();
	}

	public static function load()
	{
		if (FlxG.save.data.framerate != null)
		{
			FlxG.drawFramerate = FlxG.save.data.framerate;
			FlxG.updateFramerate = FlxG.save.data.framerate;
		}
	}
}
