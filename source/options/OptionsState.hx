package options;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var optionsCool:Alphabet;

	var options:Array<String> = ['Preferences', 'Controls'];

	private var grpOptions:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			addOptions(i);
		}

		changeSelection();

		super.create();
	}

	function addOptions(idddd:Int)
	{
		optionsCool = new Alphabet(0, 50 + (idddd * 50), options[idddd], true, false);
		optionsCool.isMenuItem = true;
		optionsCool.targetY = idddd;
		grpOptions.add(optionsCool);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.UP_P)
			changeSelection(-1);

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		if (controls.ACCEPT)
		{
			switch (options[curSelected])
			{
				case "Preferences":
					FlxG.state.openSubState(new Preferences());
				case "Controls":
					trace('NOOOOOOOOO COTRO');
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpOptions.length - 1;
		if (curSelected >= grpOptions.length)
			curSelected = 0;

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
