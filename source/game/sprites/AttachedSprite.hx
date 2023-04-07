package game.sprites;

import flixel.FlxSprite;

class AttachedSprite extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public var addX:Float = 0;
	public var addY:Float = 0;

	public var copyAlpha:Bool = false;
	public var copyScroll:Bool = false;

	public override function new(daSprite:FlxSprite)
	{
		sprTracker = daSprite;

		super(0, 0);
	}

	public override function update(elapsed:Float)
	{
		if (sprTracker != null)
		{
			setPosition(sprTracker.x + addX, sprTracker.y + addY);
			if (copyAlpha)
			{
				alpha = sprTracker.alpha;
			}
			if (copyScroll)
			{
				scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);
			}
		}
		else
		{
		}

		super.update(elapsed);
	}
}
