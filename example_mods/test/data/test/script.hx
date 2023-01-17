var left:Bool = false;

function beatHit(curBeat)
{
	left = !left;

	if (left)
	{
		PlayState.iconP1.angle = 10;
		PlayState.iconP2.angle = 10;
	}
	else
	{
		PlayState.iconP1.angle = -10;
		PlayState.iconP2.angle = -10;
	}
}
