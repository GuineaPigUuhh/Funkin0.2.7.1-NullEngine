package customState;

#if desktop
import DiscordClient;
#end
import MusicBeatState;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if hscript
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
#end

class CustomState extends MusicBeatState
{
	public static var daState:String = "";

	var state:hscript.Interp = new hscript.Interp();
	var stateLocal:String = 'NO STATE FILE';

	var curUpdate:Int = 1;
	var menubakcedd:Bool = false;

	var bfICON:HealthIcon; // for error state

	override function create()
	{
		super.create();
		#if hscript
		if (FileSystem.exists(Paths.hscript('states/${daState}')))
		{
			stateLocal = File.getContent(Paths.hscript('states/${daState}'));
			var parserState:hscript.Parser = new hscript.Parser();
			parserState.allowTypes = true;
			parserState.allowJSON = true;
			parserState.allowMetadata = true;

			addDefaultVariables();

			state.execute(parserState.parseString(stateLocal));

			trace("State: Success in Uploading the File");
		}
		else
		{
			trace("State: No File");
			generateErrorState("NO STATE FILE");
		}
		#else
		trace("State: Disabled Hscript");
		generateErrorState("Disabled Hscript");
		#end

		#if hscript
		stateApply('create', []);
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!FileSystem.exists(Paths.getPreloadPath('states/${daState}.hx')))
		{
			if (curUpdate == 1)
			{
				bfICON.scale.x = 1.2;
				bfICON.scale.y = 1.2;
				FlxTween.tween(bfICON.scale, {x: 1, y: 1}, 0.4, {ease: FlxEase.quadOut});

				FlxTween.tween(bfICON, {angle: 0}, 0.4, {ease: FlxEase.quadOut});

				curUpdate = 0;
				new FlxTimer().start(0.8, function(tmr:FlxTimer)
				{
					curUpdate = 1;
				});
			}

			if (controls.BACK && !menubakcedd)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				menubakcedd = true;
				FlxG.switchState(new MainMenuState());
			}
		}

		#if hscript
		stateApply('update', [elapsed]);
		#end
	}

	override function beatHit()
	{
		super.beatHit();

		#if hscript
		stateApply('beatHit', [curBeat]);
		#end
	}

	override function stepHit()
	{
		super.stepHit();
		#if hscript
		stateApply('stepHit', [curStep]);
		#end
	}

	function generateErrorState(named:String)
	{
		var texted:String = named;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('engine_stuff/menuDesatGradient'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var txt:FlxText = new FlxText(0, 0, 0, texted, 40);
		txt.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.screenCenter();
		txt.borderSize = 4;
		txt.alpha = 1;
		add(txt);

		FlxTween.tween(txt, {alpha: 0.6}, 0.8, {type: PINGPONG});

		bfICON = new HealthIcon("bf", false);
		bfICON.screenCenter(X);
		bfICON.y = 1000;
		bfICON.angle = 20;
		bfICON.playAnimation('bf-losing');
		add(bfICON);

		FlxTween.tween(bfICON, {y: txt.y + 20}, 0.6, {ease: FlxEase.circInOut});
		FlxTween.tween(bfICON, {angle: 0}, 0.6, {ease: FlxEase.circInOut, startDelay: 0.6});
	}

	function stateApply(functionToCall:String, ?params:Array<Any>):Dynamic
	{
		if (state == null)
		{
			return null;
		}
		if (state.variables.exists(functionToCall))
		{
			var functionH = state.variables.get(functionToCall);
			if (params == null)
			{
				var result = null;
				result = functionH();
				return result;
			}
			else
			{
				var result = null;
				result = Reflect.callMethod(null, functionH, params);
				return result;
			}
		}
		return null;
	}

	function addDefaultVariables()
	{
		state.variables.set("add", add);
		state.variables.set("remove", remove);
		state.variables.set("destroy", destroy);

		state.variables.set("MusicBeatState", MusicBeatState);
		state.variables.set("DiscordClient", DiscordClient);
		state.variables.set("Paths", Paths);

		state.variables.set("Parser", hscript.Parser);
		state.variables.set("Interp", hscript.Interp);

		#if sys
		state.variables.set("File", sys.io.File);
		state.variables.set("FileSystem", sys.FileSystem);
		state.variables.set("FlxGraphic", flixel.graphics.FlxGraphic);
		state.variables.set("BitmapData", openfl.display.BitmapData);
		#end

		state.variables.set("create", function()
		{
		});
		state.variables.set("update", function(elapsed:Float)
		{
		});

		state.variables.set("stepHit", function(curStep:Int)
		{
		});
		state.variables.set("beatHit", function(curBeat:Int)
		{
		});
	}
}
