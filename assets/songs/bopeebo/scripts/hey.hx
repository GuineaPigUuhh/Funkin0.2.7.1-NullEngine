function onBeatHit(curBeat)
{
	if (curBeat % 8 == 7)
	{
		boyfriend.playAnim('hey', true);
	}
}
