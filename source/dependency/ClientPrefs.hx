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

@:keep
class Settings
{
	@:keep public static var testVar:String = "BALLS";
}

class ClientPrefs
{
	public static var saveMap:Map<String, Dynamic> = [
		 "ghostTapping" => true, "flashing" => true, "antialiasing" => true, "freeplayCutscene" => false, "noteSplash" => false, "middleScroll" => false,
		"isDownscroll" => false, "framerate" => 120,   "fpsVisible" => true,        "memVisible" => true,   "watermark" => true,   "stringTest" => "low"
	];

	public static var controls:Map<String, Array<FlxKey>> = [
		"up" => [FlxKey.UP, FlxKey.W],
		"down" => [FlxKey.DOWN, FlxKey.S],
		"left" => [FlxKey.LEFT, FlxKey.A],
		"right" => [FlxKey.RIGHT, FlxKey.D]
	];

	static var logsAllowed:Bool = true;

	public static function save()
	{
		for (variableName in Type.getClassFields(Settings))
		{
			var variableValue = Reflect.getProperty(Settings, variableName);
			// PIZZA TOWER REFERENCE??!??!?!?!?!?
			trace("Pizza Time! " + variableName + " And Value " + variableValue);
		}

		for (name => va in saveMap)
		{
			if (Reflect.getProperty(FlxG.save.data, name) == null)
				Reflect.setProperty(FlxG.save.data, name, va);

			if (logsAllowed)
			{
				Logs.custom('$name // ${Reflect.getProperty(FlxG.save.data, name)}', "SAVE", Logs.MAGENTA);
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
