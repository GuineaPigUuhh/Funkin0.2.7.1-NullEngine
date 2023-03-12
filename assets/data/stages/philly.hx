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

function onCreate()
{
	configureData(1.05, [770, 450], [100, 100], [400, 130]);

	var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('stages/philly/sky'));
	bg.scrollFactor.set(0.1, 0.1);
	add(bg);

	var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('stages/philly/city'));
	city.scrollFactor.set(0.3, 0.3);
	city.setGraphicSize(Std.int(city.width * 0.85));
	city.updateHitbox();
	add(city);

	light = new FlxSprite(city.x).loadGraphic(Paths.image('stages/philly/win'));
	light.scrollFactor.set(0.3, 0.3);
	light.alpha = 0;
	light.setGraphicSize(Std.int(light.width * 0.85));
	light.updateHitbox();
	light.antialiasing = FlxG.save.data.antialiasing;
	add(light);

	var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('stages/philly/behindTrain'));
	add(streetBehind);

	phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('stages/philly/train'));
	add(phillyTrain);

	trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
	FlxG.sound.list.add(trainSound);

	var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('stages/philly/street'));
	add(street);
}

function onBeatHit(curBeat)
{
	if (!trainMoving)
		trainCooldown += 1;

	if (curBeat % 4 == 0)
	{
		curLight = FlxG.random.int(1, lightColors.length, [curLight]);
		light.color = lightColors[curLight];

		light.alpha = 1;
		FlxTween.tween(light, {alpha: 0}, 0.75, {ease: FlxEase.quadOut});
	}

	if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
	{
		trainCooldown = FlxG.random.int(-4, 0);
		trainStart();
	}
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
		gf.playAnim('hairBlow');
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
	gf.playAnim('hairFall');

	phillyTrain.x = FlxG.width + 200;
	trainMoving = false;

	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
}
