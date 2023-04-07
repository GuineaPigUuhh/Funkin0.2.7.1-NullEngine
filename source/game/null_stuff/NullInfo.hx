package game.null_stuff;

import dependency.Paths;
import flixel.FlxG;
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
		defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont(Paths.font("vcr.ttf")).fontName, 14, 0xFFFFFFFF, true);
		autoSize = LEFT;
		multiline = true;
		alpha = 0.8;
		text = "";
		visible = true;

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

		if (visible)
		{
			updateText();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		cacheCount = currentCount;
	}

	function updateText()
	{
		var mem:Float = 0;
		mem = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));

		var memPeak:Float = 0;
		memPeak = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));

		if (mem > memPeak)
			memPeak = mem;

		text = "";
		if (FlxG.save.data.fpsVisible)
			text += currentFPS + " FPS\n";

		if (FlxG.save.data.memVisible)
			text += mem + " MB" + " • " + memPeak + " MB\n";
		if (FlxG.save.data.watermark)
			text += Main.nullText + "\n";
	}
}
