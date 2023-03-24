package states.menus;

import dependency.Logs;
import dependency.MusicBeatState;
import dependency.Paths;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxObject;
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
import game.sprites.OptionTab;
import lime.utils.Assets;

using StringTools;

typedef Tab =
{
	var name:String;
	var desc:String;
	var onSelected:() -> Void;
}

class OptionsState extends MusicBeatState
{
	var selector:FlxText;

	static var curSelected:Int = 0;

	var optionsCool:Alphabet;

	public static var isPlayStated:Bool = false;

	private var grpOptions:FlxTypedGroup<OptionTab>;

	var options:Array<Tab> = [];

	var stopSpam:Bool = false;
	var camFollow:FlxObject;

	override function create()
	{
		super.create();

		// stopSpam = false;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuNullEngine'));
		menuBG.scrollFactor.set();
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		grpOptions = new FlxTypedGroup<OptionTab>();
		add(grpOptions);

		options = [
			{
				name: "gameplay",
				desc: "Change the settings to your preferences, like downscroll, middlescroll",
				onSelected: function()
				{
					openSubState(new substates.options.GameplayTab());
				}
			},
			{
				name: "customize",
				desc: "Change visuals and hud",
				onSelected: function()
				{
					openSubState(new substates.options.CustomizeTab());
				}
			},
			{
				name: "graphics",
				desc: "Change graphics settings for better performance",
				onSelected: function()
				{
					openSubState(new substates.options.GraphicsTab());
				}
			}
		];

		for (i in 0...options.length)
		{
			var customTab:OptionTab = new OptionTab(options[i], i);
			grpOptions.add(customTab);
		}

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.camera.follow(camFollow, null, 0.06);
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
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(grpOptions.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
				{
					// stopSpam = true;
					for (e in options)
					{
						if (options[curSelected].name == e.name)
						{
							e.onSelected();
						}
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

		for (item in grpOptions.members)
		{
			item.updateAlpha(curSelected);
		}

		camFollow.setPosition(grpOptions.members[curSelected].optionText.x + 550, grpOptions.members[curSelected].optionText.y);
	}
}
