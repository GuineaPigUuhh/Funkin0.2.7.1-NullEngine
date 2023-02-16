package;

#if desktop
import DiscordClient;
#end
import MusicBeatState;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import script.NewScript;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if hscript
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
#end

class CustomState extends MusicBeatState
{
	public static var daState:String = "";

	var script:NewScript;

	override function create()
	{
		script = new NewScript(Paths.hscript('data/states/' + daState));
		script.set("curStep", curStep);
		script.set("curBeat", curBeat);

		script.call('onCreate', []);

		super.create();
	}

	override function update(elapsed:Float)
	{
		script.call('onUpdate', [elapsed]);

		super.update(elapsed);
	}

	override function beatHit()
	{
		script.call('onBeatHit', [curBeat]);

		super.beatHit();
	}

	override function stepHit()
	{
		script.call('onStepHit', [curStep]);

		super.stepHit();
	}
}
