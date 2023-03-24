var camMove:Bool = false;

function onBeatHit(curBeat)
{
	if (curBeat == 128)
	{
		blammedChars();
		blammedIcons();

		camMove = true;

		FlxG.camera.flash(0xffffff, 0.6);
	}

	if (curBeat == 192)
	{
		backCharacters();
		backIcons();

		camMove = false;

		FlxG.camera.flash(0xffffff, 0.6);
	}
}

var camNumber:Float = 25;

function camMoveSexy(char, daNote)
{
	if (camMove == true)
	{
		switch (daNote.noteData)
		{
			case 0:
				camFollow.x = char.getCamPos(false).x - camNumber;
			case 1:
				camFollow.y = char.getCamPos(false).y + camNumber;
			case 2:
				camFollow.y = char.getCamPos(false).y - camNumber;
			case 3:
				camFollow.x = char.getCamPos(false).x + camNumber;
		}
	}
}

function onPlayerHit(daNote)
{
	camMoveSexy(player, daNote);
}

function onCpuHit(daNote)
{
	camMoveSexy(opponent, daNote);
}

function blammedChars()
{
	remove(player);
	remove(opponent);

	player.createCharacter("bf-blammed");
	opponent.createCharacter("pico-blammed");

	add(player);
	add(opponent);
}

function blammedIcons()
{
	remove(game.iconP1);
	remove(game.iconP2);

	game.iconP1.changeIcon("bf-blammed");
	game.iconP2.changeIcon("pico-blammed");

	reloadHealthColors();

	add(game.iconP1);
	add(game.iconP2);
}

function backCharacters()
{
	remove(player);
	remove(opponent);

	player.createCharacter("bf");
	opponent.createCharacter("pico");

	add(player);
	add(opponent);
}

function backIcons()
{
	remove(game.iconP1);
	remove(game.iconP2);

	game.iconP1.changeIcon("bf");
	game.iconP2.changeIcon("pico");

	reloadHealthColors();

	add(game.iconP1);
	add(game.iconP2);
}
