function onCreate()
{
	configureData(1.05, [770 + 320, 450], [100, 20], [400, 130]);

	var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(stageImage('evilBG'));
	bg.antialiasing = FlxG.save.data.antialiasing;
	bg.scrollFactor.set(0.2, 0.2);
	bg.active = false;
	bg.setGraphicSize(Std.int(bg.width * 0.8));
	bg.updateHitbox();
	add(bg);

	var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(stageImage('evilTree'));
	evilTree.antialiasing = FlxG.save.data.antialiasing;
	evilTree.scrollFactor.set(0.2, 0.2);
	add(evilTree);

	var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(stageImage("evilSnow"));
	evilSnow.antialiasing = FlxG.save.data.antialiasing;
	add(evilSnow);
}
