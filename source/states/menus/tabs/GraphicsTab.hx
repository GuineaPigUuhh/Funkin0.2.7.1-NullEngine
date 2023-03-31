package states.menus.tabs;

import flixel.FlxG;
import states.menus.tabs.Base;

class GraphicsTab extends Base
{
	public override function updatePrefs()
	{
		options = [
			{
				name: "Antialiasing",
				value: "antialiasing",
				desc: "will make the sprites anti-aliased.",
				type: "Bool"
			},
			{
				name: "Framerate",
				value: "framerate",
				desc: "it will change the FPS limit, warning if you use a high FPS limit it may happen that when you run a function it runs twice.",
				type: "Int",
				onChange: function()
				{
					if (FlxG.save.data.framerate != null)
					{
						FlxG.drawFramerate = FlxG.save.data.framerate;
						FlxG.updateFramerate = FlxG.save.data.framerate;
					}
				},
				misc: {
					min: 30,
					max: 120,
					scrollSpeed: 0.06,
					addNumber: 10,
				}
			}
		];
	}
}
