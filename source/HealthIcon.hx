package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
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

	var file:String = "";

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
		file = Paths.getPreloadPath('characters/${curCharacter}/icon.png');

		if (OpenFlAssets.exists(Paths.getModPath('characters/${curCharacter}/icon.png')))
			file = Paths.getModPath('characters/${curCharacter}/icon.png');

		if (OpenFlAssets.exists(Paths.image('icons/${curCharacter}')))
			file = Paths.image('icons/${curCharacter}');

		if (OpenFlAssets.exists(Paths.getModPath('images/icons/${curCharacter}')))
			file = Paths.getModPath('images/icons/${curCharacter}');

		if (!OpenFlAssets.exists(file))
			file = Paths.getPreloadPath('characters/face/icon.png');

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

	public function beatHitIcon()
	{
		scale.set(1.1, 1.1);
		updateHitbox();

		FlxTween.tween(scale, {x: 1, y: 1}, Conductor.crochet / 2000, {ease: FlxEase.circOut});
	}
}
