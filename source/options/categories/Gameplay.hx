package options.categories;

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

class Gameplay extends MusicBeatSubstate
{
	var selector:FlxText;

	var curSelected:Int = 0;
	var optionsCool:Alphabet;

	var bfAnti:Character;
	var falseBeatHit:Int = 1;

	var newOptions:Array<Array<Dynamic>> = [];

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
		updatePrefs(); // create options

		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpCheckBoxes = new FlxTypedGroup<CheckBox>();
		add(grpCheckBoxes);

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

		if (stopSpam == false)
			addKeys();
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
			PreferencesState.stopSpam = false;
			stopSpam = true;

			Save.saveSettings();

			FlxG.state.closeSubState();
		}

		if (youCanPress == true)
		{
			if (newOptions[curSelected][2] == "Bool")
			{
				if (controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));

					youCanPress = false;
					stopSpam = true;
					FlxFlicker.flicker(grpOptions.members[curSelected], 1, 0.04, true, false, function(flick:FlxFlicker)
					{
						youCanPress = true;
						stopSpam = false;

						changePrefs("Bool");
					});
				}
			}
		}
	}

	function changePrefs(type:String)
	{
		switch (type)
		{
			case "Bool":
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
						case "MiddleScroll":
							{
								Save.middleScroll = !Save.middleScroll;
							}
						case "Freeplay Cutscene":
							{
								Save.freeplayCutscene = !Save.freeplayCutscene;
							}
						default:
							trace("Error: On Change Options");
					}

					updatePrefs();
					grpCheckBoxes.members[curSelected].value = newOptions[curSelected][1];
				}
		}
	}

	function updatePrefs()
	{
		newOptions = [
			["GhostTapping", Save.ghostTapping, "Bool"],
			["Flashing", Save.flashing, "Bool"],
			["DownScroll", Save.isDownscroll, "Bool"],
			["MiddleScroll", Save.middleScroll, "Bool"],
			["Freeplay Cutscene", Save.freeplayCutscene, "Bool"]
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
