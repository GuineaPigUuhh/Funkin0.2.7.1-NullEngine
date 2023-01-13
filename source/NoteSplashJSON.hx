package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

typedef SplashJSON =
{
	public var image:String;
	public var offsets:Array<Float>;
	public var alpha:Float;
}

class NoteSplashJSON
{
	public static function getNoteSplashJson(path:String)
	{
		var rawJson:String = null;
		if (OpenFlAssets.exists("assets/shared/images/splashs/" + path + ".json"))
		{
			rawJson = Assets.getText("assets/shared/images/splashs/" + path + ".json");
		}

		if (rawJson != null && rawJson.length > 0)
		{
			return cast Json.parse(rawJson);
		}
		return null;
	}
}
