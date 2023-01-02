package;

using StringTools;

typedef Week =
{
	// coloque as variaves aqui man
	var image:String;
}

class WeekFile
{
	function getFile()
	{
		var local:String = ''; // coloque aonde vai ficar os arquivos
		// o path vai para data

		var path:String = Assets.getText(Paths.json(local)); // ignora man
		var file:WeekCustom = Json.parse(path); // ignora man
	}
}
