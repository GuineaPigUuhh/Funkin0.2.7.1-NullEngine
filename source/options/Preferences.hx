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

	public var options:Array<String> = ["GhostTapping", "Flashing"];
	public var optionsFunction:Array<Dynamic> = [Save.ghostTapping, Save.flashing];

	private var grpOptions:FlxTypedGroup<Alphabet>;

	public function new()
	{
		super();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('engine_stuff/menuEngine'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		var other:FlxSprite = new FlxSprite().loadGraphic(Paths.image('engine_stuff/menuEngine'));
		other.setGraphicSize(Std.int(other.width * 1.1));
		other.updateHitbox();
		other.screenCenter();
		other.antialiasing = true;
		// add(other);

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
		optionsCool = new Alphabet(0, 50 + (idddd * 50), options[idddd] + " - " + optionsFunction[idddd], true, false);
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
		{
			Save.ghostTapping = optionsFunction[0];
			Save.flashing = optionsFunction[1];
			Save.saveSettings();

			Save.loadSettings();

			FlxG.state.closeSubState();
		}

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
				item.text = options[curSelected] + " - " + optionsFunction[curSelected];
			}
		}

		optionsFunction[curSelected] = !optionsFunction[curSelected];
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
