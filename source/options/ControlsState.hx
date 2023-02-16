package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using StringTools;

class ControlsState extends MusicBeatState
{
	var keyWarning:FlxText;
	var warningTween:FlxTween;
	var curSelected:Int = 0;

	var controlsText:FlxText;

	var keyText:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "LEFT ALT", "DOWN ALT", "UP ALT", "RIGHT ALT"];
	var defaultKeys:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "A", "S", "W", "D"];

	var keys:Array<String> = [
		Save.keyLEFT,
		Save.keyDOWN,
		Save.keyUP,
		Save.keyRIGHT,
		Save.keyLEFTalt,
		Save.keyDOWNalt,
		Save.keyUPalt,
		Save.keyRIGHTalt
	];

	var tempKey:String = "";
	var blacklist:Array<String> = ["ESCAPE", "ENTER", "BACKSPACE", "SPACE"];

	var keysGroup:FlxTypedGroup<FlxText>;

	var state:String = "select";
	var inicialKeyX:Float = 0;

	override function create()
	{
		persistentUpdate = persistentDraw = true;

		var menuBG:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		menuBG.scrollFactor.set();
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		controlsText = new FlxText(0, 100, 1280, "- Controls -", 45);
		controlsText.scrollFactor.set();
		controlsText.setFormat(Paths.font("vcr.ttf"), 45, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		controlsText.borderSize = 3;
		add(controlsText);

		keysGroup = new FlxTypedGroup<FlxText>();
		add(keysGroup);

		var sizeKeyText:Int = 34;
		for (i in 0...keys.length)
		{
			var keyTextDisplay:FlxText = new FlxText(inicialKeyX, 200 + (i * 30), 1280, "", sizeKeyText);
			keyTextDisplay.scrollFactor.set();
			keyTextDisplay.setFormat(Paths.font("vcr.ttf"), sizeKeyText, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			keyTextDisplay.borderSize = 3;

			keysGroup.add(keyTextDisplay);

			keyTextDisplay.text = keyText[i] + ': ' + keys[i];
		}

		keyWarning = new FlxText(0, 580, 1280, "WARNING: BIND NOT SET, TRY ANOTHER KEY", 40);
		keyWarning.scrollFactor.set(0, 0);
		keyWarning.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.RED, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		keyWarning.borderSize = 3;
		keyWarning.screenCenter(X);
		keyWarning.alpha = 0;
		add(keyWarning);

		var backText = new FlxText(5, FlxG.height - 45, 0, "[ESCAPE] | [BACKSPACE] Back to Menu\n[R] Reset Keys\n", 18);
		backText.scrollFactor.set();
		backText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		backText.borderSize = 2;
		add(backText);

		warningTween = FlxTween.tween(keyWarning, {alpha: 0}, 0);

		textUpdate();
		changeItem();

		super.create();
	}

	override function update(elapsed:Float)
	{
		switch (state)
		{
			case "select":
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

				if (FlxG.keys.justPressed.ENTER)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));

					tempKey = keys[curSelected];
					keys[curSelected] = "?";
					textUpdate();
					state = "waiting";
				}
				else if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE || FlxG.gamepads.anyJustPressed(ANY))
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					quit();
				}
				else if (FlxG.keys.justPressed.R)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					reset();
				}

			case "waiting":
				if (FlxG.keys.justPressed.ESCAPE)
				{
					keys[curSelected] = tempKey;
					state = "select";
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
				else if (FlxG.keys.justPressed.ENTER)
				{
					addKey(defaultKeys[curSelected]);
					save();
					state = "select";
				}
				else if (FlxG.keys.justPressed.ANY)
				{
					addKey(FlxG.keys.getIsDown()[0].ID.toString());
					save();
					state = "select";
				}

			case "exiting":

			default:
				state = "select";
		}

		if (FlxG.keys.justPressed.ANY)
			textUpdate();

		super.update(elapsed);
	}

	function textUpdate()
	{
		for (i in 0...keys.length)
		{
			keysGroup.members[i].text = keyText[i] + ': ' + keys[i];

			keysGroup.members[i].screenCenter(X);
		}
	}

	function save()
	{
		Save.keyLEFT = keys[0];
		Save.keyDOWN = keys[1];
		Save.keyUP = keys[2];
		Save.keyRIGHT = keys[3];

		Save.keyLEFTalt = keys[4];
		Save.keyDOWNalt = keys[5];
		Save.keyUPalt = keys[6];
		Save.keyRIGHTalt = keys[7];

		Save.saveSettings();

		PlayerSettings.player1.controls.loadKeyBinds();
	}

	function reset()
	{
		for (i in 0...keys.length)
		{
			keys[i] = defaultKeys[i];
		}
	}

	function quit()
	{
		state = "exiting";

		save();

		FlxG.switchState(new OptionsState());
	}

	function addKey(r:String)
	{
		var shouldReturn:Bool = true;

		var notAllowed:Array<String> = [];

		for (x in keys)
		{
			if (x != tempKey)
			{
				notAllowed.push(x);
			}
		}

		for (x in blacklist)
		{
			notAllowed.push(x);
		}

		if (curSelected != 4)
		{
			for (x in keyText)
			{
				if (x != keyText[curSelected])
				{
					notAllowed.push(x);
				}
			}
		}
		else
		{
			for (x in keyText)
			{
				notAllowed.push(x);
			}
		}

		trace(notAllowed);

		for (x in notAllowed)
		{
			if (x == r)
			{
				shouldReturn = false;
			}
		}

		if (shouldReturn)
		{
			keys[curSelected] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else if (!shouldReturn && keys.contains(r))
		{
			keys[keys.indexOf(r)] = tempKey;
			keys[curSelected] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else
		{
			keys[curSelected] = tempKey;
			FlxG.sound.play(Paths.sound('cancelMenu'));

			trace("ERRO ON CHANGE KEY.");
			keyWarning.alpha = 1;

			warningTween.cancel();
			warningTween = FlxTween.tween(keyWarning, {alpha: 0}, 0.5, {ease: FlxEase.circOut, startDelay: 2});
		}
	}

	function changeItem(_amount:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + _amount, 0, keys.length - 1);

		for (i in 0...keysGroup.members.length)
		{
			if (i == curSelected)
			{
				// keysGroup.members[curSelected].x = inicialKeyX + 10;
				keysGroup.members[curSelected].alpha = 1;
			}
			else
			{
				// keysGroup.members[i].x = inicialKeyX;
				keysGroup.members[i].alpha = 0.6;
			}
		}
	}
}
