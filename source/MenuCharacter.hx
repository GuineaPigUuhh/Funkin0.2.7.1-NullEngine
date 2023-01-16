package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.utils.Assets;
#if sys
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
		visible = true;

		setGraphicSize(Std.int(1));
		updateHitbox();

		offset.set(0, 0);
	}

	public function changeMenuCharacter(character:String)
	{
		if (character == this.character)
			return;

		this.character = character;

		switch (character)
		{
			case "":
				visible = false;

			default:
				var checkJSON = Json.parse(Assets.getText(Paths.getPreloadPath('images/menuCharacters/bf.json')));

				if (FileSystem.exists(Paths.getPreloadPath('images/menuCharacters/${character}.json')))
					checkJSON = Json.parse(Assets.getText(Paths.getPreloadPath('images/menuCharacters/${character}.json')));
				if (FileSystem.exists(Paths.getModPath('images/menuCharacters/${character}.json')))
					checkJSON = Json.parse(Assets.getText(Paths.getModPath('images/menuCharacters/${character}.json')));

				var char:MenuCharacterInfo = checkJSON;

				restartOptions();

				frames = Paths.getSparrowAtlas("menuCharacters/images/" + char.path);

				animation.addByPrefix(character + "-idle", char.idleAnim, 24);

				if (char.confirmAnim != null || char.confirmAnim.length > 0)
					animation.addByPrefix(character + "-confirm", char.confirmAnim, 24);

				flipX = (char.flipX == true);

				setGraphicSize(Std.int(width * char.scale));
				updateHitbox();

				offset.set(char.offsets[0], char.offsets[1]);

				playAnim("idle");
		}
	}

	public function playAnim(name:String)
	{
		if (name == 'idle')
			animation.play(character + "-idle");
		if (name == 'confirm')
			animation.play(character + "-confirm");
	}
}
