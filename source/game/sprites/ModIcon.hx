package game.sprites;

import flixel.FlxSprite;
import states.menus.ModMenuState;

class ModIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var daMod:String = "";

	public function new(daMod:String)
	{
		super(0, 0);

		this.daMod = daMod;

		var hahaMod:String = this.daMod;

		loadGraphic(ModMenuState.modFolder + "/" + hahaMod + "/_icon.png");
	}

	override function update(elapsed:Float)
	{
		if (sprTracker != null)
		{
			// setPosition(sprTracker.x, sprTracker.y);
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
			alpha = sprTracker.alpha;
		}

		super.update(elapsed);
	}
}
