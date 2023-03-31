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

class OptionSprite extends FlxSpriteGroup
{
	public var optionDaSelected:FlxText;
	public var optionText:Alphabet;

	public var daValue:Dynamic = false;
	public var daID:Int = 0;

	// cool value

	public function new(name:String, value:Dynamic, number:Int)
	{
		super();

		daValue = value;
		daID = number;

		optionText = new Alphabet(0, (daID * 95), name, false, false);
		optionText.isMenuItem = true;
		optionText.targetY = daID;
		add(optionText);

		optionDaSelected = new FlxText(optionText.x + optionText.width + 40, optionText.y + 76);
		optionDaSelected.setFormat(Paths.font("phantomuff.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionDaSelected.text = updateText();
		optionDaSelected.color = updateTextColor();
		optionDaSelected.borderSize = 2.65;
		add(optionDaSelected);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		optionDaSelected.x = optionText.x + optionText.width + 43;
		optionDaSelected.y = optionText.y + 76;
	}

	var textTween:FlxTween = null;

	public function setValue(coolValue:Dynamic)
	{
		daValue = coolValue;

		optionDaSelected.scale.set(1.25, 0.83);

		if (textTween != null)
			textTween.cancel();
		textTween = FlxTween.tween(optionDaSelected.scale, {x: 1, y: 1}, 0.54, {ease: FlxEase.circOut});

		optionDaSelected.text = updateText();
		optionDaSelected.color = updateTextColor();
	}

	public function updateText():String
	{
		if (Std.isOfType(daValue, Bool))
		{
			return (daValue ? "On" : "Off");
		}
		if (Std.isOfType(daValue, Int) || Std.isOfType(daValue, Float) || Std.isOfType(daValue, String))
		{
			return '< ${daValue} >';
		}

		return "";
	}

	public function updateTextColor():Int
	{
		if (Std.isOfType(daValue, Bool))
		{
			return (daValue ? FlxColor.LIME : FlxColor.RED);
		}
		return FlxColor.WHITE;
	}
}
