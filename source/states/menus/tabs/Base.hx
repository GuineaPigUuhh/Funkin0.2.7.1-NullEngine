package states.menus.tabs;

import dependency.Logs;
import dependency.MusicBeatState;
import dependency.MusicBeatSubstate;
import dependency.Paths;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import game.sprites.Alphabet;
import game.sprites.Character;
import game.sprites.OptionSprite;
import lime.utils.Assets;
import states.menus.OptionsState;

using StringTools;

typedef Setting =
{
	var name:String;
	var value:String;
	var type:String;
	@:optional var desc:String;
	@:optional var onChange:() -> Void;

	@:optional var stringConfig:{array:Array<String>, scrollSpeed:Float};
	@:optional var floatConfig:
		{
			min:Float,
			max:Float,
			addNumber:Float,
			scrollSpeed:Float
		};
	@:optional var intConfig:
		{
			min:Int,
			max:Int,
			addNumber:Int,
			scrollSpeed:Float
		};
}

class Base extends MusicBeatState
{
	var curSelected:Int = 0;
	var falseBeatHit:Int = 1;

	public var options:Array<Setting> = [];

	var youCanPress:Bool = false;
	var stopSpam:Bool = false;

	private var grpOptions:FlxTypedGroup<OptionSprite>;

	public var descText:FlxText;
	public var descBG:FlxSprite;

	public function new()
	{
		super();
	}

	override function create()
	{
		updatePrefs(); // create options

		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menu_engine_1'));
		menuBG.scrollFactor.set();
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		grpOptions = new FlxTypedGroup<OptionSprite>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var option:OptionSprite = new OptionSprite(options[i].name, Reflect.getProperty(FlxG.save.data, options[i].value), i);
			grpOptions.add(option);
		}

		descBG = new FlxSprite(0, FlxG.height - 30).makeGraphic(FlxG.width, 30, 0xFF000000, true);
		descBG.alpha = 0.55;

		descText = new FlxText(0, 0, 2000, "");
		descText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 1.5;
		descText.y = FlxG.height - 5 - descText.height;

		add(descBG);
		add(descText);

		changeSelection();

