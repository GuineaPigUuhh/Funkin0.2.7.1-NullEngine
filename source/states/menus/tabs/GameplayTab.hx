package states.menus.tabs;

import flixel.FlxG;
import states.menus.tabs.Base;

class GameplayTab extends Base
{
	public override function updatePrefs()
	{
		options = [
			{
				name: "GhostTapping",
				value: "ghostTapping",
				desc: "You can't make a mistake on purpose, only when you forget to press a note.",
				type: "Bool"
			},
			{
				name: "DownScroll",
				value: "isDownscroll",
				desc: "changes notes to guitar hero-like bass.",
				type: "Bool"
			},
			{
				name: "MiddleScroll",
				value: "middleScroll",
				desc: "change the notes to the middle.",
				type: "Bool"
			},
			{
				name: "Freeplay Cutscene",
				value: "freeplayCutscene",
				desc: "the cutscenes will appear in freeplay.",
				type: "Bool"
			}
		];
	}
}
