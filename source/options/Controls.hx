package options;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;

using StringTools;

class Controls extends MusicBeatSubstate
{
	var selector:FlxText;

	var curSelected:Int = 0;

	var optionsCool:Alphabet;

	public var options:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "LEFT ALT", "DOWN ALT", "UP ALT", "RIGHT ALT"];
	public var keys:Array<String> = [];
	public var tempKey:String = "";
	public var defaultKeys:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "A", "S", "W", "D"];

	var blacklist:Array<String> = ["ESCAPE", "ENTER", "BACKSPACE", "SPACE"];

	var state:String = 'normal';

	var youCanPress:Bool = false;
	var stopSpam:Bool = false;

	private var grpOptions:FlxTypedGroup<Alphabet>;

	public function new()
	{
		updateKeys();

		super();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('engine_stuff/menuEngine'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			optionsCool = new Alphabet(0, 50 + (i * 50), options[i] + " " + keys[i], true, false);
			optionsCool.isMenuItem = true;
			optionsCool.targetY = i;
			grpOptions.add(optionsCool);
		}

		new FlxTimer().start(0.2, function(bruh:FlxTimer)
		{
			youCanPress = true;
		});

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (state)
		{
			case "normal":
				if (stopSpam == false)
				{
					if (FlxG.keys.justPressed.DOWN)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						changeSelection(1);
					}

					if (FlxG.keys.justPressed.UP)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						changeSelection(-1);
					}

					if (FlxG.keys.justPressed.BACKSPACE)
					{
						FlxG.state.closeSubState();
					}

					if (youCanPress == true)
						if (FlxG.keys.justPressed.ENTER)
							timeForChangeKey();
				}
			case "waiting":
				if (FlxG.keys.justPressed.ESCAPE)
				{
					keys[curSelected] = tempKey;

					grpOptions.remove(grpOptions.members[curSelected]);

					updateKeys();

					optionsCool = new Alphabet(0, 50 + (curSelected * 50), options[curSelected] + " " + keys[curSelected], true, false);
					optionsCool.isMenuItem = true;
					grpOptions.add(optionsCool);

					state = "normal";
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}

				if (FlxG.keys.justPressed.ANY)
				{
					changeKey(FlxG.keys.getIsDown()[0].ID.toString());
					state = "normal";
				}
			default:
				state = "normal";
		}
	}

	function timeForChangeKey()
	{
		state = "waiting";

		tempKey = keys[curSelected];
		keys[curSelected] = "none";
		saveKeys();

		grpOptions.remove(grpOptions.members[curSelected]);

		updateKeys();

		optionsCool = new Alphabet(0, 50 + (curSelected * 50), options[curSelected] + " " + keys[curSelected], true, false);
		optionsCool.isMenuItem = true;
		grpOptions.add(optionsCool);
	}

	function changeKey(newKey:String = "?")
	{
		addKey(newKey);
		saveKeys();

		grpOptions.remove(grpOptions.members[curSelected]);

		updateKeys();

		optionsCool = new Alphabet(0, 50 + (curSelected * 50), options[curSelected] + " " + keys[curSelected], true, false);
		optionsCool.isMenuItem = true;
		grpOptions.add(optionsCool);
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
			for (x in options)
			{
				if (x != options[curSelected])
				{
					notAllowed.push(x);
				}
			}
		}
		else
		{
			for (x in options)
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
			trace("FUCK");
		}
	}

	function saveKeys()
	{
		for (i in 0...Save.controls.length)
			Save.controls[i] = keys[i];

		Save.saveSettings();
	}

	function updateKeys()
	{
		for (i in 0...Save.controls.length)
			keys[i] = Save.controls[i];
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);

		var bullShit:Int = 0;
		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
