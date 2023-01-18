package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var stage:String;
	var validScore:Bool;
	var hasDialogue:Bool;
}

typedef Config =
{
	var skipTo:Int;
	var scripts:Array<String>;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var stage:String = 'stage';

	public var hasDialogue:Bool = false;

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var checkFile = Assets.getText(Paths.json("songs/" + 'tutorial/tutorial')).trim();

		if (FileSystem.exists(Paths.json("songs/" + folder.toLowerCase() + '/' + jsonInput.toLowerCase())))
			checkFile = Assets.getText(Paths.json("songs/" + folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		if (FileSystem.exists(ModPaths.json("songs/" + folder.toLowerCase() + '/' + jsonInput.toLowerCase())))
			checkFile = Assets.getText(ModPaths.json("songs/" + folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		var rawJson = checkFile;

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;

		return swagShit;
	}
}
