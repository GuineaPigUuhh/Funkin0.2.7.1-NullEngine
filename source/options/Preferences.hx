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
import flixel.util.FlxTimer;
import lime.utils.Assets;

using StringTools;

class Preferences extends MusicBeatSubstate
{
	var selector:FlxText;

	var curSelected:Int = 0;
	var optionsCool:Alphabet;

	public var options:Array<String> = [];

	var youCanPress:Bool = false;
	var stopSpam:Bool = false;

	private var grpOptions:FlxTypedGroup<Alphabet>;

	public function new()
	{
		updateOptions();
		super();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('engine_stuff/menuLineArt'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			optionsCool = new Alphabet(0, 50 + (i * 50), options[i], true, false);
			optionsCool.isMenuItem = true;
			optionsCool.targetY = i;
			grpOptions.add(optionsCool);
		}

		new FlxTimer().start(0.2, function(bruh:FlxTimer)
		{
			youCanPress = true;
		});

		changeSelection();
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
			stopSpam = true;
			Save.saveSettings();

			FlxG.state.closeSubState();
		}

		if (youCanPress == true)
			if (controls.ACCEPT)
				changeStatus();
	}

	function changeStatus()
	{
		grpOptions.remove(grpOptions.members[curSelected]);

		switch (options[curSelected])
		{
			case "GhostTapping" | "No GhostTapping":
				{
					Save.ghostTapping = !Save.ghostTapping;
				}
			case "Flashing" | "No Flashing":
				{
					Save.flashing = !Save.flashing;
				}
			case "Antialiasing" | "No Antialiasing":
				{
					Save.antialiasing = !Save.antialiasing;
				}
			case "NoteSplash" | "No NoteSplash":
				{
					Save.noteSplash = !Save.noteSplash;
				}
			case "UpScroll" | "DownScroll":
				{
					Save.isDownscroll = !Save.isDownscroll;
				}
			case "lightStrumsPlayer" | "No lightStrumsPlayer":
				{
					Save.lightStrumsPlayer = !Save.lightStrumsPlayer;
				}
			case "lightStrumsCpu" | "No lightStrumsCpu":
				{
					Save.lightStrumsCpu = !Save.lightStrumsCpu;
				}
			default:
				trace("ERROR ON CHANGE OPTION");
		}

		updateOptions();

		optionsCool = new Alphabet(0, 50 + (curSelected * 50), options[curSelected], true, false);
		optionsCool.isMenuItem = true;
		grpOptions.add(optionsCool);
	}

	function updateOptions()
	{
		options = [
			Save.ghostTapping ? "GhostTapping" : "No GhostTapping",
			Save.flashing ? "Flashing" : "No Flashing",
			Save.antialiasing ? "Antialiasing" : "No Antialiasing",
			Save.noteSplash ? "NoteSplash" : "No NoteSplash",
			Save.isDownscroll ? "DownScroll" : "UpScroll",
			Save.lightStrumsPlayer ? "lightStrumsPlayer" : "No lightStrumsPlayer",
			Save.lightStrumsCpu ? "lightStrumsCpu" : "No lightStrumsCpu"
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
