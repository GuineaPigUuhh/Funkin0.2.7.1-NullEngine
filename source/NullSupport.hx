package;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flash.media.Sound;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import modding.ModPaths;
import openfl.display.BitmapData;

class NullSupport
{
	public static var imagesLoaded:Map<String, Bool> = new Map<String, Bool>();

	static public function addModGraphic(key:String):FlxGraphic
	{
		if (FileSystem.exists(ModPaths.image(key)))
		{
			if (!imagesLoaded.exists(key))
			{
				var newBitmap:BitmapData = BitmapData.fromFile(ModPaths.image(key));
				var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, key);
				newGraphic.persist = true;
				FlxG.bitmap.addGraphic(newGraphic);
			}

			return FlxG.bitmap.get(key);
		}
		return null;
	}
}
