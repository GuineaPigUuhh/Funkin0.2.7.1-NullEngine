package script;

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

	public var hscript:Interp;

	public var scriptToExecute:String = "";

	public var isString:Bool = false;
	public var isNull:Bool = false;

	public function new(scriptToExecute:String, isString:Bool = false, isNull:Bool = false)
	{
		this.scriptToExecute = scriptToExecute;

		this.isNull = isNull;
		this.isString = isString;

		executeScript(this.scriptToExecute);

		super();
	}

	function executeScript(script:String)
	{
		parser = new hscript.Parser();
		hscript = new hscript.Interp();

		parser.allowJSON = true;
		parser.allowTypes = true;
		parser.allowMetadata = true;

		if (isNull == false)
			addDefaultVariables();

		if (isString == false)
		{
			var filePath = Paths.hscript(script);
			if (FileSystem.exists(ModPaths.hscript(script)))
			{
				filePath = ModPaths.hscript(script);
			}

			if (FileSystem.exists(filePath))
			{
				var getFile:String = File.getContent(filePath);
				hscript.execute(parser.parseString(getFile));
			}
		}
		else
		{
			hscript.execute(parser.parseString(script));
		}
	}

	function addDefaultVariables()
	{
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
		setVariable("FlxBackdrop", FlxBackdrop);

		// game states
		setVariable("Character", Character);
		setVariable("Boyfriend", Boyfriend);
		setVariable("DiscordClient", DiscordClient);
		setVariable("MusicBeatState", MusicBeatState);
		setVariable("Paths", Paths);
		setVariable("ModPaths", ModPaths);
		setVariable("PlayState", PlayState);

		setVariable("traceHScript", traceHScript);
	}

	function traceHScript(message:String, title:String)
	{
		lime.app.Application.current.window.alert(title, message);
	}

	public function setVariable(addString:String, addValue:Dynamic) // add custom variables of state
	{
		hscript.variables.set(addString, addValue);
	}

	public function getVariable(name:String)
	{
		return hscript.variables.get(name);
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
