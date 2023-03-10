package substates.options;

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
import game.sprites.Alphabet;
import game.sprites.Character;
import game.sprites.CheckBox;
import lime.utils.Assets;
import states.menus.OptionsState;

using StringTools;

class Preferences extends MusicBeatSubstate
{
	var selector:FlxText;

	var curSelected:Int = 0;
	var optionsCool:Alphabet;

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
				var checkBox:CheckBox = new CheckBox(0, 0);
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
		if (stopSpam == false)
			addKeys();

		super.update(elapsed);
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
					createDaFuction("GhostTapping", "ghostTapping");
					createDaFuction("Antialiasing", "antialiasing");
					createDaFuction("Flashing", "flashing");
					createDaFuction("DownScroll", "isDownscroll");
					createDaFuction("MiddleScroll", "middleScroll");
					createDaFuction("Freeplay Cutscene", "freeplayCutscene");
					createDaFuction("NoteSplash", "noteSplash");

					updatePrefs();
					grpCheckBoxes.members[curSelected].value = newOptions[curSelected][1];
				}
		}
	}

	function updatePrefs()
	{
		newOptions = [
			["GhostTapping", FlxG.save.data.ghostTapping, "Bool"],
			["Antialiasing", FlxG.save.data.antialiasing, "Bool"],
			["Flashing", FlxG.save.data.flashing, "Bool"],
			["DownScroll", FlxG.save.data.isDownscroll, "Bool"],
			["MiddleScroll", FlxG.save.data.middleScroll, "Bool"],
			["Freeplay Cutscene", FlxG.save.data.freeplayCutscene, "Bool"],
			["NoteSplash", FlxG.save.data.noteSplash, "Bool"]
		];
	}

	function createDaFuction(name:String, save:String)
	{
		if (newOptions[curSelected][0] == name)
		{
			var value = Reflect.getProperty(FlxG.save.data, save);
			value = !value;

			Reflect.setProperty(FlxG.save.data, save, value);
		}
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
