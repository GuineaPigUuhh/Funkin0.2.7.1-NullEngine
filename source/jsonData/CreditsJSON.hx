package jsonData;

import haxe.Json;
import haxe.format.JsonParser;
import modding.ModPaths;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef CreditJSON =
{
	var users:Array<CreditsStuff>;
}

typedef CreditsStuff =
{
	var name:String;
	var icon:String;
	var color:String;
	var message:String;
	var role:String;
	var category:String;
}

class CreditsJSON
{
	public static var users:Array<CreditsStuff>;

	public static function getJSON()
	{
		var path:String = ModPaths.json('creditList');
		if (!FileSystem.exists(path))
			path = Paths.json('creditList');

		var creditsJSON:CreditJSON = Json.parse(File.getContent(path));

		users = creditsJSON.users;
	}
}
