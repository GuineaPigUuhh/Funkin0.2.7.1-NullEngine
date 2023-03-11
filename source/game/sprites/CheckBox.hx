package game.sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import dependency.Paths;
import utils.CoolUtil;

class CheckBox extends FlxSprite
{
	public var value(default, set):Bool;

	public var sprTracker:FlxSprite;
	public var copyAlpha:Bool = true;

	public var xAdd:Float = 0;
	public var yAdd:Float = 0;

	public function new(x:Float, y:Float, ?daValue:Bool = false)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('menus/options/checkBox');
		animation.addByPrefix("true", "checkTrueAnim", 24, false);
		animation.addByPrefix("false", "checkFalseAnim", 24, false);

		antialiasing = FlxG.save.data.antialiasing;

		setGraphicSize(Std.int(width * 0.6));
		updateHitbox();

		if (daValue != null)
			value = daValue;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
		{
			setPosition(sprTracker.x - 220 + xAdd, sprTracker.y - 55 + yAdd);
			if (copyAlpha)
			{
				alpha = sprTracker.alpha;
			}
		}

		switch (animation.curAnim.name)
		{
			case 'true':
				offset.set();
			case 'false':
				offset.set(-16, -6);
		}
	}

	function set_value(susValue:Bool)
	{
		animation.play(Std.string(susValue));

		return susValue;
	}
}
