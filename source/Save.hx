package;

import Controls;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;

class Save
{
	public static var ghostTapping:Bool = true;
	public static var flashing:Bool = true;
	public static var antialiasing:Bool = true;
	public static var noteSplash:Bool = true;

	public static var modSelected:String = "";

	public static function saveSettings()
	{
		// saveSettings();
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.antialiasing = antialiasing;
		FlxG.save.data.noteSplash = noteSplash;

		FlxG.save.data.modSelected = modSelected;

		FlxG.save.flush();
	}

	public static function loadSettings()
	{
		// loadSettings();
		if (FlxG.save.data.ghostTapping != null)
			ghostTapping = FlxG.save.data.ghostTapping;
		if (FlxG.save.data.flashing != null)
			flashing = FlxG.save.data.flashing;
		if (FlxG.save.data.antialiasing != null)
			antialiasing = FlxG.save.data.antialiasing;
		if (FlxG.save.data.noteSplash != null)
			noteSplash = FlxG.save.data.noteSplash;

		if (FlxG.save.data.modSelected != null)
			modSelected = FlxG.save.data.modSelected;
	}
}
