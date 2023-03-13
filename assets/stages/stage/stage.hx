function onCreate()
{
	configureData(0.9, [770, 450], [100, 100], [400, 130]);

	var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(stageImage('stageback'));
	bg.antialiasing = FlxG.save.data.antialiasing;
	bg.scrollFactor.set(0.9, 0.9);
	bg.active = false;
	add(bg);

	var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(stageImage('stagefront'));
	stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
	stageFront.updateHitbox();
	stageFront.antialiasing = FlxG.save.data.antialiasing;
	stageFront.scrollFactor.set(0.9, 0.9);
	stageFront.active = false;
	add(stageFront);

	var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(stageImage('stagecurtains'));
	stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
	stageCurtains.updateHitbox();
	stageCurtains.antialiasing = FlxG.save.data.antialiasing;
	stageCurtains.scrollFactor.set(1.3, 1.3);
	stageCurtains.active = false;
	add(stageCurtains);
}
