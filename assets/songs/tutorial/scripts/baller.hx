function onBeatHit(curBeat)
{
	if (curBeat % 16 == 15 && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
	{
		boyfriend.playAnim('hey', true);
		dad.playAnim('cheer', true);
	}
}
