package;

#if desktop
import DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import hxcodec.VideoHandler;
import lime.utils.Assets;
import modding.ModPaths;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;
import scripting.*;
import shaders.WiggleEffect.WiggleEffectType;
import shaders.WiggleEffect;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class PlayState extends MusicBeatState
{
	public static var instance:PlayState;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	private var vocals:FlxSound;

	public var dadArray:Array<Character> = [];
	public var gfArray:Array<Character> = [];
	public var boyfriendArray:Array<Character> = [];

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public static var strumLine:FlxSprite;

	private var curSection:Int = 0;

	public var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<StaticNote>;
	public static var playerStrums:FlxTypedGroup<StaticNote>;
	public static var cpuStrums:FlxTypedGroup<StaticNote>;

	public var camZooming:Bool = false;
	public var curSong:String = "";
	public var gfSpeed:Int = 1;

	public var health:Float = 1;
	public var maxHealth:Float = 2;
	public var minHealth:Float = 0;

	public var combo:Int = 0;
	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;
	public var generatedMusic:Bool = false;
	public var startingSong:Bool = false;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var cameraFocus:String = '';

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var light:FlxSprite;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;

	public var songScore:Int = 0;
	public var songMisses:Int = 0;
	public var songAccuracy:Float = 0.00;

	public var songRating:String = "?";
	public var songRatingFC:String = "?";

	public var counterSick:Int = 0;
	public var counterGood:Int = 0;
	public var counterBad:Int = 0;
	public var counterShit:Int = 0;

	public var totalNotesHit:Float = 0;
	public var totalPlayed:Int = 0;

	var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var songTxt:FlxText;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;
	var storyDifficultyText:String = "";
	var songLength:Float = 0;

	#if desktop
	// Discord RPC variables
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	public static var GF_POS:Array<Float> = [400, 130];
	public static var DAD_POS:Array<Float> = [100, 100];
	public static var BOYFRIEND_POS:Array<Float> = [770, 450];

	var frontItems:FlxTypedGroup<FlxSprite>;

	var divider:String = " • ";
	var defaultFont:String = Paths.font("vcr.ttf");
	var defaultBorderSize:Float = 2;

	var extNotes:Float = 45;

	public static var chartingMode:Bool = false;

	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	var songScripts:ScriptPack;

	var iconsArray:Array<HealthIcon> = [];

	override public function create()
	{
		// for hscript
		instance = this;

		if (Save.middleScroll)
			extNotes = -260;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		camGame = new FlxCamera();
		camHUD = new FlxCamera();

		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		if (FileSystem.exists(Paths.getPreloadPath('songs/${SONG.song.toLowerCase()}/dialogue.txt'))) // ele vai pegar o arquivo e vai fucionar looolololoollololool // anti crash bruh
			dialogue = CoolUtil.coolTextFile(Paths.getPreloadPath('songs/${SONG.song.toLowerCase()}/dialogue.txt'));

		storyDifficultyText = CoolUtil.difficultyString();

		#if desktop
		// Making difficulty text for Discord Rich Presence.

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		detailsText = (isStoryMode ? "Story Mode: Week " + storyWeek : "Freeplay");

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		curStage = SONG.stage;

		songScripts = new ScriptPack(Paths.getPreloadPath('songs/${SONG.song.toLowerCase()}/scripts/'));

		songScripts.call("onCreate", []);

		if (SONG.stage == null || SONG.stage.length < 1)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
			}
		}

		SONG.stage = curStage;

		switch (curStage)
		{
			case 'spooky':
				{
					curStage = 'spooky';

					var hallowTex = Paths.getSparrowAtlas('stages/spooky/bg');

					halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = Save.antialiasing;
					add(halloweenBG);

					isHalloween = true;
				}
			case 'philly':
				{
					curStage = 'philly';

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
					light.antialiasing = Save.antialiasing;
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
			case 'limo':
				{
					curStage = 'limo';

					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('stages/limo/limoSunset'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('stages/limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					var limoTex = Paths.getSparrowAtlas('stages/limo/limoDrive');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = Save.antialiasing;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('stages/limo/fastCarLol'));
				}
			case 'mall':
				{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('stages/mall/bgWalls'));
					bg.antialiasing = Save.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('stages/mall/upperBop');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = Save.antialiasing;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('stages/mall/bgEscalator'));
					bgEscalator.antialiasing = Save.antialiasing;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('stages/mall/christmasTree'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('stages/mall/bottomBop');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = Save.antialiasing;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('stages/mall/fgSnow'));
					fgSnow.active = false;
					fgSnow.antialiasing = Save.antialiasing;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('stages/mall/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = Save.antialiasing;
					add(santa);
				}
			case 'mallEvil':
				{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('stages/mall/evilBG'));
					bg.antialiasing = Save.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('stages/mall/evilTree'));
					evilTree.antialiasing = Save.antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("stages/mall/evilSnow"));
					evilSnow.antialiasing = Save.antialiasing;
					add(evilSnow);
				}
			case 'school':
				{
					curStage = 'school';

					var bgSky = new FlxSprite().loadGraphic(Paths.image('stages/school/weebSky'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('stages/school/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('stages/school/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('stages/school/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('stages/school/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('stages/school/petals');
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

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
						bgGirls.getScared();

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}
			case 'schoolEvil':
				{
					curStage = 'schoolEvil';

					var bg:FlxSprite = new FlxSprite(400, 200);
					bg.frames = Paths.getSparrowAtlas('stages/school/animatedEvilSchool');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);
				}
			default:
				var _stagePath = Paths.hscript('data/stages/' + curStage);
				if (!FileSystem.exists(_stagePath))
				{
					curStage = 'stage'; // BILAU GIGANTE

					defaultCamZoom = 0.9;

					var myballs:String = "stages/stage/";

					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image(myballs + 'stageback'));
					bg.antialiasing = Save.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image(myballs + 'stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = Save.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image(myballs + 'stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = Save.antialiasing;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;
					add(stageCurtains);
				}
		}

		var gfVersion:String = 'gf';
		if (SONG.player3 == null || SONG.player3.length < 1)
		{
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school':
					gfVersion = 'gf-pixel';
				case 'schoolEvil':
					gfVersion = 'gf-pixel';
			}
		}
		else
		{
			gfVersion = SONG.player3;
		}

		gf = new Character(GF_POS[0], GF_POS[1], gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(DAD_POS[0], DAD_POS[1], SONG.player2);
		dad.setCharacterPosition(gf);

		boyfriend = new Character(BOYFRIEND_POS[0], BOYFRIEND_POS[1], SONG.player1, true);
		boyfriend.setCharacterPosition(gf);

		gfArray.push(gf);
		dadArray.push(dad);
		boyfriendArray.push(boyfriend);

		var camPos:FlxPoint = new FlxPoint(dad.getCamPos().x, dad.getCamPos().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		for (char in gfArray)
			add(char);

		if (curStage == "limo")
			add(limo);

		for (char in dadArray)
			add(char);
		for (char in boyfriendArray)
			add(char);

		frontItems = new FlxTypedGroup<FlxSprite>();
		add(frontItems);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(extNotes, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (Save.isDownscroll)
			strumLine.y = FlxG.height - 187;

		strumLineNotes = new FlxTypedGroup<StaticNote>();
		add(strumLineNotes);

		cpuStrums = new FlxTypedGroup<StaticNote>();
		playerStrums = new FlxTypedGroup<StaticNote>();

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		splash.alpha = 0.0;
		grpNoteSplashes.add(splash);

		// startCountdown();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('ui/healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', minHealth, maxHealth);
		healthBar.scrollFactor.set();
		reloadHealthColors();

		health = maxHealth / 2;

		// healthBar
		add(healthBar);

		scoreTxt = new FlxText(0, healthBarBG.y + 38, FlxG.width, "", 17);
		updateScoreTxt(false);
		scoreTxt.setFormat(defaultFont, 17, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = defaultBorderSize;

		timeTxt = new FlxText(-20, FlxG.height * 0.9 + 34, FlxG.width, '0:00${divider}0:00', 26);
		timeTxt.setFormat(defaultFont, 26, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.borderSize = defaultBorderSize;

		songTxt = new FlxText(-20, FlxG.height * 0.9 + 16, FlxG.width, curSong + divider + storyDifficultyText, 18);
		songTxt.setFormat(defaultFont, 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songTxt.scrollFactor.set();
		songTxt.borderSize = defaultBorderSize;

		iconP1 = new HealthIcon(boyfriend.getIcon(), true);
		iconP2 = new HealthIcon(dad.getIcon(), false);

		/*
			very cool icon system
		 */
		iconsArray.push(iconP1);
		iconsArray.push(iconP2);

		for (icon in iconsArray)
		{
			icon.y = healthBar.y - (icon.height / 2);
			add(icon);
		}

		// fixes
		add(timeTxt);
		add(songTxt);
		add(scoreTxt);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];

		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];

		for (icon in iconsArray)
			icon.cameras = [camHUD];

		doof.cameras = [camHUD];

		grpNoteSplashes.cameras = [camHUD];

		scoreTxt.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		songTxt.cameras = [camHUD];

		startingSong = true;

		if (isStoryMode && !Save.freeplayCutscene || !isStoryMode && Save.freeplayCutscene)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});

				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);

				default:
					/*
						if (FileSystem.exists(Paths.txt('songs/${SONG.song.toLowerCase()}/dialogue')))
							schoolIntro(doof);
						else
					 */

					startCountdown();
			}
		}
		else
		{
			startCountdown();
		}

		songScripts.call("onCreatePost", []);
		setFNFvars();

		super.create();
	}

	function setFNFvars()
	{
		songScripts.set("instance", PlayState.instance);

		songScripts.set("gf", gf);
		songScripts.set("boyfriend", boyfriend);
		songScripts.set("dad", dad);

		songScripts.set("cpuStrums", cpuStrums);
		songScripts.set("strumLineNotes", strumLineNotes);
		songScripts.set("playerStrums", playerStrums);

		songScripts.set("playVideo", playVideo);
		songScripts.set("changeHealth", changeHealth);

		songScripts.set("songName", SONG.song.toLowerCase());

		songScripts.set("songScore", songScore);
		songScripts.set("songMisses", songMisses);
		songScripts.set("songAccuracy", songAccuracy);

		songScripts.set("curStage", curStage);
		songScripts.set("curBeat", curBeat);
		songScripts.set("curStep", curStep);
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('cutscenes/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'thorns')
		{
			add(red);
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function funkinIntro(?dialogueBox:DialogueBox):Void
	{
		if (dialogueBox != null)
		{
			inCutscene = true;
			add(dialogueBox);
		}
	}

	var startTimer:FlxTimer;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing'))
				dad.dance();

			if (gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith('sing'))
				gf.dance();

			if (boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing'))
				boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ui/default/ready', "ui/default/set", "ui/default/go"]);
			introAssets.set('school', ['ui/pixel/ready', 'ui/pixel/set', 'ui/pixel/date']);
			introAssets.set('schoolEvil', ['ui/pixel/ready', 'ui/pixel/set', 'ui/pixel/date']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {
						alpha: 0
					}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(CoolUtil.getInst(SONG.song), 1, false);

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(CoolUtil.getVocal(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, extNotes);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						extNotes);

					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress == false && Save.middleScroll)
						sustainNote.alpha = 0;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress == false && Save.middleScroll)
					swagNote.alpha = 0;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
			}
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > minHealth && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > minHealth && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	var scoreTween:FlxTween = null;

	function updateScoreTxt(playTween:Bool = false)
	{
		getRating();

		scoreTxt.text = 'Score: ${songScore}' + divider + 'Misses: ${songMisses}' + divider + 'Accuracy: ${truncateFloat(songAccuracy, 2)}%';
		if (songRating != "?" && songRatingFC != "?")
			scoreTxt.text += ' [${songRating}${divider}${songRatingFC}]';

		if (playTween == true)
		{
			scoreTxt.scale.set(1.1, 1.1);
			if (scoreTween == null)
			{
				scoreTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.circOut});
			}
			else
			{
				scoreTween.cancel();
				scoreTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.circOut});
			}
		}
	}

	function getRating()
	{
		if (songAccuracy >= 100)
		{
			songRating = "Perfect!!";
		}
		else if (songAccuracy >= 90)
		{
			songRating = "Sick!";
		}
		else if (songAccuracy >= 80)
		{
			songRating = "Good";
		}
		else if (songAccuracy >= 70)
		{
			songRating = "Bad";
		}
		else if (songAccuracy >= 50)
		{
			songRating = "Bruh";
		}
		else if (songAccuracy >= 30)
		{
			songRating = "Shit";
		}
		else if (songAccuracy >= 10)
		{
			songRating = "...";
		}

		// cool newFC
		if (counterSick > 0)
			songRatingFC = "SFC";
		if (counterGood > 0)
			songRatingFC = "GFC";
		if (counterBad > 0 || counterShit > 0)
			songRatingFC = "FC";
		if (songMisses > 0 && songMisses < 10)
			songRatingFC = "SDCB";
		else if (songMisses >= 10)
			songRatingFC = "Clear";
	}

	function reloadHealthColors()
	{
		healthBar.createFilledBar(dad.getHealthColor(), boyfriend.getHealthColor());
	}

	function updateAccuracy()
	{
		totalPlayed += 1;
		songAccuracy = totalNotesHit / totalPlayed * 100;

		if (songAccuracy >= 100)
		{
			songAccuracy = 100;
		}

		if (songAccuracy <= 0)
		{
			songAccuracy = 0;
		}
	}

	function changeHealth(noob:Float = 0, fuction:String = "")
	{
		if (noob != 0)
		{
			if (fuction == 'add')
			{
				health = FlxMath.bound(health + noob, minHealth, maxHealth);
			}
			else if (fuction == 'minus')
			{
				health = FlxMath.bound(health - noob, minHealth, maxHealth);
			}
			else
			{
				health = FlxMath.bound(noob, minHealth, maxHealth);
			}
		}

		for (icon in iconsArray)
			icon.updateAnim(healthBar.percent);
	}

	function playVideo(name:String, atEndOfSong:Bool = false)
	{
		#if VIDEO_SUPPORT
		inCutscene = true;
		FlxG.sound.music.stop();

		var video:VideoHandler = new VideoHandler();
		video.finishCallback = function()
		{
			if (atEndOfSong)
			{
				if (storyPlaylist.length <= 0)
					FlxG.switchState(new StoryMenuState());
				else
				{
					SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
					FlxG.switchState(new PlayState());
				}
			}
			else
				startCountdown();
		}

		var checkVideo:String = ModPaths.video(name);
		if (!FileSystem.exists(checkVideo))
			checkVideo = Paths.video(name);

		video.playVideo(checkVideo);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	var iconOffset:Int = 26;

	override public function update(elapsed:Float)
	{
		songScripts.call("onUpdate", [elapsed]);
		switch (curStage)
		{
			case 'philly':
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

		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		for (icon in iconsArray)
		{
			if (icon.isPlayer)
				icon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			else
				icon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (icon.width - iconOffset);

			icon.updateHitbox();
		}

		if (!isStoryMode) // anticheat BRUHHHH
		{
			if (FlxG.keys.justPressed.SEVEN)
				openChartEditor();

			if (FlxG.keys.justPressed.EIGHT)
			{
				FlxG.switchState(new editors.CharacterEditor(SONG.player2, true));
				#if desktop
				DiscordClient.changePresence("Character Editor - " + SONG.player2.toUpperCase(), null, null, true);
				#end
			}
			else if (FlxG.keys.justPressed.NINE)
			{
				FlxG.switchState(new editors.CharacterEditor(SONG.player1, false));
				#if desktop
				DiscordClient.changePresence("Character Editor - " + SONG.player1.toUpperCase(), null, null, true);
				#end
			}
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
				}

				var curTime:Float = Conductor.songPosition;

				if (curTime < 0)
				{
					timeTxt.text = '0:00${divider}0:00';
					curTime = 0;
				}

				if (curTime > 0)
				{
					timeTxt.text = FlxStringUtil.formatTime(Math.floor((songLength - curTime) / 1000))
						+ divider
						+ FlxStringUtil.formatTime(Math.floor(songLength / 1000));
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				changeFocus('dad');
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				changeFocus('boyfriend');
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
			}
		}
		// better streaming of shit

		if (health <= minHealth)
		{
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
					cpuNoteHit(daNote);

				/*
					daNote.y = (strumLine.y
						- (Conductor.songPosition - daNote.strumTime) * ((Save.isDownscroll ? -0.45 : 0.45) * FlxMath.roundDecimal(SONG.speed, 2)));
				 */

				createDaNote(daNote);

				if (getDownScroll(daNote))
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						noteMiss(daNote.noteData);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		songScripts.call("onUpdatePost", [elapsed]);
	}

	function openChartEditor()
	{
		chartingMode = true;
		FlxG.switchState(new editors.ChartingState());

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	var endingSong:Bool = false;

	function endSong():Void
	{
		canPause = false;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (chartingMode == true)
		{
			openChartEditor();
		}
		else
		{
			if (SONG.validScore)
			{
				#if !switch
				Highscore.saveScore(SONG.song, songScore, storyDifficulty);
				#end
			}
			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());
					// StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}
					FlxG.save.flush();
				}
				else
				{
					var formatSong = CoolUtil.formatSong(PlayState.storyDifficulty);

					switch (SONG.song.toLowerCase()) // end cutcesss
					{
						case 'eggnog':
							var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
								-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
							blackShit.scrollFactor.set();
							add(blackShit);
							camHUD.visible = false;
							FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(formatSong, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	function createDaNote(daNote:Note)
	{
		var strumMembers = cpuStrums.members[daNote.noteData];
		if (daNote.mustPress)
			strumMembers = playerStrums.members[daNote.noteData];

		if (Save.isDownscroll == false)
		{
			daNote.y = (strumMembers.y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
		}
		else
		{
			daNote.y = (strumMembers.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
		}

		if (daNote.isSustainNote == false)
			daNote.x = strumMembers.x;
		else
			daNote.x = strumMembers.x + 35;
	}

	function changeFocus(charFocus:String)
	{
		cameraFocus = charFocus;
		switch (charFocus)
		{
			case "dad":
				{
					camFollow.setPosition(dad.getCamPos().x, dad.getCamPos().y);

					switch (dad.curCharacter)
					{
						case 'mom':
							camFollow.y = dad.getMidpoint().y;
						case 'senpai':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
						case 'senpai-angry':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
					}
				}

			case "boyfriend":
				{
					camFollow.setPosition(boyfriend.getCamPos().x, boyfriend.getCamPos().y);

					switch (curStage)
					{
						case 'limo':
							camFollow.x = boyfriend.getMidpoint().x - 300;
						case 'mall':
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'school':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'schoolEvil':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 200;
					}
				}

			case "gf":
				{
					camFollow.setPosition(gf.getCamPos(true).x, gf.getCamPos(true).y);
				}
		}
	}

	function spawnSplash(x:Float, y:Float, data:Int)
	{
		if (Save.noteSplash)
		{
			var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
			splash.execute(x, y, data);
			if (curStage == 'school' || curStage == 'schoolEvil')
				splash.skin = "pixel";
			grpNoteSplashes.add(splash);
		}
	}

	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();

		var addScore:Int = 350;
		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			counterShit++;
			daRating = 'shit';
			addScore = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			counterBad++;
			daRating = 'bad';
			addScore = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			counterGood++;
			daRating = 'good';
			addScore = 200;
		}
		else
		{
			counterSick++;
			daRating = "sick";
			addScore = 350;

			spawnSplash(daNote.x, playerStrums.members[daNote.noteData].y, daNote.noteData);
		}

		songScore += addScore;

		var localPath:String = "ui/default/ratings/" + daRating;
		if (curStage.startsWith('school'))
		{
			localPath = 'ui/pixel/ratings/' + daRating;
		}

		rating.loadGraphic(Paths.image(localPath));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/default/combo'));
		comboSpr.screenCenter();
		comboSpr.cameras = [camHUD];
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = Save.antialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = Save.antialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var localPathNum:String = 'ui/default/numbers/' + 'num' + Std.int(i);
			if (curStage.startsWith('school'))
				localPathNum = 'ui/pixel/numbers/' + 'num' + Std.int(i);

			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(localPathNum));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.cameras = [camHUD];
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = Save.antialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	public function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var babyArrow:StaticNote = new StaticNote(extNotes, PlayState.strumLine.y, i, player);

			if (!PlayState.isStoryMode)
			{
				babyArrow.noteTween(i, Save.isDownscroll);
			}

			if (player == 0 && Save.middleScroll)
				babyArrow.visible = false;

			if (player == 1)
			{
				PlayState.playerStrums.add(babyArrow);
			}
			else
			{
				PlayState.cpuStrums.add(babyArrow);
			}

			babyArrow.ID = i;

			PlayState.strumLineNotes.add(babyArrow);
		}
	}

	function getDownScroll(daNote:Note):Bool
	{
		var returnString:Bool = daNote.y < -daNote.height;
		if (Save.isDownscroll)
		{
			returnString = daNote.y >= strumLine.y + 106;
		}

		return returnString;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}

								if (!inIgnoreList)
									badNoteCheck(0, false);
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
			}
			else
			{
				badNoteCheck(0, false);
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					if (up || down || right || left)
						goodNoteHit(daNote);
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}

		playerStrums.forEach(function(spr:StaticNote)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.playAnim('pressed');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.playAnim('pressed');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.playAnim('pressed');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.playAnim('pressed');
			}
		});
	}

	function noteMiss(direction:Int):Void
	{
		songMisses += 1;
		songScore -= 10;

		updateScoreTxt(false);

		if (combo > 5 && gf.animOffsets.exists('sad'))
			gf.playAnim('sad');

		changeHealth(0.04, "minus");

		combo = 0;

		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

		boyfriend.playSingAnimations(direction, "miss", false);

		updateAccuracy();
	}

	function badNoteCheck(direct:Int = 0, nighttt:Bool = false)
	{
		if (Save.ghostTapping == true)
			return;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var groupKeys:Array<Bool> = [leftP, downP, upP, rightP];

		if (nighttt == true)
		{
			if (groupKeys[direct])
				noteMiss(direct);
		}
		else
		{
			if (groupKeys[0])
				noteMiss(0);

			if (groupKeys[1])
				noteMiss(1);

			if (groupKeys[2])
				noteMiss(2);

			if (groupKeys[3])
				noteMiss(3);
		}
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else
		{
			badNoteCheck(note.noteData, true);
		}
	}

	var checkAltAnimBF:String = "";
	var checkAltAnimDAD:String = "";

	function goodNoteHit(daNote:Note):Void
	{
		if (!daNote.wasGoodHit)
		{
			if (!daNote.isSustainNote)
			{
				popUpScore(daNote);
				combo += 1;
			}
			else
				totalNotesHit += 1;

			updateScoreTxt(true);

			changeHealth(0.023, "add");

			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].altAnimBF)
					checkAltAnimBF = '-alt';
			}

			boyfriend.playSingAnimations(daNote.noteData, checkAltAnimBF, true);

			playerStrums.forEach(function(spr:StaticNote)
			{
				if (Math.abs(daNote.noteData) == spr.ID)
				{
					spr.playAnim('confirm', true);
				}
			});

			daNote.wasGoodHit = true;

			vocals.volume = 1;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();

			updateAccuracy();

			songScripts.call("onPlayerHit", [daNote]);
		}
	}

	function cpuNoteHit(daNote:Note)
	{
		camZooming = true;

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].altAnimDAD)
				checkAltAnimDAD = '-alt';
		}

		dad.playSingAnimations(daNote.noteData, checkAltAnimDAD, true);

		cpuStrums.forEach(function(spr:StaticNote)
		{
			if (Math.abs(daNote.noteData) == spr.ID)
			{
				spr.playAnim('confirm', true);
			}
		});

		dad.holdTimer = 0;

		vocals.volume = 1;

		daNote.kill();
		notes.remove(daNote, true);
		daNote.destroy();

		songScripts.call("onCpuHit", [daNote]);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
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

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		songScripts.call("onStepHit", [curStep]);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (Save.isDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		switch (curSong.toLowerCase())
		{
			case 'milf':
				if (curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
				{
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.03;
				}
			case 'tutorial':
				if (curBeat % 16 == 15 && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
				{
					boyfriend.playAnim('hey', true);
					dad.playAnim('cheer', true);
				}
			case 'bopeebo':
				if (curBeat % 8 == 7)
				{
					boyfriend.playAnim('hey', true);
				}
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		for (icon in iconsArray)
			icon.bop(curBeat);

		if (dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing'))
		{
			dad.dance();
		}

		if (curBeat % gfSpeed == 0)
		{
			if (gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing"))
				gf.dance();
		}

		if (boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
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

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}

		songScripts.call("onBeatHit", [curBeat]);
	}

	var curLight:Int = 0;
	var lightColors:Array<FlxColor> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
}
