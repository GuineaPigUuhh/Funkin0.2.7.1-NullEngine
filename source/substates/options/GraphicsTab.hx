package substates.options;

import flixel.FlxG;
import substates.options.Base;

class GraphicsTab extends Base
{
	public override function updatePrefs()
	{
		options = [
			{name: "Antialiasing", value: "antialiasing", type: "Bool"},
			{
				name: "Framerate",
				value: "framerate",
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
