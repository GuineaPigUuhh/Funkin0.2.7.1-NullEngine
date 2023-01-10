package;

#if desktop
import DiscordClient;
#end
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
import haxe.Json;
import haxe.format.JsonParser;
import lime.app.Application;
import lime.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef CustomStateJSON =
{
	var options:Array<CustomStates>;
}

typedef CustomStates =
{
	var name:String;
	var stateName:String;
}

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var statesJSON:CustomStateJSON;

	override function create()
	{
		statesJSON = Json.parse(Assets.getText(Paths.json("customStates")));

		for (i in 0...statesJSON.options.length)
		{
			optionShit.insert(optionShit.length + i, statesJSON.options[i].name);
			trace("Add To Options: " + statesJSON.options[i].name + ", Bruh: " + optionShit.length + i);
		}

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

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		bg.scrollFactor.set();

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));

			var file = Paths.getSparrowAtlas('mainMenuAssets/${optionShit[i]}');
			var idleAnim = optionShit[i] + " basic";
			var selectedAnim = optionShit[i] + " white";

			if (!FileSystem.exists(Paths.image('mainMenuAssets/${optionShit[i]}')))
			{
				file = Paths.getSparrowAtlas('mainMenuAssets/donate');
				idleAnim = "donate basic";
				selectedAnim = "donate white";
			}

			menuItem.frames = file;
			menuItem.animation.addByPrefix('idle', idleAnim, 24);
			menuItem.animation.addByPrefix('selected', selectedAnim, 24);

			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0.8);
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);
		// NG.core.calls.event.logEvent('swag').send();

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

			if (controls.RIGHT_P)
			{
				selectedSomethin = true;
				FlxG.switchState(new customState.CreditsState());
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							selectState();
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

	function selectState()
	{
		switch (optionShit[curSelected])
		{
			case "story mode":
				FlxG.switchState(new StoryMenuState());
			case "freeplay":
				FlxG.switchState(new FreeplayState());
			case "options":
				FlxG.switchState(new options.OptionsState());
		}

		for (i in 0...statesJSON.options.length)
		{
			if (optionShit[curSelected] == statesJSON.options[i].name)
			{
				customState.CustomState.daState = statesJSON.options[i].stateName;
				FlxG.switchState(new customState.CustomState());
			}
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + huh, 0, menuItems.length - 1);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
