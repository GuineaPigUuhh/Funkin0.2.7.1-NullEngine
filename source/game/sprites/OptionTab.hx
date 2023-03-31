package game.sprites;

import dependency.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
		optionText.isMenuItem = true;
		optionText.targetY = daID;
		add(optionText);

		optionDesc = new FlxText(0, 0, 850, customTab.desc, 18);
		optionDesc.setFormat(Paths.font("phantomuff.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionDesc.borderSize = 2.45;
		add(optionDesc);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		optionDesc.x = optionText.x + 15;
		optionDesc.y = optionText.y + 70;
	}
}
