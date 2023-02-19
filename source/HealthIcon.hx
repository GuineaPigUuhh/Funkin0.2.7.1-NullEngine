package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import modding.ModPaths;
import openfl.utils.Assets as OpenFlAssets;

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

	/**
	 * this is used to update the animation
	 */
	public var getVar:String;

	public function new(curCharacter:String = 'face', isPlayer:Bool = false)
	{
		super();

		this.curCharacter = curCharacter;
		this.isPlayer = isPlayer;
		scrollFactor.set();

		changeIcon(curCharacter);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		angle = FlxMath.lerp(0, angle, FlxMath.bound(1 - (elapsed * 3), 0, 1));

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function updateAnim(health:Float)
	{
		if (isPlayer)
		{
			if (health < 20) // boyfriend losing
			{
				playAnimation(getVar + "-losing");
			}
			else
			{
				playAnimation(getVar);
			}
		}
		else
		{
			if (health > 80) // dad Losing
			{
				playAnimation(getVar + "-losing");
			}
			else
			{
				playAnimation(getVar);
			}
		}
	}

	public function changeIcon(curCharacter:String = 'face')
	{
		var path:String = 'characters/icons/${curCharacter}';

		loadGraphic(CoolUtil.configGraphic(path));
		loadGraphic(CoolUtil.configGraphic(path), true, 150, 150);

		animation.add(curCharacter, [0], 0, false, isPlayer);
		animation.add(curCharacter + "-losing", [1], 0, false, isPlayer);
		animation.play(curCharacter);

		if (curCharacter.endsWith('-pixel'))
			antialiasing = false;
		else
			antialiasing = Save.antialiasing;
	}

	public function playFrame(num:Int)
	{
		animation.curAnim.curFrame = num;
	}

	public function playAnimation(name:String)
	{
		animation.play(name);
	}

	var iconBopNumber:Float = 22;

	public function iconBop(_beat:Int, player:Bool)
	{
		scale.set(1.15, 1.15);
		updateHitbox();

		FlxTween.tween(scale, {x: 1, y: 1}, Conductor.crochet / 2000, {ease: FlxEase.quadOut});

		if (_beat % 4 == 0)
		{
			angle = (player == true ? -iconBopNumber : iconBopNumber);
		}
	}
}
