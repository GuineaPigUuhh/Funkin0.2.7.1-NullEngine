function onBeatHit(curBeat)
{
	if (curBeat % 8 == 7)
	{
		player.playAnim('hey', true);
	}
}
