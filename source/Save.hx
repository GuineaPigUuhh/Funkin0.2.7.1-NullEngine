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
	public static var isDownscroll:Bool = false;
	public static var middleScroll:Bool = false;

	public static var freeplayCutscene:Bool = false;

	public static var modSelected:String = "";

	public static var keyUP:String = 'UP';
	public static var keyDOWN:String = 'DOWN';
	public static var keyLEFT:String = 'LEFT';
	public static var keyRIGHT:String = 'RIGHT';

	public static var keyUPalt:String = 'W';
	public static var keyDOWNalt:String = 'S';
	public static var keyLEFTalt:String = 'A';
	public static var keyRIGHTalt:String = 'D';

	public static var staticArrowsAlpha:Bool = true;
	public static var susArrowsAlpha:Bool = true;

	public static function saveSettings()
	{
		// saveSettings();

		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.antialiasing = antialiasing;
		FlxG.save.data.noteSplash = noteSplash;
		FlxG.save.data.isDownscroll = isDownscroll;
		FlxG.save.data.freeplayCutscene = freeplayCutscene;
		FlxG.save.data.middleScroll = middleScroll;

		FlxG.save.data.modSelected = modSelected;

		FlxG.save.data.keyUP = keyUP;
		FlxG.save.data.keyDOWN = keyDOWN;
		FlxG.save.data.keyLEFT = keyLEFT;
		FlxG.save.data.keyRIGHT = keyRIGHT;

		FlxG.save.data.keyUPalt = keyUPalt;
		FlxG.save.data.keyDOWNalt = keyDOWNalt;
		FlxG.save.data.keyLEFTalt = keyLEFTalt;
		FlxG.save.data.keyRIGHTalt = keyRIGHTalt;

		FlxG.save.data.staticArrowsAlpha = staticArrowsAlpha;
		FlxG.save.data.susArrowsAlpha = susArrowsAlpha;

		FlxG.save.flush();

		CoolLogSystem.log("Save Settings", CoolLogSystem.CYAN);
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
		if (FlxG.save.data.isDownscroll != null)
			isDownscroll = FlxG.save.data.isDownscroll;
		if (FlxG.save.data.freeplayCutscene != null)
			freeplayCutscene = FlxG.save.data.freeplayCutscene;
		if (FlxG.save.data.middleScroll != null)
			middleScroll = FlxG.save.data.middleScroll;

		if (FlxG.save.data.modSelected != null)
			modSelected = FlxG.save.data.modSelected;

		if (FlxG.save.data.keyUP != null)
			keyUP = FlxG.save.data.keyUP;
		if (FlxG.save.data.keyDOWN != null)
			keyDOWN = FlxG.save.data.keyDOWN;
		if (FlxG.save.data.keyLEFT != null)
			keyLEFT = FlxG.save.data.keyLEFT;
		if (FlxG.save.data.keyRIGHT != null)
			keyRIGHT = FlxG.save.data.keyRIGHT;

		if (FlxG.save.data.keyUPalt != null)
			keyUPalt = FlxG.save.data.keyUPalt;
		if (FlxG.save.data.keyDOWNalt != null)
			keyDOWNalt = FlxG.save.data.keyDOWNalt;
		if (FlxG.save.data.keyLEFTalt != null)
			keyLEFTalt = FlxG.save.data.keyLEFTalt;
		if (FlxG.save.data.keyRIGHTalt != null)
			keyRIGHTalt = FlxG.save.data.keyRIGHTalt;

		if (FlxG.save.data.staticArrowsAlpha != null)
			staticArrowsAlpha = FlxG.save.data.staticArrowsAlpha;
		if (FlxG.save.data.susArrowsAlpha != null)
			susArrowsAlpha = FlxG.save.data.susArrowsAlpha;

		CoolLogSystem.log("Load Settings", CoolLogSystem.CYAN);
	}
}
