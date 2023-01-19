package scriptCode;

import animateatlas.AtlasFrameMaker;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxShader;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import llua.Convert;
import llua.Lua;
import llua.LuaL;
import llua.State;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if desktop
import Discord;
#end

class LuaScript
{
	public var lua:State = null;
	public var scriptPath = "";

	public function new(scriptPath:String)
	{
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

		this.scriptPath = scriptPath;

		set('curBpm', Conductor.bpm);
		set('curBeat', 0);
		set('curStep', 0);
	}

	function luaTrace(title:String, message:String)
	{
		lime.app.Application.current.window.alert(message, title);
	}
}
