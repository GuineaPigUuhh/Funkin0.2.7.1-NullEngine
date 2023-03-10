function onBeatHit(curBeat)
{
	if (curBeat >= 168 && curBeat < 200 && camGame.zoom < 1.35)
	{
		camGame.zoom += 0.015;
		camHUD.zoom += 0.03;
	}
}
