package states.menus;

import dependency.Logs;
import dependency.MusicBeatState;
import dependency.Paths;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import game.sprites.Alphabet;
import game.sprites.AttachedSprite;
import haxe.Json;
import haxe.format.JsonParser;
import haxe.macro.Type.AnonType;
import states.TitleState;
import states.menus.MainMenuState;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef CreditsStuff =
{
	var users:Array<UserStuff>;
}

typedef UserStuff =
{
	var name:String;
	var color:String;
	@:optional var desc:String;
	@:optional var icon:String;
	@:optional var isCategory:Bool;
}

class CreditsState extends MusicBeatState
{
	var creditStuff:CreditsStuff;

	var grpCredits:Array<Alphabet> = [];

	var menuBG:FlxSprite;

	var curSelected:Int = 0;
	var selectedSomethin:Bool = false;

	override public function create()
	{
		creditStuff = Json.parse(File.getContent(Paths.getObjectsPath('creditsStuff.json')));

		menuBG = new FlxSprite().loadGraphic(Paths.image('menus/menu_engine_1_desat'));
		menuBG.scrollFactor.set();
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		for (i in 0...creditStuff.users.length)
		{
			var categoryMODE:Bool = false;
			if (creditStuff.users[i].isCategory == true)
				categoryMODE = true;

			if (categoryMODE == false)
			{
				var creditText:Alphabet = new Alphabet(0, (i * 125), creditStuff.users[i].name, false, false);
				creditText.isMenuItem = true;
				creditText.targetY = i;
				add(creditText);
				grpCredits.push(creditText);

				if (creditStuff.users[i].icon != null || creditStuff.users[i].icon != '')
				{
					var creditIcon:AttachedSprite = new AttachedSprite(creditText);
					creditIcon.loadGraphic(Paths.image('menus/credits/' + creditStuff.users[i].icon));
					creditIcon.antialiasing = true;
					creditIcon.copyAlpha = true;
					creditIcon.addX = creditText.width + 15;
					add(creditIcon);
				}
			}
			else
			{
				var category:Alphabet = new Alphabet(0, (i * 125), creditStuff.users[i].name, true, false);
				category.isMenuItem = true;
				category.xAdd = 20;
				category.yAdd = 80;
				category.targetY = i;
				add(category);
				grpCredits.push(category);
			}
		}

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSelection(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSelection(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.switchState(new MainMenuState());
			}
		}
		super.update(elapsed);
	}

	var colorTween:ColorTween = null;

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, grpCredits.length - 1);

		if (colorTween != null)
			colorTween.cancel();
		colorTween = FlxTween.color(menuBG, 0.4, menuBG.color, FlxColor.fromString("#" + creditStuff.users[curSelected].color), {startDelay: 0.05});

		var bullShit:Int = 0;

		for (item in grpCredits)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.8;
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
