package game.null_stuff;

import flixel.FlxG;
import game.scripting.*;
import game.sprites.Alphabet;
import game.sprites.Character;
import hscript.*;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class NullScript extends Script
{
	public var interp:Interp;
	public var parser:Parser;

	public override function onCreate(path:String)
	{
		super.onCreate(path);

		interp = new Interp();
		parser = new Parser();

		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;

		createPreset = true;
	}

	public override function onLoad()
	{
		var getScript = parser.parseString(File.getContent(path));
		interp.execute(getScript);
	}

	public override function set(name:String, value:Dynamic)
		interp.variables.set(name, value);

	public override function get(name:String)
		return interp.variables.get(name);

	public override function onCall(name:String, value:Array<Dynamic>)
	{
		if (interp == null)
			return null;

		if (interp.variables.exists(name))
		{
			var functionH = get(name);

			var result = null;
			result = Reflect.callMethod(null, functionH, value);
			return result;
		}
		return null;
	}

	public override function preset()
	{
		var daState = FlxG.state;

		set("add", daState.add);
		set("destroy", daState.destroy);
		set("remove", daState.remove);

		// haxe
		set('Type', Type);
		set('Math', Math);
		set('Std', Std);
		set('Date', Date);

		// flixel
		set('FlxG', flixel.FlxG);
		set('FlxBasic', flixel.FlxBasic);
		set('FlxObject', flixel.FlxObject);
		set('FlxSprite', flixel.FlxSprite);
		set('FlxSound', flixel.system.FlxSound);
		set('FlxSort', flixel.util.FlxSort);
		set('FlxStringUtil', flixel.util.FlxStringUtil);
		set('FlxState', flixel.FlxState);
		set('FlxSubState', flixel.FlxSubState);
		set('FlxText', flixel.text.FlxText);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxTrail', flixel.addons.effects.FlxTrail);

		// funkin
		set('Alphabet', game.sprites.Alphabet);
		set('CoolUtil', utils.CoolUtil);
		set('Character', game.sprites.Character);
		set('Conductor', game.Conductor);
		// set('PlayState', PlayState);
		set('Paths', dependency.Paths);
		set('ClientPrefs', dependency.ClientPrefs);
		set('Logs', dependency.Logs);

		set('createCustom', dependency.Logs.create);

		set('createLog', dependency.Logs.log);
		set('createError', dependency.Logs.error);
		set('createWarning', dependency.Logs.warning);
	}
}
