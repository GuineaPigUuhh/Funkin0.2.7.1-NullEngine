package states;

import dependency.MusicBeatState;
import dependency.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import game.Conductor;
import game.sprites.Note;
import game.sprites.StaticNote;

/**
 * uhum bilau funny
 */
class LatencyState extends FlxState
{
	var offsetText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var staticNote:StaticNote;

	override function create()
	{
		FlxG.sound.playMusic(Paths.sound('soundTest'));

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		staticNote = new StaticNote(0, 100, 2, 0);
		staticNote.screenCenter(X);
		staticNote.isPlayStated = false;
		add(staticNote);

		noteGrp = new FlxTypedGroup<Note>();
		add(noteGrp);

		var i:Int = 0;
		while (true)
		{
			i++;

			var note:Note = new Note(Conductor.crochet * i, 2, null, false, 0);
			note.screenCenter(X);
			noteGrp.add(note);
		}

		offsetText = new FlxText(0, 0);
		offsetText.screenCenter();
		add(offsetText);

		Conductor.changeBPM(120);

		super.create();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + Conductor.offset + "ms";

		Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

		var multiply:Float = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
		{
			Conductor.offset += 1 * multiply;
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			Conductor.offset -= 1 * multiply;
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();

			FlxG.resetState();
		}

		noteGrp.forEach(function(daNote:Note)
		{
			daNote.y = (staticNote.y - (Conductor.songPosition - daNote.strumTime) * 0.45);
			daNote.x = staticNote.x;

			if (daNote.y < staticNote.y)
			{
				daNote.kill();
			}
		});

		super.update(elapsed);
	}
}
