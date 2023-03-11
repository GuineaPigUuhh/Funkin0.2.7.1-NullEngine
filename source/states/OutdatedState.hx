package states;

import dependency.MusicBeatState;
import dependency.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
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

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/menuLineArt"));
		bg.color = FlxColor.PURPLE;
		bg.screenCenter();
		add(bg);

		var title:FlxText = new FlxText(0, 35, FlxG.width, 'The Engine is Outdated | Latest Version [$version • $type]', 36);
		title.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		title.screenCenter(X);

		var newf:FlxText = new FlxText(10, 80, FlxG.width, "New Features:", 32);
		newf.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var ooooF:FlxText = new FlxText(15, 95, FlxG.width, "", 30);
		ooooF.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var hahaBack:FlxText = new FlxText(0, 650, FlxG.width, 'Press [BACK] To go to Menu | Press [ACCEPT] To go to the Null Engine website', 29);
		hahaBack.setFormat("VCR OSD Mono", 29, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		hahaBack.screenCenter(X);

		for (t in [title, newf, ooooF, hahaBack]) // lol shits
		{
			t.borderSize = 2.25;
			add(t);
		}

		for (oh in newFeatures)
			ooooF.text += '\n• $oh';
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
