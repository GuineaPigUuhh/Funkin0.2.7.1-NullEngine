import flixel.FlxSprite;

var baller:FlxSprite;

function create()
{
	baller = new FlxSprite(0, 0).loadGraphic('assets/stages/exemple/image/baller.png');
	addFunkin(baller);
}

function beatHit()
{
}
