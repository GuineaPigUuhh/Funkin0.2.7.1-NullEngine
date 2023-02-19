package;

import flixel.math.FlxMath;
import haxe.Timer;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import sys.io.File;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class NullInfo extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont("assets/fonts/vcr.ttf").fontName, 14, 0xFFFFFFFF, true);
		autoSize = LEFT;
		multiline = true;
		alpha = 0.65;
		text = "";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentCount != cacheCount && visible)
		{
			updateText();
		}

		cacheCount = currentCount;
	}

	function updateText()
	{
		var memoryMegas:Float = 0;
		memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));

		text = "FPS: " + currentFPS + "\n";

		text += "RAM: " + memoryMegas + " MB\n";

		text += "Null Engine v" + File.getContent("buildNumber.txt");

		text += "\n";
	}
}
