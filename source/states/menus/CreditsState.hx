package states.menus;

import dependency.Logs;
import dependency.MusicBeatState;
import dependency.Paths;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import game.sprites.Alphabet;

typedef CreditStuff =
{
	var userName:String;
	var userDesc:String;
}

class CreditsState extends MusicBeatState
{
	var creditStuff:Array<CreditStuff> = [
		{
			userName: "CapybaraCoding",
			userDesc: "Coder"
		},
		{
			userName: "Amongus",
			userDesc: "Coder"
		}
	];

	var camFollow:FlxObject;
	var grpCredits:Array<Alphabet> = [];

	var curSelected:Int = 0;

	override public function create()
	{
		trace(creditStuff);

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuNullEngine'));
		menuBG.scrollFactor.set();
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		for (i in 0...creditStuff.length)
		{
			var creditText:Alphabet = new Alphabet(0, (i * 95), creditStuff[curSelected].userName, false, false);
			add(creditText);

			grpCredits.push(creditText);
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);

		camFollow.setPosition(grpCredits[curSelected].x + 550, grpCredits[curSelected].y);
	}
}
