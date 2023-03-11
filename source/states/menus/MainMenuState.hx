package states.menus;

import dependency.MusicBeatState;
import dependency.Paths;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flxanimate.FlxAnimate;
import haxe.Json;
import haxe.format.JsonParser;
import lime.app.Application;
import lime.utils.Assets;
import states.menus.FreeplayState;
import states.menus.OptionsState;
import states.menus.StoryMenuState;

using StringTools;

#if desktop
import game.DiscordClient;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		// CoolUtil.setMouseSprite(FlxG.mouse, "mouseSprite");

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBG'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;
		bg.scrollFactor.set();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuDesat'));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = FlxG.save.data.antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		createOption("story mode", function()
		{
			FlxG.switchState(new StoryMenuState()); // I made this options system because I was bored
		});

		createOption("freeplay", function()
		{
			FlxG.switchState(new FreeplayState());
		});

		createOption("kickstarter", function()
		{
			selectedDonate();
		});

		createOption("options", function()
		{
			FlxG.switchState(new OptionsState());
		});

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			var funkinLocal:String = 'menus/main/items/';

			var file = Paths.getSparrowAtlas(funkinLocal + optionShit[i]);
			var idleAnim:String = optionShit[i] + " basic";
			var selectedAnim:String = optionShit[i] + " white";

			menuItem.frames = file;
			menuItem.animation.addByPrefix('idle', idleAnim, 24);
			menuItem.animation.addByPrefix('selected', selectedAnim, 24);

			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0);
			menuItem.antialiasing = FlxG.save.data.antialiasing;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] != "kickstarter")
					selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if (FlxG.save.data.flashing == true)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID && optionShit[curSelected] != "kickstarter")
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								if (optionShit[curSelected] != "kickstarter")
									spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
						{
							selectOption();
						});
					}
				});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	var callbackOptions:Array<() -> Void> = [];

	function createOption(name:String, callback:() -> Void)
	{
		optionShit.push(name);
		callbackOptions.push(callback);
	}

	function selectOption()
	{
		var daChoice:String = optionShit[curSelected];

		for (i in 0...callbackOptions.length)
		{
			if (optionShit[curSelected] == optionShit[i])
			{
				callbackOptions[i]();
			}
		}
	}

	function selectedDonate()
	{
		FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game/');
	}

	function changeItem(huh:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + huh, 0, menuItems.length - 1);

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.centerOffsets();
			}
			else
			{
				spr.animation.play('idle');
				spr.updateHitbox();
			}
		});
	}
}
