package script;

import ModPaths;
import Paths;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.io.Path;

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

class HScript extends MusicBeatState
{
	public static var parser:Parser;

	public var interp:Interp;

	public var scriptToExecute:String = "";
	public var executedScript:Bool = false;

	public var isString:Bool = false;

	public function new(scriptToExecute:String, isString:Bool = false)
	{
		this.scriptToExecute = scriptToExecute;
		this.isString = isString;

		executeScript(this.scriptToExecute);

		super();
	}

	function executeScript(script:String)
	{
		parser = new hscript.Parser();
		interp = new hscript.Interp();

		parser.allowJSON = true;
		parser.allowTypes = true;
		parser.allowMetadata = true;

		if (isString == false)
		{
			var isMod:Bool = true;
			var filePath = ModPaths.hscript(script);
			if (!FileSystem.exists(filePath))
			{
				isMod = false;
				filePath = Paths.hscript(script);
			}

			addDefaultVariables(isMod);

			if (FileSystem.exists(filePath))
			{
				executedScript = true;

				var getFile:String = File.getContent(filePath);
				interp.execute(parser.parseString(getFile));
			}
		}
		else
		{
			addDefaultVariables(false);

			executedScript = true;
			interp.execute(parser.parseString(script));
		}
	}

	function addDefaultVariables(isMod:Bool)
	{
		setVariable("add", FlxG.state.add);
		setVariable("destroy", FlxG.state.destroy);
		setVariable("remove", FlxG.state.remove);

		// Flx Items
		setVariable("FlxG", FlxG);
		setVariable("FlxObject", FlxObject);
		setVariable("FlxSprite", FlxSprite);
		setVariable("FlxState", FlxState);
		setVariable("FlxSubState", FlxSubState);
		setVariable("FlxGridOverlay", FlxGridOverlay);
		setVariable("FlxTrail", FlxTrail);
		setVariable("FlxTrailArea", FlxTrailArea);
		setVariable("FlxEffectSprite", FlxEffectSprite);
		setVariable("FlxTransitionableState", FlxTransitionableState);
		setVariable("FlxMath", FlxMath);
		setVariable("FlxRect", FlxRect);
		setVariable("FlxSound", FlxSound);
		setVariable("FlxText", FlxText);
		setVariable("FlxEase", FlxEase);
		setVariable("FlxTween", FlxTween);
		setVariable("FlxTimer", FlxTimer);
		setVariable("FlxBackdrop", FlxBackdrop);

		// game states
		setVariable("Character", Character);
		setVariable("DiscordClient", DiscordClient);
		setVariable("MusicBeatState", MusicBeatState);
		setVariable("Paths", (isMod ? ModPaths : Paths));
		setVariable("PlayState", PlayState);

		setVariable("traceWindows", function(title:String, message:String)
		{
			lime.app.Application.current.window.alert(title, message);
		});
	}

	public function setVariable(setValue:String, value:Dynamic):Void // add custom variables of state
	{
		interp.variables.set(setValue, value);
	}

	public function getVariable(name:String)
	{
		return interp.variables.get(name);
	}

	public function call(functionToCall:String, ?params:Array<Any>):Dynamic
	{
		if (interp == null)
		{
			return null;
		}
		if (interp.variables.exists(functionToCall))
		{
			var functionH = interp.variables.get(functionToCall);
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
