package substates;

import dependency.MusicBeatSubstate;
import dependency.Paths;
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
import states.menus.ModMenuState;
import utils.CoolUtil;

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

				ModMenuState.curMod = modNameInput.text;
				FlxG.save.data.modSelected = modNameInput.text;

				FlxG.resetState(); // reload mods
			}

			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.mouse.visible = false;

				stopSpam = true;
				FlxG.state.closeSubState();
			}
		}
	}
}
