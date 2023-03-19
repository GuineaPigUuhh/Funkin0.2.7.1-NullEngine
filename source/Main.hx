package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

using StringTools;

class Main extends Sprite
{
	var gameOptions = {
		width: 1280,
		height: 720,
		initialState: states.TitleState,
		zoom: -1.0,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	};

	public static var nullType:String = "beta";
	public static var nullVersion:String = "0.3.4";

	public static var nullText:String = nullVersion + " " + "[" + nullType.toUpperCase() + "]";

	public static var instance:Main;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		instance = this;

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (gameOptions.zoom == -1)
		{
			var ratioX:Float = stageWidth / gameOptions.width;
			var ratioY:Float = stageHeight / gameOptions.height;

			gameOptions.zoom = Math.min(ratioX, ratioY);

			gameOptions.width = Math.ceil(stageWidth / gameOptions.zoom);
			gameOptions.height = Math.ceil(stageHeight / gameOptions.zoom);
		}

		addChild(new game.null_stuff.NullGm(gameOptions.width, gameOptions.height, gameOptions.initialState, #if (flixel < "5.0.0") gameOptions.zoom, #end
			gameOptions.framerate, gameOptions.framerate, gameOptions.skipSplash, gameOptions.startFullscreen));

		#if !mobile
		addChild(new game.null_stuff.NullInfo(10, 3));
		#end
	}
}
