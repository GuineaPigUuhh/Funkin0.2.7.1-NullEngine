package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Exception;
import haxe.Json;
import haxe.format.JsonParser;
import haxe.xml.Access;
import jsonData.CharacterJSON;
import lime.utils.Assets;
import modding.ModPaths;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;

	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var singDuration:Float = 4;

	public var isGf:Bool = false;

	public var healthBarColor:String = "A1A1A1";
	public var healthIcon:String = "face";

	var DEFAULT_CHARACTER:String = "face";
	var vanillaCharsPath:String = "characters/spritesheets/";

	public var cameraPosition:FlxPoint = new FlxPoint(0, 0);
	public var charPosition:FlxPoint = new FlxPoint(0, 0);

	var xPOS:Float = 0;
	var yPOS:Float = 0;

	public var isGameOver:Bool = false;

	public function new(xPOS:Float, yPOS:Float, curCharacter:String, ?isPlayer:Bool = false)
	{
		this.xPOS = xPOS;
		this.yPOS = yPOS;
		this.isPlayer = isPlayer;

		this.curCharacter = curCharacter;

		super(xPOS, yPOS);

		animOffsets = new Map<String, Array<Dynamic>>();

		createCharacter(this.curCharacter);
	}

	function createCharacter(char:String)
	{
		var tex:FlxAtlasFrames;
		antialiasing = Save.antialiasing;

		var fileSys = FileSystem.exists(CharacterJSON.jsonPath(char));
		if (fileSys)
			generateJSONcharacter(char);
		else
			generateSOURCEcharacter(char);

		dance();

		if (isPlayer)
		{
			flipX = !flipX;
		}
	}

	function getMAP()
	{
		var charactersColors:Map<String, String> = [
			// for source code Characters
			"bf-car" => "31B0D1",
			"bf-christmas" => "31B0D1",
			"bf-pixel" => "7BD6F6",
			"dad" => "AF66CE",
			"gf" => "A5004D",
			"mom" => "D8558E",
			"mom-car" => "D8558E",
			"monster" => "F3FF6E",
			"monster-christmas" => "F3FF6E",
			"parents-christmas" => "CD599E",
			"pico" => "B7D855",
			"senpai" => "FFAA6F",
			"senpai-angry" => "FFAA6F",
			"spirit" => "FF3C6E",
			"spooky" => "D57E00"
		];

		var charactersIcons:Map<String, String> = [
			"bf-car" => "bf",
			"bf-christmas" => "bf",
			"bf-pixel" => "bf-pixel",
			"dad" => "dad",
			"gf" => "gf",
			"mom" => "mom",
			"mom-car" => "mom",
			"monster" => "monster",
			"monster-christmas" => "monster",
			"parents-christmas" => "parents-christmas",
			"pico" => "pico",
			"senpai" => "senpai",
			"senpai-angry" => "senpai",
			"spirit" => "spirit",
			"spooky" => "spooky"
		];

		// for hard code Characters
		if (charactersColors.exists(curCharacter))
			healthBarColor = charactersColors.get(curCharacter);
		if (charactersIcons.exists(curCharacter))
			healthIcon = charactersIcons.get(curCharacter);
	}

	public function getCamPos(gf:Bool = false) // IS SUS
	{
		var midpoint = getMidpoint();
		var point:FlxPoint = null;

		if (gf == true) // if IsGF
		{
			point = new FlxPoint(midpoint.x, midpoint.y);
		}
		else if (isPlayer == true)
		{
			point = new FlxPoint(midpoint.x - 100, midpoint.y - 100);
		}
		else
		{
			point = new FlxPoint(midpoint.x + 150, midpoint.y - 100);
		}

		point.x += cameraPosition.x;
		point.y += cameraPosition.y;

		return point;
	}

	public function setCharacterPosition(ggff:Character)
	{
		if (isGf || curCharacter.startsWith('gf')) // if trans?
		{
			setPosition(PlayState.GF_POS[0], PlayState.GF_POS[1]);
			scrollFactor.set(0.95, 0.95);
			ggff.visible = false;
		}

		x += charPosition.x;
		y += charPosition.y;
	}

	function generateSOURCEcharacter(char:String)
	{
		getMAP();

		switch (char)
		{
			case 'gf':
				// GIRLFRIEND CODE
				setTex(vanillaCharsPath + "GF_assets", "XML");

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				setTex(vanillaCharsPath + "gfChristmas", "XML");

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				setTex(vanillaCharsPath + "gfCar", "XML");

				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				setTex(vanillaCharsPath + "gfPixel", "XML");

				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				setTex(vanillaCharsPath + "DADDY_DEAREST", "XML");

				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky':
				setTex(vanillaCharsPath + "spooky_kids_assets", "XML");

				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				setTex(vanillaCharsPath + "Mom_Assets", "XML");

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				setTex(vanillaCharsPath + "momCar", "XML");

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				setTex(vanillaCharsPath + "Monster_Assets", "XML");

				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				setTex(vanillaCharsPath + "monsterChristmas", "XML");

				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				setTex(vanillaCharsPath + "Pico_FNF_assetss", "XML");

				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;

			case 'bf-gameOver':
				setTex(vanillaCharsPath + "bf-dead", "XML");

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.play('firstDeath');

				addOffset('firstDeath', -10, 0);
				addOffset('deathLoop', -10, 0);
				addOffset('deathConfirm', -10, 0);

				playAnim('firstDeath');

				flipX = true;
				isGameOver = true;

			case 'bf-christmas':
				setTex(vanillaCharsPath + "bfChristmas", "XML");

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				setTex(vanillaCharsPath + "bfCar", "XML");

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				setTex(vanillaCharsPath + "bfPixel", "XML");

				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				setTex(vanillaCharsPath + "bfPixelsDEAD", "XML");

				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;
				isGameOver = true;

			case 'senpai':
				setTex(vanillaCharsPath + "senpai", "XML");

				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				setTex(vanillaCharsPath + "senpai", "XML");

				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				setTex(vanillaCharsPath + "spirit", "TEXT");

				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				setTex(vanillaCharsPath + "mom_dad_christmas_assets", "XML");

				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
		}
	}

	function generateJSONcharacter(char:String)
	{
		CharacterJSON.getJSON(char);

		var funkinSprite = Paths.getSparrowAtlas("characters/spritesheets/" + CharacterJSON.prefs.spriteSheet);

		var textFile = Paths.getPreloadPath("characters/spritesheets/" + CharacterJSON.prefs.spriteSheet + ".txt");
		if (FileSystem.exists(textFile))
			funkinSprite = Paths.getPackerAtlas("characters/spritesheets/" + CharacterJSON.prefs.spriteSheet);

		frames = funkinSprite;

		var antiChar = CharacterJSON.prefs.antialiasing;
		antialiasing = (antiChar ? Save.antialiasing : false);

		isGf = CharacterJSON.prefs.isGF;
		flipX = (CharacterJSON.prefs.flipX == true);

		var getSingDuration = CharacterJSON.prefs.singDuration;
		singDuration = getSingDuration;

		healthIcon = CharacterJSON.prefs.icon;
		healthBarColor = CharacterJSON.prefs.healthBarColor;

		cameraPosition.x = CharacterJSON.prefs.cameraOffset.x;
		cameraPosition.y = CharacterJSON.prefs.cameraOffset.y;

		charPosition.x = CharacterJSON.prefs.charOffset.x;
		charPosition.y = CharacterJSON.prefs.charOffset.y;

		if (CharacterJSON.prefs.setScale != 1)
		{
			scale.set(CharacterJSON.prefs.setScale, CharacterJSON.prefs.setScale);
			updateHitbox();
		}

		if (CharacterJSON.anims != null && CharacterJSON.anims.length > 0)
		{
			for (charAnims in CharacterJSON.anims)
			{
				if (charAnims.indices != null && charAnims.indices.length > 0)
				{
					animation.addByIndices(charAnims.animName, charAnims.animPrefix, charAnims.indices, "", charAnims.fps, charAnims.loop);
				}
				else
				{
					animation.addByPrefix(charAnims.animName, charAnims.animPrefix, charAnims.fps, charAnims.loop);
				}

				if (charAnims.offsets != null)
					addOffset(charAnims.animName, charAnims.offsets.x, charAnims.offsets.y);
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			if (holdTimer >= Conductor.stepCrochet * (0.0011 / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1)) * singDuration)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		if (isPlayer)
		{
			if (!debugMode && animation.curAnim != null)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}
				else
					holdTimer = 0;

				if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished)
					playAnim('idle', true, false, 10);

				if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
				{
					playAnim('deathLoop');
				}
			}
		}
		super.update(elapsed);
	}

	public inline function getIcon()
	{
		var icon = ((healthIcon != null) ? healthIcon : curCharacter);
		return icon;
	}

	public inline function getHealthColor()
	{
		var color = FlxColor.fromString("#" + healthBarColor);
		return color;
	}

	function setTex(path:String, hereAtlasType:String)
	{
		var export:FlxAtlasFrames = Paths.getSparrowAtlas("characters/face");
		switch (hereAtlasType)
		{
			default:
				hereAtlasType = "XML";
			case "XML":
				export = Paths.getSparrowAtlas(path);
			case "TEXT":
				export = Paths.getPackerAtlas(path);
		}

		return frames = export;
	}

	function flipAnimations()
	{
		var oldRight = animation.getByName('singRIGHT').frames;
		var oldLeft = animation.getByName('singLEFT').frames;

		animation.getByName('singRIGHT').frames = oldLeft;
		animation.getByName('singLEFT').frames = oldRight;

		if (animation.getByName('singRIGHTmiss') != null || animation.getByName('singLEFTmiss') != null)
		{
			var oldRightMiss = animation.getByName('singRIGHTmiss').frames;
			var oldLeftMiss = animation.getByName('singLEFTmiss').frames;

			animation.getByName('singRIGHTmiss').frames = oldLeftMiss;
			animation.getByName('singLEFTmiss').frames = oldRightMiss;
		}

		var oldRight = animOffsets["singRIGHT"];
		var oldLeft = animOffsets["singLEFT"];
		animOffsets["singRIGHT"] = oldLeft;
		animOffsets["singLEFT"] = oldRight;
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	var notesID:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];

	public function playSingAnimations(Dir:Int, end:String = "", Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		playAnim("sing" + notesID[Dir] + end.toLowerCase(), Force, Reversed, Frame);
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf' || isGf == true)
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
