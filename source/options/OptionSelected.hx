package options;

import Character;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;

class OptionSelected extends MusicBeatSubstate
{
	var type:String;
	var grpStrings:FlxTypedGroup<FlxText>;

	var strings:Array<String> = [];
	var intValues:Array<Int> = [0, 0];

	var isString:Bool = false;
	var isInt:Bool = false;

	public static var returnDaValue:Dynamic = null;

	public function new(type:String, ?returnStrings:Array<String>, ?intMAX:Int, ?intMIN:Int)
	{
		strings = [];
		intValues = [0, 0];

		returnDaValue = null;

		if (returnStrings == null)
		{
			returnStrings = [];
		}

		if (returnStrings != [])
		{
			isString = true;
			strings = returnStrings;
		}

		if (intMAX != null)
		{
			isInt = true;
			intValues[0] = intMAX;
		}

		if (intMIN != null)
		{
			isInt = true;
			intValues[1] = intMIN;
		}

		this.type = type;
	}

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.screenCenter();
		bg.alpha = 0.8;
		add(bg);

		if (isString)
		{
			grpStrings = new FlxTypedGroup<FlxText>();
			add(grpStrings);

			for (i in 0...strings.length)
			{
				var stringText:FlxText = new FlxText(0, 200 + (i * 30), 1280, "", 20);
				stringText.scrollFactor.set();
				stringText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				stringText.borderSize = 3;

				grpStrings.add(stringText);
			}
		}

		if (isInt)
		{
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
