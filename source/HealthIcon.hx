package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

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

		this.curCharacter = curCharacter;
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

	public function changeIcon(curCharacter:String = 'face')
	{
		var file:String = Paths.image('icons/${curCharacter}');

		if (!OpenFlAssets.exists(file))
			curCharacter = 'face';

		loadGraphic(file);
		loadGraphic(file, true, 150, 150);

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

	public function beatHitIcon(floatshit:Float = 150)
	{
		scale.set(1.15, 1.15);
		FlxTween.tween(scale, {x: 1, y: 1}, Conductor.crochet / 2000);
		updateHitbox();
	}
}