		// new FlxTimer().start(0.2, function(bruh:FlxTimer)
		// {
		youCanPress = true;
		// });
	}

	var descSpeed:Float = 2;
	var startDescX:Float = -1880;

	override function update(elapsed:Float)
	{
		if (descText.visible == true)
		{
			descText.x += descSpeed;
			if (descText.x >= 1515)
			{
				descText.x = startDescX;
			}
		}

		if (stopSpam == false)
		{
			addKeys();
		}

		super.update(elapsed);
	}

	function addKeys()
	{
		if (controls.DOWN_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(1);
		}

		if (controls.UP_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(-1);
		}

		if (controls.BACK)
		{
			stopSpam = true;

			FlxG.switchState(new OptionsState());
		}

		if (youCanPress == true)
		{
			changePrefs(options[curSelected].type);
		}
	}

	var dontChange:Bool = false;
	var stringNumber:Int = 0;

	function changePrefs(type:String)
	{
		switch (type)
		{
			case "Bool":
				if (controls.ACCEPT)
				{
					for (a in options)
					{
						if (options[curSelected].name == a.name)
						{
							var value = Reflect.getProperty(FlxG.save.data, a.value);
							value = !value;

							Reflect.setProperty(FlxG.save.data, a.value, value);

							if (a.onChange != null)
							{
								a.onChange();
							}
						}
					}

					updatePrefs();
					grpOptions.members[curSelected].setValue(Reflect.getProperty(FlxG.save.data, options[curSelected].value));
				}
			case "Int":
				if (dontChange == false)
				{
					if (controls.LEFT)
					{
						for (a in options)
						{
							if (options[curSelected].name == a.name)
							{
								var value:Int = Reflect.getProperty(FlxG.save.data, a.value);

								value -= Std.int(a.intConfig.addNumber);

								if (value < Std.int(a.intConfig.min))
								{
									value = Std.int(a.intConfig.min);
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.intConfig.scrollSpeed, function(tmr:FlxTimer)
								{
									dontChange = false;
								});

								if (a.onChange != null)
								{
									a.onChange();
								}
							}
						}

						updatePrefs();
						grpOptions.members[curSelected].setValue(Reflect.getProperty(FlxG.save.data, options[curSelected].value));
					}

					if (controls.RIGHT)
					{
						for (a in options)
						{
							if (options[curSelected].name == a.name)
							{
								var value:Int = Reflect.getProperty(FlxG.save.data, a.value);

								value += Std.int(a.intConfig.addNumber);

								if (value > Std.int(a.intConfig.max))
								{
									value = Std.int(a.intConfig.max);
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.intConfig.scrollSpeed, function(tmr:FlxTimer)
								{
									dontChange = false;
								});

								if (a.onChange != null)
								{
									a.onChange();
								}
							}
						}

						updatePrefs();
						grpOptions.members[curSelected].setValue(Reflect.getProperty(FlxG.save.data, options[curSelected].value));
					}
				}

			case "Float":
				if (dontChange == false)
				{
					if (controls.LEFT)
					{
						for (a in options)
						{
							if (options[curSelected].name == a.name)
							{
								var value:Float = Reflect.getProperty(FlxG.save.data, a.value);

								value -= a.floatConfig.addNumber;

								if (value < a.floatConfig.min)
								{
									value = a.floatConfig.min;
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.floatConfig.scrollSpeed, function(tmr:FlxTimer)
								{
									dontChange = false;
								});

								if (a.onChange != null)
								{
									a.onChange();
								}
							}
						}

						updatePrefs();
						grpOptions.members[curSelected].setValue(Reflect.getProperty(FlxG.save.data, options[curSelected].value));
					}

					if (controls.RIGHT)
					{
						for (a in options)
						{
							if (options[curSelected].name == a.name)
							{
								var value:Float = Reflect.getProperty(FlxG.save.data, a.value);

								value += a.floatConfig.addNumber;

								if (value > a.floatConfig.max)
								{
									value = a.floatConfig.max;
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.floatConfig.scrollSpeed, function(tmr:FlxTimer)
								{
									dontChange = false;
								});

								if (a.onChange != null)
								{
									a.onChange();
								}
							}
						}

						updatePrefs();
						grpOptions.members[curSelected].setValue(Reflect.getProperty(FlxG.save.data, options[curSelected].value));
					}
				}

			case "String":
				if (dontChange == false)
				{
					if (controls.LEFT)
					{
						for (a in options)
						{
							if (options[curSelected].name == a.name)
							{
								var value:String = Reflect.getProperty(FlxG.save.data, a.value);

								stringNumber -= 1;
								if (stringNumber < 0)
								{
									stringNumber = 0;
								}
								value = a.stringConfig.array[stringNumber];

								Reflect.setProperty(FlxG.save.data, a.value, value);

								dontChange = true;

								new FlxTimer().start(a.stringConfig.scrollSpeed, function(tmr:FlxTimer)
								{
									dontChange = false;
								});

								if (a.onChange != null)
								{
									a.onChange();
								}
							}
						}

						updatePrefs();
						grpOptions.members[curSelected].setValue(Reflect.getProperty(FlxG.save.data, options[curSelected].value));
					}

					if (controls.RIGHT)
					{
						for (a in options)
						{
							if (options[curSelected].name == a.name)
							{
								var value:String = Reflect.getProperty(FlxG.save.data, a.value);

								stringNumber += 1;

								if (stringNumber > a.stringConfig.array[curSelected].length - 1)
								{
									stringNumber = a.stringConfig.array[curSelected].length - 1;
								}

								value = a.stringConfig.array[stringNumber];

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.stringConfig.scrollSpeed, function(tmr:FlxTimer)
								{
									dontChange = false;
								});

								if (a.onChange != null)
								{
									a.onChange();
								}
							}
						}

						updatePrefs();
						grpOptions.members[curSelected].setValue(Reflect.getProperty(FlxG.save.data, options[curSelected].value));
					}
				}
		}
	}

	public function updatePrefs()
	{
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);

		descBG.visible = false;
		descText.visible = false;

		descText.text = "";
		if (options[curSelected].desc != null || options[curSelected].desc != "")
		{
			descBG.visible = true;
			descText.visible = true;

			descText.x = startDescX;

			descText.text = options[curSelected].desc;
		}

		var bullShit:Int = 0;
		for (item in grpOptions.members)
		{
			item.optionText.targetY = bullShit - curSelected;
			bullShit++;

			if (Std.isOfType(item.daValue, Int) || Std.isOfType(item.daValue, Float) || Std.isOfType(item.daValue, String))
			{
				item.optionDaSelected.text = item.daValue;
			}
			item.alpha = 0.8;
			if (item.optionText.targetY == 0)
			{
				if (Std.isOfType(item.daValue, Int) || Std.isOfType(item.daValue, Float) || Std.isOfType(item.daValue, String))
				{
					item.optionDaSelected.text = item.updateText();
				}
				item.alpha = 1;
			}
		}
	}
}
