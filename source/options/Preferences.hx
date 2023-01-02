package options;

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

class Preferences extends MusicBeatSubstate
{
	var selector:FlxText;

	var curSelected:Int = 0;
	var optionsCool:Alphabet;
	private var options:Array<Array<Dynamic>> = [['GhostTapping', Save.ghostTapping], ['Flashing', Save.flashing]];

	private var grpOptions:FlxTypedGroup<Alphabet>;

	public function new()
	{
		super();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			addOptions(i);
		}

		changeSelection();
	}

	function addOptions(idddd:Int)
	{
		optionsCool = new Alphabet(0, 50 + (idddd * 50), options[idddd][0] + " - " + options[idddd][1], true, false);
		optionsCool.isMenuItem = true;
		optionsCool.targetY = idddd;
		grpOptions.add(optionsCool);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.UP_P)
			changeSelection(-1);

		if (controls.BACK)
			FlxG.state.closeSubState();

		if (controls.ACCEPT)
		{
			changeStatus();
		}
	}

	function changeStatus()
	{
		for (item in grpOptions.members)
		{
			if (item.targetY == 0)
			{
				item.text = options[curSelected][0] + " - " + options[curSelected][1];
			}
		}

		if (options[curSelected][1] == true)
			options[curSelected][1] = false;

		if (options[curSelected][1] == false)
			options[curSelected][1] = true;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpOptions.length - 1;
		if (curSelected >= grpOptions.length)
			curSelected = 0;

		var bullShit:Int = 0;
		for (item in grpOptions.members)
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
