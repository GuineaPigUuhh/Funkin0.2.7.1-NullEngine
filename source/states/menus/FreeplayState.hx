package states.menus;

#if desktop
import game.DiscordClient;
#end
import data.WeekData;
import dependency.MusicBeatState;
import dependency.Paths;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import game.Highscore;
import game.songData.Song;
import game.sprites.Alphabet;
import game.sprites.HealthIcon;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import states.PlayState;
import utils.CoolUtil;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var bg:FlxSprite;
	var scoreBG:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		WeekData.getJSON();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		for (i in 0...WeekData.weeks.length)
		{
			if (WeekData.weeks[i].hideInFreePlay == false)
				addWeek(WeekData.weeks[i].weekSongs, WeekData.weeks[i].songColor, i, WeekData.weeks[i].songIcons);
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER);
		add(diffText);

		add(scoreText);

		var bottomBG = new FlxSprite(0, FlxG.height - 30).makeGraphic(FlxG.width, 30, 0xFF000000, true);
		bottomBG.alpha = 0.55;
		add(bottomBG);

		var spaceInfo = new FlxText(0, 0, FlxG.width, '[Space] Listen to Selected Song.');
		spaceInfo.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		spaceInfo.y = FlxG.height - 5 - spaceInfo.height;
		add(spaceInfo);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	public function addSong(songName:String, songColor:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, songColor, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, color:String, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var icon:Int = 0;
		for (song in songs)
		{
			addSong(song, color, weekNum, songCharacters[icon]);

			if (songCharacters.length != 1)
				icon++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;

		if (upP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(-1);
		}
		if (downP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(1);
		}

		if (controls.LEFT_P)
		{
			changeDiff(-1);
		}
		if (controls.RIGHT_P)
		{
			changeDiff(1);
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.playMusic(CoolUtil.getInst(songs[curSelected].songName), 0);
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			var poop:String = CoolUtil.formatSong(curDifficulty);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;

			LoadingState.loadAndSwitchState(new PlayState());
		}
		positionHighscore();
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, CoolUtil.difficultyArray.length - 1);

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		updateDiff();
		positionHighscore();
	}

	var colorTween:ColorTween;

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);

		if (colorTween == null)
		{
			colorTween = FlxTween.color(bg, 0.4, bg.color, FlxColor.fromString("#" + songs[curSelected].songColor), {startDelay: 0.05});
		}
		else if (FlxColor.fromString("#" + songs[curSelected].songColor) != colorTween.color)
		{
			colorTween.cancel();
			colorTween = FlxTween.color(bg, 0.4, bg.color, FlxColor.fromString("#" + songs[curSelected].songColor), {startDelay: 0.05});
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end
		updateDiff();

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function updateDiff()
	{
		diffText.text = switch (CoolUtil.difficultyArray[curDifficulty].length)
		{
			case 0:
				'';
			case 1:
				CoolUtil.difficultyArray[0];
			case _:
				'< ' + CoolUtil.difficultyArray[curDifficulty] + ' >';
		}
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;

		diffText.x = Std.int(scoreBG.x + scoreBG.width / 2);
		diffText.x -= (diffText.width / 2);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songColor:String = "";

	public function new(song:String, color:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.songColor = color;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
