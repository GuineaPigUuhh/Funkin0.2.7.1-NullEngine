var fastCar:FlxSprite;
var limoDancers:Array<FlxSprite> = [];
var fastCarCanDrive:Bool = true;
var danced = false;

function onCreate()
{
	configureData(0.90, [1070, 220], [100, 100], [830, 250]);

	var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(stageImage('limoSunset'));
	skyBG.scrollFactor.set(0.1, 0.1);
	add(skyBG);

	var bgLimo:FlxSprite = new FlxSprite(-200, 480);
	bgLimo.frames = stageSparrowAtlas('bgLimo');
	bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
	bgLimo.animation.play('drive');
	bgLimo.scrollFactor.set(0.4, 0.4);
	add(bgLimo);

	for (i in 0...5)
	{
		var dancer:FlxSprite = new FlxSprite((370 * i) + 130, bgLimo.y - 386);
		dancer.frames = stageSparrowAtlas("limoDancer");
		dancer.animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		dancer.animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		dancer.animation.play('danceLeft');
		dancer.antialiasing = FlxG.save.data.antialiasing;
		dancer.scrollFactor.set(0.4, 0.4);
		add(dancer);

		limoDancers.push(dancer);
	}

	var limoTex = stageSparrowAtlas('limoDrive');

	limo = new FlxSprite(-300, 550);
	limo.frames = limoTex;
	limo.animation.addByPrefix('drive', "Limo stage", 24);
	limo.animation.play('drive');
	limo.antialiasing = FlxG.save.data.antialiasing;

	fastCar = new FlxSprite(-300, 160).loadGraphic(stageImage('fastCarLol'));
	resetFastCar();
	add(fastCar);

	add(limo);
}

function onBeatHit(curBeat)
{
	danced = !danced;
	for (dancer in limoDancers)
	{
		if (danced)
			dancer.animation.play('danceRight', true);
		else
			dancer.animation.play('danceLeft', true);
	}

	if (FlxG.random.bool(10) && fastCarCanDrive)
		fastCarDrive();
}

function resetFastCar():Void
{
	fastCar.x = -12600;
	fastCar.y = FlxG.random.int(140, 250);
	fastCar.velocity.x = 0;
	fastCarCanDrive = true;
}

function fastCarDrive()
{
	var r = FlxG.random.int(0, 1);
	FlxG.sound.play(Paths.sound('carPass' + r), 0.7);

	fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
	fastCarCanDrive = false;
	new FlxTimer().start(2, function(tmr:FlxTimer)
	{
		resetFastCar();
	});
}
