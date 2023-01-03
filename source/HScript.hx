package;

import Paths;
import flixel.FlxG;
import haxe.io.Path;
import sys.FileSystem;

using StringTools;

#if hscript
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
#end

class HScript
{
	public static var parser:Parser = new Parser();

	public var hscript:Interp;
	public var variables:Interp;

	public function new()
	{
		hscript = new Interp();
		super();
	}
}
