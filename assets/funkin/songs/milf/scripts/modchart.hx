function onBeatHit(curBeat)
{
	if (curBeat >= 168 && curBeat < 200 && camGame.zoom < 1.35)
		camBop(0.015);
}
