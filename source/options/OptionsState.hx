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

	var optionsCool:FlxText;

	var options:Array<String> = ['Preferences', 'Controls'];

	private var grpOptions:FlxTypedGroup<FlxText>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('engine_stuff/menuEngine'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<FlxText>();
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
		optionsCool = new FlxText(0, 50 + (idddd * 50), options[idddd], 50);
		optionsCool.setFormat(Paths.font("phantomuff.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionsCool.screenCenter(X);
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

		trace(curSelected);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpOptions.length - 1;
		if (curSelected >= grpOptions.length)
			curSelected = 0;
	}
}
