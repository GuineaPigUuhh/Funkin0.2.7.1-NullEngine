package states.menus;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import game.modding.ModIcon;
import game.modding.NewMod;
import game.sprites.Alphabet;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import states.menus.OptionsState;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class ModMenuState extends MusicBeatState
{
	var selector:FlxText;

	static var curSelected:Int = 0;

	public static var curMod:String = "";

	var stop:Bool = false;

	public static var modFolder:String = "mods"; // amongus

	//	public var mods:Array<String> = [];
	public var mods:Array<ModData> = [];

	var menuBG:FlxSprite;

	private var grpMods:FlxTypedGroup<Alphabet>;

	override function create()
	{
		super.create();

		menuBG = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
		menuBG.color = 0xFF4D4D4D;
		menuBG.screenCenter();
		menuBG.updateHitbox();
		menuBG.scrollFactor.set();
		add(menuBG);

		var checkMODpath = modFolder;
		if (!FileSystem.exists(checkMODpath))
		{
			Logs.error("No Mod Folder");
			FlxG.resetState();
			Logs.log("Creating the Mods Folder...", Logs.GREEN);
			FileSystem.createDirectory(checkMODpath);
		}

		grpMods = new FlxTypedGroup<Alphabet>();
		add(grpMods);

		for (m in FileSystem.readDirectory('${modFolder}/'))
		{
			if (FileSystem.isDirectory('${modFolder}/' + m))
			{
				var daFile:String = "_data";
				var path:String = '${modFolder}/' + m + '/${daFile}.json';

				var modData:ModData = {
					modName: m,
					modDesc: "",
					modVersion: "unknown",
					modColor: "7100e3"
				};

				if (FileSystem.exists(path))
					modData = Json.parse(File.getContent(path));

				mods.push(modData);
			}
		}

		for (i in 0...mods.length)
		{
			var modsCool:Alphabet = new Alphabet(0, 50 + (i * 50), mods[i].modName, true, false);
			modsCool.isMenuItem = true;
			modsCool.targetY = i;
			grpMods.add(modsCool);

			var modIcon:ModIcon = new ModIcon(mods[i].modName);
			modIcon.sprTracker = modsCool;
			add(modIcon);
		}

		var bottomBG = new FlxSprite(0, FlxG.height - 30).makeGraphic(FlxG.width, 30, 0xFF000000, true);
		bottomBG.alpha = 0.6;

		var modInfo = new FlxText(0, 0, FlxG.width, 'Mod Selected: ' + FlxG.save.data.modSelected);
		modInfo.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		modInfo.y = FlxG.height - 5 - modInfo.height;
		if (FlxG.save.data.modSelected == '')
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
				FlxG.switchState(new OptionsState());
				stop = true;
			}

			if (FlxG.keys.justPressed.M)
			{
				FlxG.state.openSubState(new NewMod());
			}

			if (controls.ACCEPT)
			{
				if (mods[curSelected].modName == "baseGame")
					curMod = "";
				else
					curMod = mods[curSelected].modName;

				FlxG.save.data.modSelected = curMod;

				Logs.log("Mod Selected: " + FlxG.save.data.modSelected, Logs.GREEN);

				FlxG.switchState(new OptionsState());
				stop = true;
			}
		}
	}

	var modColorTween:FlxTween = null;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected = FlxMath.wrap(curSelected + change, 0, grpMods.length - 1);

		if (modColorTween != null)
			modColorTween.cancel();
		modColorTween = FlxTween.color(menuBG, 0.4, menuBG.color, FlxColor.fromString("#" + mods[curSelected].modColor));

		mods[curSelected].modColor;

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

typedef ModData =
{
	var modName:String;
	var modDesc:String;
	var modVersion:String;
	var modColor:String;
}
