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
import flxanimate.FlxAnimate;
import haxe.Json;
import haxe.format.JsonParser;
import lime.app.Application;
import lime.utils.Assets;
import modding.ModPaths;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];

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
		bg.antialiasing = Save.antialiasing;
		bg.scrollFactor.set();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuDesat'));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = Save.antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));

			var defaultImage:String = "donate";

			var funkinLocal:String = 'menus/main/items/';

			var file = ModPaths.getSparrowAtlas(funkinLocal + optionShit[i]);
			var idleAnim:String = optionShit[i] + " basic";
			var selectedAnim:String = optionShit[i] + " white";

			var fileExists:String = ModPaths.image(funkinLocal + optionShit[i]);

			if (!FileSystem.exists(fileExists))
			{
				file = Paths.getSparrowAtlas(funkinLocal + optionShit[i]);
				fileExists = Paths.image(funkinLocal + optionShit[i]);
			}

			if (!FileSystem.exists(fileExists))
			{
				file = Paths.getSparrowAtlas(funkinLocal + defaultImage);
				idleAnim = defaultImage + " basic";
				selectedAnim = defaultImage + " white";
			}

			menuItem.frames = file;
			menuItem.animation.addByPrefix('idle', idleAnim, 24);
			menuItem.animation.addByPrefix('selected', selectedAnim, 24);

			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0.8);
			menuItem.antialiasing = Save.antialiasing;
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

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if (Save.flashing == true)
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
