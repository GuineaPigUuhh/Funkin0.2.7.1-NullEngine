package game.sprites;

import dependency.Paths;
import flixel.graphics.frames.FlxAtlasFrames;
import game.null_stuff.NullScript;
import game.scripting.Script;
import haxe.Json;
import haxe.format.JsonParser;
import states.PlayState;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Stage
{
	public var curStage:String = "";

	public var data:StageData;

	var stageScript:NullScript;

	public function new(curStage:String)
	{
		this.curStage = curStage;

		executeScript();
		getData(false);
	}

	function executeScript()
	{
		stageScript = new NullScript(Script.getScriptPath('stages/${curStage}/assets'));
		set("game", PlayState.instance);
		set("songName", PlayState.SONG.song.toLowerCase());
		set("daPixelZoom", PlayState.daPixelZoom);

		set("stageImage", stageImage);
		set("stageSparrowAtlas", stageSparrowAtlas);
		set("stagePackerAtlas", stagePackerAtlas);
		stageScript.load();

		call("onCreate", []);
	}

	function getData(onlyDataFile:Bool = false)
	{
		var path:String = Paths.getPreloadPath('stages/${curStage}/data.json');
		if (onlyDataFile == true)
			path = Paths.getPreloadPath('stages/${curStage}.json');

		data = Json.parse(File.getContent(path));
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

	public function set(aa:String, di:Dynamic)
	{
		stageScript.set(aa, di);
	}

	public function call(aa:String, array:Array<Dynamic>)
	{
		stageScript.call(aa, array);
	}
}

/**
 * haha funkin stage data system
 */
typedef StageData =
{
	var camZoom:Float;
	var camSpeed:Float;
	// cool separation
	var playerPosition:Array<Float>;
	var spectatorPosition:Array<Float>;
	var opponentPosition:Array<Float>;
}
