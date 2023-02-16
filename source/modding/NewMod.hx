package modding;

import Alphabet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxUIInputText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class NewMod extends MusicBeatSubstate
{
	var modNameInput:FlxUIInputText;
	var stopSpam:Bool = false;

	public function new()
	{
		super();

		FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.screenCenter();
		bg.alpha = 0.8;
		add(bg);

		modNameInput = new FlxUIInputText(0, 0, 500, "", 35);
		modNameInput.screenCenter();
		modNameInput.y -= 50;
		add(modNameInput);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (stopSpam == false)
		{
			if (controls.ACCEPT)
			{
				FlxG.mouse.visible = false;

				stopSpam = true;
				CoolUtil.createModFolder(modNameInput.text);
				FlxG.state.closeSubState();

				ModState.curMod = modNameInput.text;
				Save.modSelected = modNameInput.text;

				Save.saveSettings();

				FlxG.resetState(); // reload mods
			}
			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.mouse.visible = false;

				stopSpam = true;
				trace("Bye Bye!");
				FlxG.state.closeSubState();
			}
		}
	}
}
