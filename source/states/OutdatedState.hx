package states;

import dependency.MusicBeatState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import states.menus.MainMenuState;

class OutdatedState extends MusicBeatState
{
	var version:String = "";
	var type:String = "";
	var newFeatures:Array<String>;

	public function new(ver:String, ty:String, features:Array<String>)
	{
		super();
		version = ver;
		type = ty;
		newFeatures = features;
	}

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var txt:FlxText = new FlxText(0, 0, FlxG.width, "", 32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		txt.text = 'Your Null Engine Is Out of Date - Press [Enter] To Go To Website';
		txt.text += '\n- Null Engine [${version} • ${type}] -';
		txt.text += '\nNew Features';

		for (f in newFeatures)
		{
			txt.text += '\n- $f';
		}
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.openURL("https://github.com/GuineaPigCode/FNF-NullEngine");
		}
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
