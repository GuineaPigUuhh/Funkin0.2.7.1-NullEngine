package states.menus;

import dependency.Logs;
import dependency.MusicBeatState;
import dependency.Paths;
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
import game.sprites.Alphabet;
import lime.utils.Assets;
import states.menus.ModMenuState;

using StringTools;

class OptionsState extends MusicBeatState
{
	var selector:FlxText;

	static var curSelected:Int = 0;

	var optionsCool:Alphabet;

	public static var isPlayStated:Bool = false;

	public var options:Array<String> = ["preferences", "offset", "mods", "exit"];

	private var grpOptions:FlxTypedGroup<Alphabet>;

	public static var stopSpam:Bool = false; // substate fix

	override function create()
	{
		super.create();

		OptionsState.stopSpam = false;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
			addOptions(i);

		changeSelection();
	}

	function addOptions(idddd:Int)
	{
		optionsCool = new Alphabet(0, 50 + (idddd * 100), options[idddd], true, false);
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

				exit();
			}

			if (controls.ACCEPT)
			{
				stopSpam = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(grpOptions.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
				{
					switch (options[curSelected])
					{
						case "preferences":
							FlxG.state.openSubState(new substates.options.Preferences());
						/*
							case "controls":
								FlxG.switchState(new options.ControlsState());
						 */
						case "offset":
							FlxG.switchState(new LatencyState());
						case "mods":
							FlxG.switchState(new ModMenuState());
						case "exit":
							exit();
						default:
							Logs.error('Option Not Configured');
					}
				});
			}
		}
	}

	function exit()
	{
		if (isPlayStated == false)
			FlxG.switchState(new states.menus.MainMenuState());
		else
			FlxG.switchState(new PlayState());
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
