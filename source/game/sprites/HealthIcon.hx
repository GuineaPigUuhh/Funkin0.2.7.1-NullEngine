package game.sprites;

import dependency.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.utils.Assets as OpenFlAssets;
import states.PlayState;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var curCharacter:String = 'face';
	public var isPlayer:Bool = false;

	public function new(curCharacter:String = 'face', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

		scrollFactor.set();

		changeIcon(curCharacter);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function updateAnim(health:Float)
	{
		if (isPlayer)
		{
			if (health < 20) // boyfriend losing
			{
				playAnim(curCharacter + "-losing");
			}
			else
			{
				playAnim(curCharacter);
			}
		}
		else
		{
			if (health > 80) // dad Losing
			{
				playAnim(curCharacter + "-losing");
			}
			else
			{
				playAnim(curCharacter);
			}
		}
	}

	public function changeIcon(curCharacter:String = 'face')
	{
		this.curCharacter = curCharacter;
		var path:String = 'characters/icons/${curCharacter}';

		loadGraphic(Paths.image(path), true, 150, 150);

		animation.add(curCharacter, [0], 0, false, isPlayer);
		animation.add(curCharacter + "-losing", [1], 0, false, isPlayer);

		animation.play(curCharacter);

		antialiasing = checkAntialiasing();
	}

	function checkAntialiasing()
	{
		var noAntialiasingChars:Array<String> = ["senpai", "senpai-angry", "spirit", "bf-pixel"];
		var varAnti = FlxG.save.data.antialiasing;

		if (noAntialiasingChars.contains(curCharacter))
		{
			return false;
		}

		return varAnti;
	}

	public function playAnim(name:String)
	{
		animation.play(name);
	}

	var iconBop:Float = 1.25;

	private var bopTween:FlxTween = null;

	public function bop()
	{
		scale.set(iconBop, iconBop);
		if (bopTween != null)
			bopTween.cancel();

		bopTween = FlxTween.tween(scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.circOut});
		// updateHitbox();
	}

	var iconOffset = 26;

	public function setIconX()
	{
		var healthballer = PlayState.instance.healthBar;
		if (isPlayer)
			x = healthballer.x + (healthballer.width * (FlxMath.remapToRange(healthballer.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		else
			x = healthballer.x + (healthballer.width * (FlxMath.remapToRange(healthballer.percent, 0, 100, 100, 0) * 0.01)) - (width - iconOffset);
	}
}
