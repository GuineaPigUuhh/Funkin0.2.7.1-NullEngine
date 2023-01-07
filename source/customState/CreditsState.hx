package customState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import openfl.system.System;

using StringTools;

typedef CreditJSON =
{
	var users:Array<CreditsStuff>;
}

typedef CreditsStuff =
{
	var name:String;
	var icon:String;
	var color:String;
	var message:String;
	var role:String;
	var category:String;
}

class CreditsState extends MusicBeatState
{
	var credits:FlxText;
	var role:FlxText;
	var creditsIcon:FlxSprite;
	var massagg:FlxText;
	var copycat:FlxText;

	var leave:Bool = false;

	public var creditsJson:CreditJSON;

	var menuBG:FlxSprite;

	var curSelected:Int = 0;

	override function create()
	{
		creditsJson = Json.parse(Assets.getText(Paths.json("credits")));

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

		if (creditsJson != null)
		{
			creditsIcon = new FlxSprite(0, 0);
			creditsIcon.screenCenter();

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
		}

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
				changeSelection(1);
			}
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection(-1);
			}

			if (controls.BACK)
			{
				if (colorTween != null)
				{
					colorTween.cancel();
				}
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

	function updateThings()
	{
		menuBG.color = getCurrentBGColor();
		intendedColor = menuBG.color;

		changeColorBG();

		creditsIcon.loadGraphic(Paths.image('credits/' + creditsJson.users[curSelected].icon));
		creditsIcon.screenCenter();

		credits.text = creditsJson.users[curSelected].name;
		credits.screenCenter(X);

		if (creditsJson.users[curSelected].category != null)
		{
			copycat.text = creditsJson.users[curSelected].category;
			copycat.screenCenter(X);
		}

		if (creditsJson.users[curSelected].message == null || creditsJson.users[curSelected].message.length < 1)
			massagg.text = "";
		else
			massagg.text = '"' + creditsJson.users[curSelected].message + '"';

		massagg.screenCenter(X);

		role.text = creditsJson.users[curSelected].role;
		role.screenCenter(X);
	}

	function changeSelection(change:Int = 0)
	{
		updateThings();

		curSelected += change;

		if (curSelected < 0)
			curSelected = creditsJson.users.length - 1;
		if (curSelected >= creditsJson.users.length)
			curSelected = 0;
	}

	var intendedColor:Int;
	var colorTween:FlxTween;

	function changeColorBG()
	{
		var newColor:Int = getCurrentBGColor();

		if (newColor != intendedColor)
		{
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(menuBG, 1, menuBG.color, intendedColor, {
				onComplete: function(twn:FlxTween)
				{
					colorTween = null;
				}
			});
		}
	}

	function getCurrentBGColor()
	{
		var bgColor:String = "#" + creditsJson.users[curSelected].color;
		return FlxColor.fromString(bgColor);
	}
}
