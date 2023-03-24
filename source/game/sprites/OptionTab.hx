package game.sprites;

import dependency.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.sprites.Alphabet;
import states.menus.OptionsState.Tab;

class OptionTab extends FlxSpriteGroup
{
	public var optionText:Alphabet;
	public var optionDesc:FlxText;

	public var daID:Int = 0;

	public function new(customTab:Tab, number:Int)
	{
		super();

		daID = number;

		optionText = new Alphabet(0, 50 + (daID * 145), customTab.name, true, false);
		add(optionText);

		optionDesc = new FlxText(optionText.x, optionText.y + 70, 300, customTab.desc, 18);
		optionDesc.setFormat(Paths.font("phantomuff.ttf"), 18, FlxColor.WHITE, LEFT);
		add(optionDesc);
	}

	public function updateAlpha(curSelected:Int)
	{
		optionText.alpha = 0.8;
		optionDesc.alpha = 0.8;

		if (daID == curSelected)
		{
			optionText.alpha = 1;
			optionDesc.alpha = 1;
		}
	}
}
