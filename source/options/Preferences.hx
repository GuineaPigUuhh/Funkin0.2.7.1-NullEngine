package options;

import Character;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;

using StringTools;

class Preferences extends MusicBeatSubstate
{
	var selector:FlxText;

	var curSelected:Int = 0;
	var optionsCool:Alphabet;

	var bfAnti:Character;
	var falseBeatHit:Int = 1;

	var newOptions:Array<Array<Dynamic>> = [
		["GhostTapping", Save.ghostTapping, "Bool"],
		["Flashing", Save.flashing, "Bool"],
		["Antialiasing", Save.antialiasing, "Bool"],
		["NoteSplash", Save.noteSplash, "Bool"],
		["DownScroll", Save.isDownscroll, "Bool"]
	];

	var youCanPress:Bool = false;
	var stopSpam:Bool = false;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpCheckBoxes:FlxTypedGroup<CheckBox>;

	public function new()
	{
		super();
	}

	override function create()
	{
		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		bfAnti = new Character(0, 0, 'bf', true);
		bfAnti.screenCenter();
		bfAnti.x += 378;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpCheckBoxes = new FlxTypedGroup<CheckBox>();
		add(grpCheckBoxes);
		add(bfAnti);

		for (i in 0...newOptions.length)
		{
			optionsCool = new Alphabet(0, 50 + (i * 50), newOptions[i][0], false, false);
			if (newOptions[i][2] == "Bool")
				optionsCool.xAdd = 125;
			optionsCool.isMenuItem = true;
			optionsCool.targetY = i;
			grpOptions.add(optionsCool);

			if (newOptions[i][2] == "Bool")
			{
				var checkBox:options.CheckBox = new options.CheckBox(0, 0);
				checkBox.updateHitbox();
				checkBox.value = newOptions[i][1];
				checkBox.sprTracker = grpOptions.members[i];
				grpCheckBoxes.add(checkBox);
			}
		}

		changeSelection();

		new FlxTimer().start(0.2, function(bruh:FlxTimer)
		{
			youCanPress = true;
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (bfAnti.visible == true)
		{
			if (falseBeatHit == 1)
			{
				bfAnti.playAnim('idle', true, false, 0);

				falseBeatHit = 0;
				new FlxTimer().start(0.8, function(tmr:FlxTimer)
				{
					falseBeatHit = 1;
				});
			}
		}

		if (stopSpam == false)
			addKeys();

		if (newOptions[curSelected][0] == "Antialiasing")
			bfAnti.visible = true;
		else
			bfAnti.visible = false;

		bfAnti.antialiasing = Save.antialiasing;
	}

	function addKeys()
	{
		if (controls.DOWN_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(1);
		}

		if (controls.UP_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(-1);
		}

		if (controls.BACK)
		{
			OptionsState.stopSpam = false;
			stopSpam = true;

			Save.saveSettings();

			FlxG.state.closeSubState();
		}

		if (youCanPress == true)
		{
			if (controls.ACCEPT)
			{
				if (newOptions[curSelected][2] == "Bool")
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));

					youCanPress = false;
					stopSpam = true;
					FlxFlicker.flicker(grpOptions.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
					{
						youCanPress = true;
						stopSpam = false;

						changeStatus();
					});
				}
			}
		}
	}

	function changeStatus()
	{
		switch (newOptions[curSelected][0])
		{
			case "GhostTapping":
				{
					Save.ghostTapping = !Save.ghostTapping;
				}
			case "Flashing":
				{
					Save.flashing = !Save.flashing;
				}
			case "Antialiasing":
				{
					Save.antialiasing = !Save.antialiasing;
				}
			case "NoteSplash":
				{
					Save.noteSplash = !Save.noteSplash;
				}
			case "DownScroll":
				{
					Save.isDownscroll = !Save.isDownscroll;
				}
			default:
				trace("Error: On Change Options");
		}
		updatePrefs();

		grpCheckBoxes.members[curSelected].value = newOptions[curSelected][1];
	}

	function updatePrefs()
	{
		newOptions = [
			["GhostTapping", Save.ghostTapping, "Bool"],
			["Flashing", Save.flashing, "Bool"],
			["Antialiasing", Save.antialiasing, "Bool"],
			["NoteSplash", Save.noteSplash, "Bool"],
			["DownScroll", Save.isDownscroll, "Bool"]
		];
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);

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
