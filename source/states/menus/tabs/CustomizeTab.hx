package states.menus.tabs;

import flixel.FlxG;
import states.menus.tabs.Base;

class CustomizeTab extends Base
{
	public override function updatePrefs()
	{
		options = [
			{
				name: "Flashing",
				value: "flashing",
				desc: "Turn off any lights that might harm you.",
				type: "Bool"
			},
			{
				name: "NoteSplash",
				value: "noteSplash",
				desc: "when hitting a note and getting a sick, the notesplash will appear.",
				type: "Bool"
			},
			{
				name: "FPS Visible",
				value: "fpsVisible",
				desc: "will make the fps visible in the info.",
				type: "Bool"
			},
			{
				name: "RAM Visible",
				value: "memVisible",
				desc: "will make the memory visible in the info.",
				type: "Bool"
			},
			{
				name: "Watermark",
				value: "watermark",
				desc: "will make the watermark visible in the info.",
				type: "Bool"
			}
		];
	}
}
