package;

import Paths;
import flixel.FlxG;
import haxe.io.Path;
import sys.FileSystem;

using StringTools;

#if hscript
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
#end

class HScript extends MusicBeatState
{
	public static var parser:Parser;

	public var hscript:Interp;

	var SONG:Song.SwagSong;

	public function new(file:String)
	{
		parser = new hscript.Parser();
		hscript = new hscript.Interp();

		var fileExport = Paths.hscript(file);

		hscript.variables.set("remove", remove);
		hscript.variables.set("destroy", destroy);
		hscript.variables.set("add", add);

		hscript.variables.set("DiscordClient", DiscordClient);
		hscript.variables.set("FlxG", flixel.FlxG);
		hscript.variables.set("FlxButton", flixel.ui.FlxButton);
		hscript.variables.set("Character", Character);
		hscript.variables.set("FlxGame", flixel.FlxGame);
		hscript.variables.set("FlxObject", flixel.FlxObject);
		hscript.variables.set("FlxSprite", flixel.FlxSprite);
		hscript.variables.set("FlxState", flixel.FlxState);
		hscript.variables.set("FlxSubState", flixel.FlxSubState);
		hscript.variables.set("FlxGridOverlay", flixel.addons.display.FlxGridOverlay);
		hscript.variables.set("FlxTrail", flixel.addons.effects.FlxTrail);
		hscript.variables.set("Paths", Paths);
		hscript.variables.set("PlayState", PlayState);
		hscript.variables.set("FlxTrail", flixel.addons.effects.FlxTrail);
		hscript.variables.set("FlxTrailArea", flixel.addons.effects.FlxTrailArea);
		hscript.variables.set("FlxEffectSprite", flixel.addons.effects.chainable.FlxEffectSprite);
		hscript.variables.set("FlxWaveEffect", flixel.addons.effects.chainable.FlxWaveEffect);
		hscript.variables.set("FlxTransitionableState", flixel.addons.transition.FlxTransitionableState);
		hscript.variables.set("FlxAtlas", flixel.graphics.atlas.FlxAtlas);
		hscript.variables.set("FlxAtlasFrames", flixel.graphics.frames.FlxAtlasFrames);
		hscript.variables.set("FlxMath", flixel.math.FlxMath);
		hscript.variables.set("FlxRect", flixel.math.FlxRect);
		hscript.variables.set("MusicBeatState", MusicBeatState);
		hscript.variables.set("FlxSound", flixel.system.FlxSound);
		hscript.variables.set("FlxText", flixel.text.FlxText);
		hscript.variables.set("FlxEase", flixel.tweens.FlxEase);
		hscript.variables.set("FlxTween", flixel.tweens.FlxTween);

		hscript.variables.set("curStep", curStep);
		hscript.variables.set("curBeat", curBeat);

		hscript.variables.set("update", function(elapsed:Float)
		{
		});
		hscript.variables.set("create", function()
		{
		});
		hscript.variables.set("stepHit", function()
		{
		});
		hscript.variables.set("beatHit", function()
		{
		});

		hscript.execute(parser.parseString(fileExport));

		super();
	}

	public function addVariable(addString:String, addValue:Dynamic)
	{
		hscript.variables.set(addString, addValue);
	}

	public function callOnHscript(functionToCall:String, ?params:Array<Any>):Dynamic
	{
		if (hscript == null)
		{
			return null;
		}
		if (hscript.variables.exists(functionToCall))
		{
			var functionH = hscript.variables.get(functionToCall);
			if (params == null)
			{
				var result = null;
				result = functionH();
				return result;
			}
			else
			{
				var result = null;
				result = Reflect.callMethod(null, functionH, params);
				return result;
			}
		}
		return null;
	}
}
