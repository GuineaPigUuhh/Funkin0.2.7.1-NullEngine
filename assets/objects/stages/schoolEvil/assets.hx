function onCreate()
{
	var bg:FlxSprite = new FlxSprite(400, 200);
	bg.frames = stageSparrowAtlas('animatedEvilSchool');
	bg.animation.addByPrefix('idle', 'background 2', 24, true);
	bg.animation.play('idle');
	bg.scrollFactor.set(0.8, 0.9);
	bg.scale.set(6, 6);
	add(bg);
}
