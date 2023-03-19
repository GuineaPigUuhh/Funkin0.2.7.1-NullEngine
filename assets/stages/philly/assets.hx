var light:FlxSprite;
var phillyTrain:FlxSprite;
var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;
var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;
var trainSound:FlxSound;
var curLight:Int = 0;
var lightColors:Array<FlxColor> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
var blammedLightsOn:Bool = false;
var bg:FlxSprite;
var city:FlxSprite;
var streetBehind:FlxSprite;
var street:FlxSprite;

function onCreate()
{
	bg = new FlxSprite(-100).loadGraphic(stageImage('sky'));
	bg.scrollFactor.set(0.1, 0.1);
	add(bg);

	city = new FlxSprite(-10).loadGraphic(stageImage('city'));
	city.scrollFactor.set(0.3, 0.3);
	city.setGraphicSize(Std.int(city.width * 0.85));
	city.updateHitbox();
	add(city);

	light = new FlxSprite(city.x).loadGraphic(stageImage('win'));
	light.scrollFactor.set(0.3, 0.3);
	light.alpha = 0;
	light.setGraphicSize(Std.int(light.width * 0.85));
	light.updateHitbox();
	light.antialiasing = FlxG.save.data.antialiasing;
	add(light);

	streetBehind = new FlxSprite(-40, 50).loadGraphic(stageImage('behindTrain'));
	add(streetBehind);

	phillyTrain = new FlxSprite(2000, 360).loadGraphic(stageImage('train'));
	add(phillyTrain);

	trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
	FlxG.sound.list.add(trainSound);

	street = new FlxSprite(-40, streetBehind.y).loadGraphic(stageImage('street'));
	add(street);
}

function onBeatHit(curBeat)
{
	if (!trainMoving)
		trainCooldown += 1;

	if (songName == "blammed")
	{
		if (curBeat == 128)
		{
			blammedLightsOn = true;
			removeBackground();
		}

		if (curBeat == 192)
		{
			blammedLightsOn = false;
			addBackground();

			player.color = 0xffffff;
			opponent.color = 0xffffff;

			game.iconP1.color = 0xffffff;
			game.iconP2.color = 0xffffff;
		}
	}

	if (curBeat % 4 == 0)
	{
		curLight = FlxG.random.int(1, 4, [curLight]);
		light.color = lightColors[curLight];

		light.alpha = 1;
		FlxTween.tween(light, {alpha: 0}, 0.75, {ease: FlxEase.quadOut});

		if (blammedLightsOn)
		{
			player.color = lightColors[curLight];
			opponent.color = lightColors[curLight];

			game.iconP1.color = lightColors[curLight];
			game.iconP2.color = lightColors[curLight];
		}
	}

	if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
	{
		trainCooldown = FlxG.random.int(-4, 0);
		trainStart();
	}
}

function removeBackground()
{
	bg.visible = false;
	city.visible = false;
	streetBehind.visible = false;
	street.visible = false;
	phillyTrain.visible = false;

	spectator.visible = false;
}

function addBackground()
{
	bg.visible = true;
	city.visible = true;
	streetBehind.visible = true;
	street.visible = true;
	phillyTrain.visible = true;

	spectator.visible = true;
}

function onUpdate(elapsed)
{
	if (trainMoving)
	{
		trainFrameTiming += elapsed;

		if (trainFrameTiming >= 1 / 24)
		{
			updateTrainPos();
			trainFrameTiming = 0;
		}
	}
}

function trainStart():Void
{
	trainMoving = true;
	if (!trainSound.playing)
		trainSound.play(true);
}

function updateTrainPos()
{
	if (trainSound.time >= 4700)
	{
		startedMoving = true;
		spectator.playAnim('hairBlow', false);
	}

	if (startedMoving)
	{
		phillyTrain.x -= 400;

		if (phillyTrain.x < -2000 && !trainFinishing)
		{
			phillyTrain.x = -1150;
			trainCars -= 1;

			if (trainCars <= 0)
				trainFinishing = true;
		}

		if (phillyTrain.x < -4000 && trainFinishing)
			trainReset();
	}
}

function trainReset()
{
	spectator.playAnim('hairFall');

	phillyTrain.x = FlxG.width + 200;
	trainMoving = false;

	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
}
