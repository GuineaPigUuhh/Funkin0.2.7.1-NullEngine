package script;

import SScript;
import flixel.FlxG;

class NewScript extends SScript
{
	public function new(filePath:String, ?preset:Bool = true)
	{
		super(filePath, preset);
		traces = false;
	}

	override public function preset()
	{
		super.preset();

		// other Types
		set('add', FlxG.state.add);
		set('destroy', FlxG.state.destroy);
		set('remove', FlxG.state.remove);

		// HAXE
		set('Type', Type);
		set('Math', Math);
		set('Std', Std);
		set('Date', Date);

		// FLIXEL
		set('FlxG', FlxG);
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

		// GAME
		set('Character', Character);
		set('PlayState', PlayState);
		set('Alphabet', Alphabet);
		set('Save', Save);
		set("Paths", Paths);
		set("ModPaths", ModPaths);
		set("MusicBeatState", MusicBeatState);
	}
}
