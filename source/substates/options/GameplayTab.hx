package substates.options;

import flixel.FlxG;
import substates.options.Base;

class GameplayTab extends Base
{
	public override function updatePrefs()
	{
		options = [
			{name: "GhostTapping", value: "ghostTapping", type: "Bool"},
			{name: "DownScroll", value: "isDownscroll", type: "Bool"},
			{name: "MiddleScroll", value: "middleScroll", type: "Bool"},
			{name: "Freeplay Cutscene", value: "freeplayCutscene", type: "Bool"}
		];
	}
}
