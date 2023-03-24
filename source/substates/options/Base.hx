package substates.options;

import dependency.Logs;
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
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import game.sprites.Alphabet;
import game.sprites.Character;
import game.sprites.CheckBox;
import game.sprites.OptionSprite;
import lime.utils.Assets;
import states.menus.OptionsState;

using StringTools;

typedef Setting =
{
	var name:String;
	var value:String;
	var type:String;
	@:optional var onChange:() -> Void;
	// amongus
	@:optional var misc:
		{
			?min:Dynamic,
			?max:Dynamic,
			?addNumber:Dynamic,
			?scrollSpeed:Float
		};
}

class Base extends MusicBeatSubstate
{
	var curSelected:Int = 0;
	var falseBeatHit:Int = 1;

	public var options:Array<Setting> = [];

	var youCanPress:Bool = false;
	var stopSpam:Bool = false;

	private var grpOptions:FlxTypedGroup<OptionSprite>;

	var camFollow:FlxObject;

	public function new()
	{
		super();
	}

	override function create()
	{
		updatePrefs(); // create options

		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuNullEngine'));
		menuBG.scrollFactor.set();
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		grpOptions = new FlxTypedGroup<OptionSprite>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var option:OptionSprite = new OptionSprite(options[i].name, Reflect.getProperty(FlxG.save.data, options[i].value), i);
			grpOptions.add(option);
		}

		changeSelection();

		new FlxTimer().start(0.2, function(bruh:FlxTimer)
		{
			youCanPress = true;
		});

		FlxG.camera.follow(camFollow, null, 0.06);
	}

	override function update(elapsed:Float)
	{
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

			FlxG.state.closeSubState();
		}

		if (youCanPress == true)
		{
			changePrefs(options[curSelected].type);
		}
	}

	var dontChange:Bool = false;

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

								value -= Std.int(a.misc.addNumber);

								if (value < Std.int(a.misc.min))
								{
									value = Std.int(a.misc.min);
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.misc.scrollSpeed, function(tmr:FlxTimer)
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

								value += Std.int(a.misc.addNumber);

								if (value > Std.int(a.misc.max))
								{
									value = Std.int(a.misc.max);
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.misc.scrollSpeed, function(tmr:FlxTimer)
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

								value -= a.misc.addNumber;

								if (value < a.misc.min)
								{
									value = a.misc.min;
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.misc.scrollSpeed, function(tmr:FlxTimer)
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

								value += a.misc.addNumber;

								if (value > a.misc.max)
								{
									value = a.misc.max;
								}

								Reflect.setProperty(FlxG.save.data, a.value, value);
								dontChange = true;

								new FlxTimer().start(a.misc.scrollSpeed, function(tmr:FlxTimer)
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

		for (item in grpOptions.members)
		{
			item.updateAlpha(curSelected);
		}
		camFollow.setPosition(grpOptions.members[curSelected].optionText.x + 550, grpOptions.members[curSelected].optionText.y);
	}
}
