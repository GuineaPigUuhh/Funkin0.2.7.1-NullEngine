var halloweenBG:FlxSprite;
var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;

function onCreate()
{
	var hallowTex = stageSparrowAtlas('bg');

	halloweenBG = new FlxSprite(-200, -100);
	halloweenBG.frames = hallowTex;
	halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	halloweenBG.animation.play('idle');
	halloweenBG.antialiasing = FlxG.save.data.antialiasing;
	add(halloweenBG);
}

function onBeatHit(curBeat)
{
	if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
	{
		lightningStrikeShit();
	}
}

function lightningStrikeShit():Void
{
	FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
	halloweenBG.animation.play('lightning');

	lightningStrikeBeat = curBeat;
	lightningOffset = FlxG.random.int(8, 24);

	boyfriend.playAnim('scared', true);
	gf.playAnim('scared', true);
}
