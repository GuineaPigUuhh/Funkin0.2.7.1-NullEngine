package scripting;

import hscript.*;
import scripting.*;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class ScriptPack
{
	public var scripts:Array<NullScript> = [];
	public var pushedScripts:Array<String> = [];

	public function new(folder:String)
	{
		if (FileSystem.exists(folder))
		{
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.endsWith('.hx') && !pushedScripts.contains(file))
				{
					var createDaScript:NullScript = new NullScript(folder + file);
					createDaScript.load();

					Logs.log("Script loaded: " + file, Logs.YELLOW);

					scripts.push(createDaScript);
					pushedScripts.push(file);
				}
			}
		}
	}

	public function set(name:String, value:Dynamic)
	{
		for (e in scripts)
			e.set(name, value);
	}

	public function call(name:String, value:Array<Dynamic>)
	{
		for (e in scripts)
			e.call(name, value);
	}
}
