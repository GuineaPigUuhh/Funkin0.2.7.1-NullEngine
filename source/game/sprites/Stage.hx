package game.sprites;

import dependency.Paths;
import flixel.graphics.frames.FlxAtlasFrames;
import game.null_stuff.NullScript;
import game.scripting.Script;
import jsonHelper.JsonExtra.Point;
import states.PlayState;

class Stage
{
	public var curStage:String = "";
	public var stageData:
		{
			zoom:Float,
			boyfriendPos:Array<Float>,
			dadPos:Array<Float>,
			gfPos:Array<Float>
		} = {
			zoom: 1.05,
			boyfriendPos: [0, 0],
			dadPos: [0, 0],
			gfPos: [0, 0]
		};

	var stageScript:NullScript;

	public function new(curStage:String)
	{
		this.curStage = curStage;
		executeScript();
	}

	function executeScript()
	{
		stageScript = new NullScript(Script.getScriptPath('stages/${curStage}/${curStage}'));
		set("configureData", configureData);
		set("game", PlayState.instance);
		set("songName", PlayState.SONG.song.toLowerCase());
		set("daPixelZoom", PlayState.daPixelZoom);

		set("stageImage", stageImage);
		set("stageSparrowAtlas", stageSparrowAtlas);
		set("stagePackerAtlas", stagePackerAtlas);
		stageScript.load();

		call("onCreate", []);
	}

	function stageImage(key:String)
	{
		return Paths.getPreloadPath('stages/$curStage/images/$key.png');
	}

	function stageSparrowAtlas(key:String)
	{
		return FlxAtlasFrames.fromSparrow(stageImage(key), Paths.getPreloadPath('stages/$curStage/images/$key.xml'));
	}

	function stagePackerAtlas(key:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(stageImage(key), Paths.getPreloadPath('stages/$curStage/images/$key.txt'));
	}

	public function configureData(zoomSet:Float, bfPosSet:Array<Float>, dadPosSet:Array<Float>, gfPosSet:Array<Float>)
	{
		stageData = {
			zoom: zoomSet,
			boyfriendPos: bfPosSet,
			dadPos: dadPosSet,
			gfPos: gfPosSet
		};
	}

	public function set(aa:String, di:Dynamic)
	{
		stageScript.set(aa, di);
	}

	public function call(aa:String, array:Array<Dynamic>)
	{
		stageScript.call(aa, array);
	}
}
