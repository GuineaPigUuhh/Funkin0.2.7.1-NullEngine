package game.sprites;

import dependency.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.sprites.Alphabet;

class OptionSprite extends FlxSpriteGroup
{
	public var optionDaSelected:FlxText;
	public var optionText:Alphabet;

	public var daValue:Dynamic = false;
	public var daID:Int = 0;

	public function new(name:String, value:Dynamic, number:Int)
	{
		super();

		daValue = value;
		daID = number;

		optionText = new Alphabet(0, (daID * 95), name, false, false);
		add(optionText);

		optionDaSelected = new FlxText(optionText.x + 575, optionText.y + 76);
		optionDaSelected.setFormat(Paths.font("phantomuff.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionDaSelected.text = updateText();
		optionDaSelected.color = updateTextColor();
		optionDaSelected.borderSize = 2.65;
		add(optionDaSelected);
	}

	public function setValue(coolValue:Dynamic)
	{
		daValue = coolValue;

		optionDaSelected.text = updateText();
		optionDaSelected.color = updateTextColor();
	}

	function updateText():String
	{
		if (Std.isOfType(daValue, Bool))
		{
			return (daValue ? "On" : "Off");
		}
		if (Std.isOfType(daValue, Int) || Std.isOfType(daValue, Float))
		{
			return '< ${daValue} >';
		}
		return "";
	}

	public function updateAlpha(curSelected:Int)
	{
		optionDaSelected.alpha = 0.8;
		optionText.alpha = 0.8;

		if (daID == curSelected)
		{
			optionDaSelected.alpha = 1;
			optionText.alpha = 1;
		}
	}

	function updateTextColor():Int
	{
		if (Std.isOfType(daValue, Bool))
		{
			return (daValue ? FlxColor.LIME : FlxColor.RED);
		}
		return FlxColor.WHITE;
	}
}
