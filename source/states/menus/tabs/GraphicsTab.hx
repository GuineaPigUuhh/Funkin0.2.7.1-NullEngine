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
				name: "StringTest",
				value: "stringTest",
				desc: "",
				type: "String",
				stringConfig: {array: ["low", "medium", "high"], scrollSpeed: 0.08}
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
				intConfig: {
					min: 30,
					max: 120,
					scrollSpeed: 0.06,
					addNumber: 10,
				}
			}
		];
	}
}
