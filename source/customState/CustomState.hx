package;

#if desktop
import DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if hstate
import hstate.Expr;
import hstate.Interp;
import hstate.Parser;
#end

class CustomState extends MusicBeatState
{
	public static var daState:String = "";

	var state:hstate.Interp = new hstate.Interp();
	var stateLocal:String = 'NO STATE FILE';

	override function create()
	{
		#if hscript
		if (FileSystem.exists(Paths.getPreloadPath('states/${daState}.hx')))
		{
			stateLocal = File.getContent(Paths.getPreloadPath('states/${daState}.hx'));
			var parserState:hscript.Parser = new hscript.Parser();
			parserState.allowTypes = true;
			parserState.allowJSON = true;
			parserState.allowMetadata = true;

			addDefaultVariables();

			state.execute(parserState.parseString(scriptLocal));

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
		stateApply('create', [elapsed]);
		#end
	}

	override function update(elapsed:Float)
	{
		#if hscript
		stateApply('update', [elapsed]);
		#end
	}

	override function beatHit()
	{
		#if hscript
		stateApply('beatHit', [curBeat]);
		#end
	}

	override function stepHit()
	{
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

		var txt:FlxText = new FlxState(0, 0, texted);
		txt.screenCenter();
		add(txt);

		FlxTween.tween(txt, {alpha: 0.8}, 0.4, {type: PINGPONG});
	}

	public function stateApply(functionToCall:String, ?params:Array<Any>):Dynamic
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

	public function addDefaultVariables()
	{
		state.variables.set("add", add);
		state.variables.set("remove", remove);
		state.variables.set("destroy", destroy);

		state.variables.set("MusicBeatState", MusicBeatState);
		state.variables.set("DiscordClient", DiscordClient);
		state.variables.set("Paths", Paths);

		state.variables.set("Parser", hstate.Parser);
		state.variables.set("Interp", hstate.Interp);

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
