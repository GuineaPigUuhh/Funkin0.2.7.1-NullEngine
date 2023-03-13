package game.null_stuff;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class NullClickableSprite extends FlxSprite
{
	public var callBack:() -> Void;

	public override function new(x:Float, y:Float, callBack:() -> Void)
	{
		this.callBack = callBack;

		super(x, y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(this))
		{
			if (FlxG.mouse.justPressed)
			{
				// lol holyshit hard code!?!??!?!
				callBack();
			}
		}
	}
}
