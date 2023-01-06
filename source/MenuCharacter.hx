package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.utils.Assets;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

typedef MenuCharacterInfo =
{
	var path:String;
	var idleAnim:String;
	var confirmAnim:String;
	var scale:Float;
	var flipX:Bool;
	var offsets:Array<Float>;
};

class MenuCharacter extends FlxSprite
{
	public var character:String;

	var default_character:String = 'bf';

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		changeMenuCharacter(character);
	}

	function restartOptions()
	{
		setGraphicSize(Std.int(1));
		updateHitbox();

		offset.set(0, 0);
	}

	public function changeMenuCharacter(character:String)
	{
		if (character == this.character)
			return;

		this.character = character;

		var char:MenuCharacterInfo = Json.parse(Assets.getText(Paths.getPreloadPath('images/menuCharacters/${character}.json')));

		restartOptions();

		var tex = Paths.getSparrowAtlas("menuCharacters/images/" + char.path);
		frames = tex;

		animation.addByPrefix(character + "-idle", char.idleAnim, 24);

		if (char.confirmAnim != null || char.confirmAnim.length > 0)
			animation.addByPrefix(character + "-confirm", char.confirmAnim, 24);

		/*
			animation.addByPrefix('bf', "BF idle dance white", 24);
			animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
			animation.addByPrefix('gf', "GF Dancing Beat WHITE", 24);
			animation.addByPrefix('dad', "Dad idle dance BLACK LINE", 24);
			animation.addByPrefix('spooky', "spooky dance idle BLACK LINES", 24);
			animation.addByPrefix('pico', "Pico Idle Dance", 24);
			animation.addByPrefix('mom', "Mom Idle BLACK LINES", 24);
			animation.addByPrefix('parents-christmas', "Parent Christmas Idle", 24);
			animation.addByPrefix('senpai', "SENPAI idle Black Lines", 24);
		 */
		// Parent Christmas Idle

		flipX = (char.flipX == true);

		setGraphicSize(Std.int(width * char.scale));
		updateHitbox();

		offset.set(char.offsets[0], char.offsets[1]);

		playAnim("idle");
	}

	public function playAnim(name:String)
	{
		if (name == 'idle')
			animation.play(character + "-idle");
		if (name == 'confirm')
			animation.play(character + "-confirm");
	}
}
