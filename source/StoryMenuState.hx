package;

#if desktop
import DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import haxe.format.JsonParser;
import lime.net.curl.CURLCode;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef WeekJSON =
{
	var weeks:Array<Week>;
}

typedef Week =
{
	var weekSongs:Array<String>;
	var weekPath:String;
	var weekTitle:String;
	var weekCharacters:Array<String>;
	var songIcons:Array<String>;
	var songColor:String;
	var hideInFreePlay:Bool;
	var hideInStoryMode:Bool;
}

class StoryMenuState extends MusicBeatState
{
	public var weekData:WeekJSON;

	var scoreText:FlxText;
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		var weekPath:String = ModPaths.json("weekList");
		if (!FileSystem.exists(weekPath))
			weekPath = Paths.json("weekList");

		weekData = Json.parse(Assets.getText(weekPath));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...weekData.weeks.length)
		{
			if (weekData.weeks[i].hideInStoryMode == false)
			{
				var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, weekData.weeks[i].weekPath);
				weekThing.y += ((weekThing.height + 20) * i);
				weekThing.targetY = i;
				weekThing.screenCenter(X);
				weekThing.antialiasing = true;

				grpWeekText.add(weekThing);
			}
		}

		trace("Line 96");

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekData.weeks[curWeek].weekCharacters[char]);
			weekCharacterThing.y += 70;
			weekCharacterThing.antialiasing = true;

			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 376, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeWeek(1);
				}

				if (controls.RIGHT_P)
				{
					changeDifficulty(1);
					rightArrow.animation.play('press');
				}
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT_P)
				{
					changeDifficulty(-1);
					leftArrow.animation.play('press');
				}
				else
					leftArrow.animation.play('idle');
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (stopspamming == false)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));

			grpWeekText.members[curWeek].startFlashing();
			grpWeekCharacters.members[1].playAnim('confirm');
			stopspamming = true;
		}

		PlayState.storyPlaylist = weekData.weeks[curWeek].weekSongs;
		PlayState.isStoryMode = true;
		selectedWeek = true;

		PlayState.storyDifficulty = curDifficulty;
		var formatSong = CoolUtil.formatSong(PlayState.storyDifficulty);

		PlayState.SONG = Song.loadFromJson(formatSong, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.storyWeek = curWeek;
		PlayState.campaignScore = 0;
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState(), true);
		});
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, CoolUtil.difficultyArray.length - 1);

		sprDifficulty.offset.x = 0;

		sprDifficulty.loadGraphic(Paths.image("menuDifficulties/" + CoolUtil.difficultyArray[curDifficulty].toLowerCase()));

		sprDifficulty.x = leftArrow.x + 60;
		sprDifficulty.x += (308 - sprDifficulty.width) / 3;

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek = FlxMath.wrap(curWeek + change, 0, weekData.weeks.length - 1);

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0))
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		updateText();
	}

	function updateText()
	{
		for (loop in 0...3)
			grpWeekCharacters.members[loop].changeMenuCharacter(weekData.weeks[curWeek].weekCharacters[loop]);

		scoreText.text = "WEEK SCORE:" + lerpScore;
		txtWeekTitle.text = weekData.weeks[curWeek].weekTitle;

		txtTracklist.text = "Tracks\n";

		var stringThing:Array<String> = weekData.weeks[curWeek].weekSongs;

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
