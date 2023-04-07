var light:FlxSprite;
var phillyTrain:FlxSprite;
var bg:FlxSprite;
var city:FlxSprite;
var streetBehind:FlxSprite;
var street:FlxSprite;

// amongus
var trainSaveY:Float = 0;

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

	trainSaveY = phillyTrain.y;

	street = new FlxSprite(-40, streetBehind.y).loadGraphic(stageImage('street'));
	add(street);
}

var curLight:Int = 0;
var trainCoolNumber:Int = 0;
var lightColors:Array<FlxColor> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];

function onBeatHit(curBeat)
{
	trainCoolNumber++;

	if (curBeat % 4 == 0)
	{
		curLight = FlxG.random.int(1, 4, [curLight]);
		light.color = lightColors[curLight];

		light.alpha = 1;
		FlxTween.tween(light, {alpha: 0}, 0.75, {ease: FlxEase.quadOut});
	}

	if (curBeat % 8 == 4 && FlxG.random.bool(40) && trainCoolNumber > 8)
	{
		trainCoolNumber = 0; // COOL DUDE!
		startTrain();
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

var trainMoving:Bool = false;

function onUpdatePost(elapsed)
{
	if (trainMoving == true)
		phillyTrain.y = trainSaveY + FlxG.random.int(-10, 10);
}

var trainTween:FlxTween = null;
var trainTimer:FlxTimer = null;

function startTrain()
{
	trainMoving = true;
	FlxG.sound.play(Paths.sound('train_passes'));

	trainTimer = new FlxTimer().start(4.15, function(tmr:FlxTimer)
	{
		if (trainTween != null)
			trainTween.cancel();

		trainTween = FlxTween.tween(phillyTrain, {x: -4300}, 2.2, {
			ease: FlxEase.elasticInOut,
			onUpdate: function(tween:FlxTween)
			{
				spectator.playAnim("hairBlow", false);
			},
			onComplete: function(tween:FlxTween)
			{
				spectator.playAnim("hairFall", false);
				resetTrain();
			}
		});
	});
}

function resetTrain()
{
	trainMoving = false;
	phillyTrain.x = 2000;
}
