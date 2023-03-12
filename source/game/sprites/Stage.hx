package game.sprites;

import game.null_stuff.NullScript;
import game.scripting.Script;
import jsonHelper.JsonExtra.Point;

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
		stageScript = new NullScript(Script.getScriptPath('data/stages/${curStage}'));
		set("configureData", configureData);
		stageScript.load();

		call("onCreate", []);
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
