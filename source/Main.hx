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
		gameWidth: 1280,
		gameHeight: 720,
		initialState: TitleState,
		zoom: -1.0,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	};

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

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
			var ratioX:Float = stageWidth / gameOptions.gameWidth;
			var ratioY:Float = stageHeight / gameOptions.gameHeight;
			
			gameOptions.zoom = Math.min(ratioX, ratioY);

			gameOptions.gameWidth = Math.ceil(stageWidth / gameOptions.zoom);
			gameOptions.gameHeight = Math.ceil(stageHeight / gameOptions.zoom);
		}

		addChild(new FlxGame(gameOptions.gameWidth, gameOptions.gameHeight, gameOptions.initialState,#if (flixel < "5.0.0") gameOptions.zoom,#end gameOptions.framerate, gameOptions.framerate, gameOptions.skipSplash, gameOptions.startFullscreen));

		#if !mobile
		addChild(new FPS(10, 3));
		#end
	}
}
