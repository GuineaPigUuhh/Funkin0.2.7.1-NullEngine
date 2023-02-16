package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import haxe.Json;
import haxe.format.JsonParser;
import jsonData.CreditsJSON;
import lime.utils.Assets;
import modding.ModPaths;
import openfl.system.System;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CreditsState extends MusicBeatState
{
	var credits:FlxText;
	var role:FlxText;
	var creditsIcon:FlxSprite;
	var massagg:FlxText;
	var copycat:FlxText;

	var leave:Bool = false;

	var menuBG:FlxSprite;

	static var curSelected:Int = 0;

	override function create()
	{
		CreditsJSON.getJSON();

		menuBG = new FlxSprite().loadGraphic(Paths.image('engine_stuff/menuDesatGradient'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		var cool:FlxSprite = new FlxSprite().loadGraphic(Paths.image('engine_stuff/cool stuff'));
		cool.updateHitbox();
		cool.screenCenter();
		add(cool);

		creditsIcon = new FlxSprite(0, 0);
		setScreenCenter(creditsIcon, "XY");

		credits = new FlxText(0, creditsIcon.y + 100, '', 50);
		credits.setFormat(Paths.font("phantomuff.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		credits.screenCenter(X);

		role = new FlxText(0, credits.y + 50, '', 30);
		role.setFormat(Paths.font("phantomuff.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		role.screenCenter(X);

		massagg = new FlxText(0, role.y + 60, '', 25);
		massagg.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		massagg.borderSize = 2;
		massagg.screenCenter(X);

		add(massagg);
		add(credits);
		add(creditsIcon);
		add(role);

		copycat = new FlxText(0, 150, '', 60);
		copycat.setFormat(Paths.font("phantomuff.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		copycat.borderSize = 2;
		copycat.screenCenter(X);

		add(copycat);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!leave)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection(-1);
			}
			else if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection(1);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new MainMenuState());
				leave = true;
			}

			if (controls.ACCEPT)
			{
				trace('FUCK YOU!');
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, CreditsJSON.users.length - 1);

		updateCredits();
	}

	function setScreenCenter(sprite:FlxSprite, position:String = "XY")
	{
		if (position == "XY")
		{
			sprite.x = (FlxG.width / 2) - (sprite.width / 2);
			sprite.y = (FlxG.height / 2) - (sprite.height / 2);
		}
		if (position == "X")
		{
			sprite.x = (FlxG.width / 2) - (sprite.width / 2);
		}
		if (position == "Y")
		{
			sprite.y = (FlxG.height / 2) - (sprite.height / 2);
		}
	}

	var colorTween:ColorTween;

	function updateCredits()
	{
		if (colorTween == null) // color fix bruh
		{
			colorTween = FlxTween.color(menuBG, 0.4, menuBG.color, FlxColor.fromString("#" + CreditsJSON.users[curSelected].color), {startDelay: 0.05});
		}
		else
		{
			colorTween.cancel();
			colorTween = FlxTween.color(menuBG, 0.4, menuBG.color, FlxColor.fromString("#" + CreditsJSON.users[curSelected].color), {startDelay: 0.05});
		}

		var path:String = 'credits/' + CreditsJSON.users[curSelected].icon;

		creditsIcon.loadGraphic(CoolUtil.configGraphic(path));

		creditsIcon.alpha = 0;
		setScreenCenter(creditsIcon, "X");
		creditsIcon.y = (FlxG.height / 2) - (creditsIcon.height / 2) - 15;
		FlxTween.tween(creditsIcon, {alpha: 1, y: (FlxG.height / 2) - (creditsIcon.height / 2)}, 0.2, {ease: FlxEase.cubeOut});

		credits.text = CreditsJSON.users[curSelected].name;
		credits.screenCenter(X);

		copycat.text = CreditsJSON.users[curSelected].category;
		copycat.screenCenter(X);

		if (CreditsJSON.users[curSelected].message == null || CreditsJSON.users[curSelected].message.length < 1)
		{
			massagg.text = "";
		}
		else
		{
			massagg.text = '"' + CreditsJSON.users[curSelected].message + '"';
			massagg.screenCenter(X);
		}

		role.text = CreditsJSON.users[curSelected].role;
		role.screenCenter(X);
	}

	function getCurrentBGColor()
	{
		var bgColor:String = CreditsJSON.users[curSelected].color;
		return FlxColor.fromString("#" + bgColor);
	}
}
