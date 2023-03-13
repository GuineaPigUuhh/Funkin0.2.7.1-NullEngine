var bgGirls:FlxSprite;
var danceDir:Bool = false;

function onCreate()
{
	configureData(1.05, [770 + 200, 450 + 220], [100, 100], [400 + 180, 130 + 300]);

	var bgSky = new FlxSprite().loadGraphic(stageImage('weebSky'));
	bgSky.scrollFactor.set(0.1, 0.1);
	add(bgSky);

	var repositionShit = -200;

	var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(stageImage('weebSchool'));
	bgSchool.scrollFactor.set(0.6, 0.90);
	add(bgSchool);

	var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(stageImage('weebStreet'));
	bgStreet.scrollFactor.set(0.95, 0.95);
	add(bgStreet);

	var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(stageImage('weebTreesBack'));
	fgTrees.scrollFactor.set(0.9, 0.9);
	add(fgTrees);

	var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
	var treetex = stagePackerAtlas('weebTrees');
	bgTrees.frames = treetex;
	bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
	bgTrees.animation.play('treeLoop');
	bgTrees.scrollFactor.set(0.85, 0.85);
	add(bgTrees);

	var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
	treeLeaves.frames = stageSparrowAtlas('petals');
	treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
	treeLeaves.animation.play('leaves');
	treeLeaves.scrollFactor.set(0.85, 0.85);
	add(treeLeaves);

	var widShit = Std.int(bgSky.width * 6);

	bgSky.setGraphicSize(widShit);
	bgSchool.setGraphicSize(widShit);
	bgStreet.setGraphicSize(widShit);
	bgTrees.setGraphicSize(Std.int(widShit * 1.4));
	fgTrees.setGraphicSize(Std.int(widShit * 0.8));
	treeLeaves.setGraphicSize(widShit);

	fgTrees.updateHitbox();
	bgSky.updateHitbox();
	bgSchool.updateHitbox();
	bgStreet.updateHitbox();
	bgTrees.updateHitbox();
	treeLeaves.updateHitbox();

	bgGirls = new FlxSprite(-100, 190);
	bgGirls.frames = stageSparrowAtlas('bgFreaks');

	if (songName == 'roses')
	{
		bgGirls.animation.addByIndices('danceLeft', 'BG fangirls dissuaded', CoolUtil.numberArray(14), "", 24, false);
		bgGirls.animation.addByIndices('danceRight', 'BG fangirls dissuaded', CoolUtil.numberArray(30, 15), "", 24, false);
	}
	else
	{
		bgGirls.animation.addByIndices('danceLeft', 'BG girls group', CoolUtil.numberArray(14), "", 24, false);
		bgGirls.animation.addByIndices('danceRight', 'BG girls group', CoolUtil.numberArray(30, 15), "", 24, false);
	}
	bgGirls.animation.play('danceLeft');

	bgGirls.scrollFactor.set(0.9, 0.9);
	bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
	bgGirls.updateHitbox();
	add(bgGirls);
}

function onBeatHit(curBeat)
{
	if (curBeat % 2 == 0)
		bgGirls.animation.play('danceRight', true);
	else
		bgGirls.animation.play('danceLeft', true);
}
