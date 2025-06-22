package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;
import flixel.util.FlxStringUtil;

using StringTools;

class ClassHUD extends FlxTypedGroup<FlxBasic>
{
	var  game = PlayState;
	var scoreBar:FlxText;
	var scoreLast:Float = -1;

	public var lerpScore:Int = 0;
	public var intendedScore:Int = 0;
	var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';

	public var autoplayMark:FlxText;
	public var autoplaySine:Float = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

	private var SONG = PlayState.SONG;

	private var stupidHealth:Float = 0;

	private var timingsMap:Map<String, FlxText> = [];
	public function new() {
		super();
		var barY = FlxG.height * 0.9;
		if (Init.trueSettings.get('Downscroll')) barY = 64;

		healthBarBG = new FlxSprite(0, barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarBG.screenCenter(X);
		healthBarBG.scale.set(1.5, 1);
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 36, healthBarBG.y + 5, RIGHT_TO_LEFT, Std.int(360), Std.int(9));
		healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
		healthBar.scale.set(1.5, 1);
		add(healthBar);

		iconP1 = new HealthIcon(PlayState.SONG.player1, true);
		add(iconP1);

		iconP2 = new HealthIcon(PlayState.SONG.player2, false);
		add(iconP2);

		for (i in [iconP1, iconP2]) {
			i.y = healthBarBG.y - 80;
		}

		scoreBar = new FlxText(healthBarBG.x + 330, healthBarBG.y + 30, 0, scoreDisplay);
		scoreBar.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE);
		scoreBar.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.2);
		scoreBar.fieldWidth = 0;
		updateScoreText();
		scoreBar.antialiasing = true;
		add(scoreBar);
		
		if (Init.trueSettings.get('Downscroll')) scoreBar.setPosition(490, 29);

		if (Init.trueSettings.get('Counter') != 'None') {
			var judgementNameArray:Array<String> = [];
			for (i in Timings.judgementsMap.keys()) judgementNameArray.insert(Timings.judgementsMap.get(i)[0], i);
			judgementNameArray.sort(sortByShit);

			for (i in 0...judgementNameArray.length) {
				var textAsset:FlxText = new FlxText(5 + (!left ? (FlxG.width - 10) : 0),
				(FlxG.height / 2) - (counterTextSize * (judgementNameArray.length / 2)) + (i * counterTextSize),
				0, '', counterTextSize);

				if (!left) textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.setFormat(Paths.font("vcr.ttf"), counterTextSize, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				textAsset.scrollFactor.set();
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
		updateScoreText();

		autoplayMark = new FlxText(-5, (Init.trueSettings.get('Downscroll') ? -60 : 60), FlxG.width - 800, 'BOTPLAY', 32);
		autoplayMark.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		autoplayMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		autoplayMark.screenCenter(X);
		autoplayMark.visible = PlayState.boyfriendStrums.autoplay;

		if (Init.trueSettings.get('Centered Notefield')) {
			if (Init.trueSettings.get('Downscroll')) autoplayMark.y = autoplayMark.y - 125;
			else autoplayMark.y = autoplayMark.y + 125;
		}

		add(autoplayMark);
	}

	var counterTextSize:Int = 18;
	function sortByShit(Obj1:String, Obj2:String):Int return FlxSort.byValues(FlxSort.ASCENDING, Timings.judgementsMap.get(Obj1)[0], Timings.judgementsMap.get(Obj2)[0]);

	var left = (Init.trueSettings.get('Counter') == 'Left');
	override public function update(elapsed:Float) {
		healthBar.percent = (PlayState.health * 50);

		intendedScore = game.songScore;
    	lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 14)));
		scoreBar.text = 'Score: ' + lerpScore;

		var iconLerp = 1 - Main.framerateAdjust(0.15);
		
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		iconP1.updateAnim(healthBar.percent);
		iconP2.updateAnim(100 - healthBar.percent);

		if (autoplayMark.visible) {
			autoplaySine += 180 * (elapsed / 4);
			autoplayMark.alpha = 1 - Math.sin((Math.PI * autoplaySine) / 80);
		}
	}

	private final divider:String = " • ";
	public function updateScoreText() {
		var comboDisplay:String = (Timings.comboDisplay != null && Timings.comboDisplay != '' ? ' [${Timings.comboDisplay}]' : '');
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public function beatHit() {

	}
}