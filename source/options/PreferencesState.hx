package options;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import modding.ModState;

using StringTools;

class PreferencesState extends MusicBeatState
{
	var selector:FlxText;

	static var curSelected:Int = 0;

	var optionsCool:Alphabet;

	public var options:Array<String> = ["gameplay", "appearance", "graphics", "exit"];

	private var grpOptions:FlxTypedGroup<Alphabet>;

	public static var stopSpam:Bool = false; // substate fix

	override function create()
	{
		super.create();

		PreferencesState.stopSpam = false;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
			addOptions(i);

		changeSelection();
	}

	function addOptions(idddd:Int)
	{
		optionsCool = new Alphabet(0, 100 + (idddd * 100), options[idddd], true, false);
		optionsCool.screenCenter(X);
		optionsCool.isMenuItem = false;
		optionsCool.targetY = idddd;
		grpOptions.add(optionsCool);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!stopSpam)
		{
			if (controls.DOWN_P)
			{
				changeSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}
			if (controls.UP_P)
			{
				changeSelection(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.BACK)
			{
				stopSpam = true;

				FlxG.switchState(new options.OptionsState());
			}

			if (controls.ACCEPT)
			{
				stopSpam = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(grpOptions.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
				{
					switch (options[curSelected])
					{
						case "gameplay":
							FlxG.state.openSubState(new options.categories.Gameplay());
						case "appearance":
							FlxG.state.openSubState(new options.categories.Appearance());
						case "graphics":
							FlxG.state.openSubState(new options.categories.Graphics());
						case "exit":
							FlxG.switchState(new options.OptionsState());
						default:
							CoolLogSystem.error('Option Not Configured');
					}
				});
			}
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
