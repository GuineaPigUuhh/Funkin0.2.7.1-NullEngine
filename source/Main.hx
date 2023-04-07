package;

import dependency.ClientPrefs;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import game.DiscordClient;
import game.Highscore;
import game.PlayerSettings;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import states.TitleState;

using StringTools;

class Main extends Sprite
{
	var gameOptions = {
		width: 1280,
		height: 720,
		zoom: -1.0,
		framerate: 60
	};

	public static var nullType:String = "beta";
	public static var nullVersion:String = "0.3.5";

	public static var nullText:String = 'Null Engine v${nullVersion} [${nullType.toUpperCase()}]';

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
			removeEventListener(Event.ADDED_TO_STAGE, init);

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

		addChild(new game.null_stuff.NullGm(gameOptions.width, gameOptions.height, null, #if (flixel < "5.0.0") gameOptions.zoom, #end gameOptions.framerate,
			gameOptions.framerate, true, false));
		FlxG.switchState(new TitleState());

		#if !mobile
		addChild(new game.null_stuff.NullInfo(10, 3));
		#end
		initGameConfigs();
	}

	public function initGameConfigs()
	{
		PlayerSettings.init();
		FlxG.save.bind('settings', 'FNF-NullEngine');

		ClientPrefs.save();
		ClientPrefs.load();

		PlayerSettings.player1.controls.loadKeyBinds();
		Highscore.load();

		#if desktop
		DiscordClient.initialize();
		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
	}
}
