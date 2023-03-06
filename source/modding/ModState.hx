package modding;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import modding.NewMod;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class ModState extends MusicBeatState
{
	var selector:FlxText;

	static var curSelected:Int = 0;

	public static var curMod:String = "";

	var stop:Bool = false;

	public static var modFolder:String = "mods"; // amongus

	public var mods:Array<String> = [];

	private var grpMods:FlxTypedGroup<Alphabet>;

	override function create()
	{
		super.create();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
		menuBG.color = 0xFF4D4D4D;
		menuBG.screenCenter();
		menuBG.updateHitbox();
		menuBG.scrollFactor.set();
		add(menuBG);

		var checkMODpath = modFolder;
		if (FileSystem.exists(checkMODpath))
			mods = FileSystem.readDirectory('${modFolder}/');
		else
		{
			Logs.error("No Mod Folder");
			FlxG.resetState();
			Logs.log("Creating the Mods Folder...", Logs.GREEN);
			FileSystem.createDirectory(checkMODpath);
		}

		grpMods = new FlxTypedGroup<Alphabet>();
		add(grpMods);

		mods.insert(0, "friday night funkin"); // BaseGame Option

		for (i in 0...mods.length)
		{
			var modsCool:Alphabet = new Alphabet(0, 50 + (i * 50), mods[i], true, false);
			modsCool.isMenuItem = true;
			modsCool.targetY = i;
			grpMods.add(modsCool);
		}

		var bottomBG = new FlxSprite(0, FlxG.height - 30).makeGraphic(FlxG.width, 30, 0xFF000000, true);
		bottomBG.alpha = 0.6;

		var modInfo = new FlxText(0, 0, FlxG.width, 'Mod Selected: ' + Save.modSelected);
		modInfo.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		modInfo.y = FlxG.height - 5 - modInfo.height;
		if (Save.modSelected == '')
			modInfo.text = 'No Mod Selected';

		modInfo.text += ' | [M] To Create A New Mod';
		modInfo.text += '.';

		add(bottomBG);
		add(modInfo);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (stop == false)
		{
			if (controls.DOWN_P)
			{
				changeSelection(1);
			}
			if (controls.UP_P)
			{
				changeSelection(-1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new options.OptionsState());
				stop = true;
			}

			if (FlxG.keys.justPressed.M)
			{
				FlxG.state.openSubState(new NewMod());
			}

			if (controls.ACCEPT)
			{
				if (mods[curSelected] == "friday night funkin")
					curMod = "";
				else
					curMod = mods[curSelected];

				Save.modSelected = curMod;

				Save.saveSettings();

				Logs.log("Mod Selected: " + Save.modSelected, Logs.GREEN);

				FlxG.switchState(new options.OptionsState());
				stop = true;
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected = FlxMath.wrap(curSelected + change, 0, grpMods.length - 1);

		var bullShit:Int = 0;
		for (item in grpMods.members)
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
