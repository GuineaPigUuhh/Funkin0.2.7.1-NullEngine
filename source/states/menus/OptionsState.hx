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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import game.sprites.Alphabet;
import game.sprites.OptionTab;
import lime.utils.Assets;
import states.menus.tabs.*;

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

	private var grpOptions:FlxTypedGroup<OptionTab>;

	var options:Array<Tab> = [];

	var stopSpam:Bool = false;

	var menuBG:FlxSprite;

	override function create()
	{
		persistentUpdate = persistentDraw = true;

		super.create();

		// stopSpam = false;

		menuBG = new FlxSprite().loadGraphic(Paths.image('menus/options/menuBGoptions'));
		menuBG.scrollFactor.set();
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		grpOptions = new FlxTypedGroup<OptionTab>();
		add(grpOptions);

		addTab("keybinds", "Change the controls.", function()
		{
			exit();
			Logs.error("this setting has not been configured");
		});

		addTab("gameplay", "Change the settings to your preferences, like downscroll, middlescroll.", function()
		{
			FlxG.switchState(new GameplayTab());
		});

		addTab("customize", "Change visuals and hud.", function()
		{
			FlxG.switchState(new CustomizeTab());
		});

		addTab("graphics", "Change graphics settings for better performance.", function()
		{
			FlxG.switchState(new GraphicsTab());
		});

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

				stopSpam = true;
				FlxFlicker.flicker(grpOptions.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
				{
					for (e in options)
					{
						if (options[curSelected].name == e.name)
						{
							e.onSelected();

							persistentUpdate = false;
							persistentDraw = false;
						}
					}
				});
			}
		}
	}

	function addTab(tabName:String, tabDesc:String, tabCallBack:() -> Void)
	{
		options.push({name: tabName, desc: tabDesc, onSelected: tabCallBack});
	}

	function exit()
	{
		FlxG.switchState(new states.menus.MainMenuState());
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);

		var bullShit:Int = 0;
		for (item in grpOptions.members)
		{
			item.optionText.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.8;
			if (item.optionText.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
