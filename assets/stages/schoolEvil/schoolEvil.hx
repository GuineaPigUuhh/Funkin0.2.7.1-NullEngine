function onCreate()
{
	configureData(1.05, [770 + 200, 450 + 220], [100, 100], [400 + 180, 130 + 300]);

	var bg:FlxSprite = new FlxSprite(400, 200);
	bg.frames = stageSparrowAtlas('animatedEvilSchool');
	bg.animation.addByPrefix('idle', 'background 2', 24, true);
	bg.animation.play('idle');
	bg.scrollFactor.set(0.8, 0.9);
	bg.scale.set(6, 6);
	add(bg);
}
