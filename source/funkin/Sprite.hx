package funkin;

import flixel.FlxSprite;
import modding.ModPaths;
import Paths;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Sprite extends FlxSprite
{
	var vanillaPath:Bool = false;

	public var sprTracker:FlxSprite;
	public var copyAlpha:Bool = false;
	public var copyVisible:Bool = false;
	public var copyScroll:Bool = false;

	public var updateTracker:Bool = false;

	public var animatedSprite:Bool = false;

	public var inicialX:Float = 0;
	public var inicialY:Float = 0;

	public var animOffsets:Map<String, Array<Float>>;

	public function new(x:Float = 0, y:Float = 0, graphic:String = "error", xScroll:Float = 0, yScroll:Float = 0)
	{
		super(x, y);

		scrollFactor.x = xScroll;
		scrollFactor.y = yScroll;

		inicialX = x;
		inicialY = y;

		if (!updateTracker)
		{
			updateSprTracker();
		}
		else
		{
			// nothing
		}

		setGraphic(graphic);
	}

	override function update(elapsed:Float)
	{
		if (updateTracker)
			updateSprTracker();
		else
		{
			// nothing
		}

		super.update(elapsed);
	}

	function updateSprTracker()
	{
		if (sprTracker != null)
		{
			setPosition(sprTracker.x, sprTracker.y);
			if (copyScroll == true)
			{
				scrollFactor.x = sprTracker.scrollFactor.x;
				scrollFactor.y = sprTracker.scrollFactor.y;
			}

			if (copyAlpha == true)
				alpha = sprTracker.alpha;
			if (copyVisible == true)
				visible = sprTracker.visible;
		}
	}

	public function setGraphic(graphic:String = "error")
	{
		var path:String = ModPaths.image(graphic);
		if (!FileSystem.exists(path))
		{
			vanillaPath = true;
			path = Paths.image(graphic);
		}

		var xmlLocal:String = ModPaths.file("images/" + graphic + ".xml");
		if (!FileSystem.exists(xmlLocal))
			Paths.file("images/" + graphic + ".xml");

		if (FileSystem.exists(xmlLocal))
		{
			animatedSprite = true;

			var tex = ModPaths.getSparrowAtlas(graphic);
			if (vanillaPath = true)
				tex = Paths.getSparrowAtlas(graphic);
			frames = tex;
		}

		if (animatedSprite == false)
			loadGraphic(path);
	}

	public function playAnim(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0)
	{
		animation.play(name, force, reversed, frame);

		var getOffset = animOffsets.get(name);
		if (animOffsets.exists(name))
			offset.set(getOffset[0], getOffset[1]);
		else
			offset.set(0, 0);
	}

	public function addOffset(name:String, array:Array<Float>)
		animOffsets[name] = array;
}
