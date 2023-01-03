package;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef StagePro =
{
	var objects:Array<Objects>;
	var animateObjects:Array<ObjectsWithAnimation>;
	var boyfriend:Array<Float>;
	var gf:Array<Float>;
	var dad:Array<Float>;
	var defaultZoom:Float;
}

typedef Objects =
{
	var image:String;
	var position:Array<Float>;
	var scrollFactor:Array<Float>;
	var scaleSet:Float;
	var antialiasing:Bool;
}

typedef ObjectsWithAnimation =
{
	var image:String;
	var position:Array<Float>;
	var scrollFactor:Array<Float>;
	var scaleSet:Float;
	var animations:Array<String>;
	var antialiasing:Bool;
}

class StageFile
{
	public var objects:Array<Objects>;

	public var boyfriend:Array<Float>;
	public var gf:Array<Float>;
	public var dad:Array<Float>;

	public var defaultZoom:Float;

	public function new(stage:StagePro)
	{
		objects = stage.objects;
		boyfriend = stage.boyfriend;
		gf = stage.gf;
		dad = stage.dad;
		defaultZoom = stage.defaultZoom;
	}

	public static function getPath(named:String)
	{
		var local:String = 'stages/${named}/data.json';
		var path:String = Paths.getPreloadPath(local);

		return cast path;
	}

	public static function getPathImage(named:String, ob:String)
	{
		var local:String = 'stages/${named}/images/' + ob;
		var path:String = Paths.getPreloadPath(local);

		return cast path;
	}

	public static function getFile(named:String)
	{
		var local:String = 'stages/${named}/data.json';

		var path:String = Assets.getText(Paths.getPreloadPath(local));
		var file:StagePro = Json.parse(path);

		return cast file;
	}
}
