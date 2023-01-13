package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class ModState extends MusicBeatState
{
	var selector:FlxText;

	static var curSelected:Int = 0;

	var modsCool:Alphabet;

	public static var curMod:String = "";

	public var mods:Array<String> = CoolUtil.coolTextFile("mods/modList.txt");

	private var grpMods:FlxTypedGroup<Alphabet>;

	override function create()
	{
		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('engine_stuff/menuDesatGradient'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpMods = new FlxTypedGroup<Alphabet>();
		add(grpMods);

		for (i in 0...mods.length)
		{
			addMods(i);
		}

		changeSelection();
	}

	function addMods(idddd:Int)
	{
		modsCool = new Alphabet(0, 50 + (idddd * 50), mods[idddd], true, false);
		modsCool.isMenuItem = true;
		modsCool.targetY = idddd;
		grpMods.add(modsCool);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.UP_P)
			changeSelection(-1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			curMod = mods[curSelected];
			trace("Mod Selected: " + curMod);

			FlxG.switchState(new MainMenuState());
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected = FlxMath.wrap(curSelected + change, 0, grpMods.length - 1);

		var bullShit:Int = 0;
		for (item in grpMods.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
