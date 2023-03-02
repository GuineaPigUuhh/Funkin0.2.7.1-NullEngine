import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class StaticNote extends FlxSprite
{
	public var noteData:Int = 0;
	public var player:Int = 0;

	public function new(x:Float, y:Float, data:Int, player:Int)
	{
		noteData = data;
		this.player = player;
		super(x, y);

		reloadNote();
		scrollFactor.set();

		addNote();
	}

	override function update(elapsed:Float)
	{
		if (animation.finished && (animation.curAnim.name == "confirm" || animation.curAnim.name == "pressed"))
		{
			playAnim('static', true);
		}

		super.update(elapsed);
	}

	public function reloadNote()
	{
		switch (PlayState.curStage)
		{
			case 'school' | 'schoolEvil':
				loadGraphic(Paths.image('ui/pixel/notes'), true, 17, 17);
				animation.add('green', [6]);
				animation.add('red', [7]);
				animation.add('blue', [5]);
				animation.add('purplel', [4]);

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

				switch (Math.abs(noteData) % 4)
				{
					case 0:
						animation.add('static', [0]);
						animation.add('pressed', [4, 8], 12, false);
						animation.add('confirm', [12, 16], 24, false);
					case 1:
						animation.add('static', [1]);
						animation.add('pressed', [5, 9], 12, false);
						animation.add('confirm', [13, 17], 24, false);
					case 2:
						animation.add('static', [2]);
						animation.add('pressed', [6, 10], 12, false);
						animation.add('confirm', [14, 18], 12, false);
					case 3:
						animation.add('static', [3]);
						animation.add('pressed', [7, 11], 12, false);
						animation.add('confirm', [15, 19], 24, false);
				}

			default:
				frames = Paths.getSparrowAtlas('ui/default/staticArrows');
				animation.addByPrefix('green', 'arrowUP');
				animation.addByPrefix('blue', 'arrowDOWN');
				animation.addByPrefix('purple', 'arrowLEFT');
				animation.addByPrefix('red', 'arrowRIGHT');

				antialiasing = Save.antialiasing;
				setGraphicSize(Std.int(width * 0.7));

				switch (Math.abs(noteData) % 4)
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
		}
		updateHitbox();
	}

	public function noteTween(data:Int, down:Bool)
	{
		var alphaReturn:Float = 1;
		if (!Save.staticArrowsAlpha)
			alphaReturn = 0.9;

		if (down)
		{
			y += 10;
			alpha = 0;
			FlxTween.tween(this, {y: y - 10, alpha: alphaReturn}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * data)});
		}
		else
		{
			y -= 10;
			alpha = 0;
			FlxTween.tween(this, {y: y + 10, alpha: alphaReturn}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * data)});
		}
	}

	function addNote()
	{
		playAnim('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
	}

	public function playAnim(anim:String, ?force:Bool = false)
	{
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();

		if (animation.curAnim.name == 'confirm' && (PlayState.curStage != "schoolEvil" || PlayState.curStage != "school"))
		{
			centerOrigin();
		}
	}
}
