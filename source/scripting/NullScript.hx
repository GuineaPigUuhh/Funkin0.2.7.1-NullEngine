package scripting;

import flixel.FlxG;
import hscript.*;
import scripting.*;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class NullScript extends Script
{
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

		var func = get(name);
		if (func != null)
		{
			if (value != null && value.length > 0)
				return Reflect.callMethod(null, func, value);
			else
				return func;
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
		set('Alphabet', Alphabet);
		set('CoolUtil', CoolUtil);
		set('Character', Character);
		set('Conductor', Conductor);
		// set('PlayState', PlayState);
		set('Paths', Paths);

		set('Logs', Logs);

		set('createLog', Logs.log);
		set('createError', Logs.error);
		set('createWarning', Logs.warning);
	}
}
