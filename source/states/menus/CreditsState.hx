package states.menus;

import dependency.Logs;
import dependency.MusicBeatState;
import dependency.Paths;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import game.sprites.Alphabet;
import states.TitleState;
import states.menus.MainMenuState;

typedef CreditStuff =
{
	var name:String;
	var desc:String;
	var icon:String;
}

class CreditsState extends MusicBeatState
{
	var creditStuff:Array<CreditStuff> = [
		{
			name: "CapybaraCoding",
			desc: "Coder",
			icon: "capycode"
		},
		{
			name: "Sloow",
			desc: "Coder",
			icon: "sloow"
		}
	];

	var camFollow:FlxObject;
	var grpCredits:Array<Alphabet> = [];

	var curSelected:Int = 0;
	var selectedSomethin:Bool = false;

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
			var creditText:Alphabet = new Alphabet(0, (i * 125), creditStuff[i].name, false, false);
			add(creditText);

			var creditIcon:FlxSprite = new FlxSprite(creditText.x + creditText.width + 20, creditText.y + 10);
			creditIcon.loadGraphic(Paths.image('menus/credits/' + creditStuff[i].icon));
			creditIcon.antialiasing = FlxG.save.data.antialiasing;
			creditIcon.scale.set(0.8, 0.8);
			add(creditIcon);

			grpCredits.push(creditText);
		}

		FlxG.camera.follow(camFollow, null, 0.06);

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

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, grpCredits.length - 1);

		camFollow.setPosition(grpCredits[curSelected].x + 550, grpCredits[curSelected].y);
	}
}
