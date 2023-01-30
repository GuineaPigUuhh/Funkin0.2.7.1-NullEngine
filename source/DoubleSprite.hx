package;

import flixel.FlxSprite;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class DoubleSprite extends FlxSprite
{
	var vanillaPath:Bool = false;

	public var animatedSprite:Bool = false;

	public var inicialX:Float = 0;
	public var inicialY:Float = 0;

	public var animOffsets:Map<String, Array<Dynamic>>;

	public function new(x:Float = 0, y:Float = 0, xScroll:Float = 0, yScroll:Float = 0, graphic:String = "error")
	{
		super(x, y);

		scrollFactor.x = xScroll;
		scrollFactor.y = yScroll;

		inicialX = x;
		inicialY = y;

		setGraphic(graphic);
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
		}

		if (animatedSprite == false)
			loadGraphic(path);
	}
}
