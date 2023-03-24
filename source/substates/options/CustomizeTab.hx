package substates.options;

import flixel.FlxG;
import substates.options.Base;

class CustomizeTab extends Base
{
	public override function updatePrefs()
	{
		options = [
			{name: "Flashing", value: "flashing", type: "Bool"},
			{name: "NoteSplash", value: "noteSplash", type: "Bool"}
		];
	}
}
