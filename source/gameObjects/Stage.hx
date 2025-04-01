package gameObjects;

import haxe.io.Path;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic> {
	var game = PlayState;
	var game2 = PlayState.instance;
	public var curStage:String;

	public var background:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var foreground:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	public var splashSkin:String = "noteSplashes";

	var limoSky:FlxSprite;
	var limoStar:FlxSprite;
	var limoCar1:FlxSprite;
	var limoCar2:FlxSprite;
	public function new(curStage) {
		super();
		this.curStage = curStage;

		switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase())) {
			case "satin-panties":
				curStage = 'limo';
			default:
				curStage = 'stage';
		}

		game.curStage = curStage;
		switch (curStage) {
			case 'limo':
				var scaleX:Float = 1;
				var scaleY:Float = 1;
				game.defaultCamZoom = 0.2;

				limoSky = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoSunset'));
				background.add(limoSky);

				limoStar = new FlxSprite(0, 0);
				limoStar.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/shooting star');
				limoStar.animation.addByPrefix('idle', 'shooting star', 24);
				limoStar.animation.play('idle');
				limoStar.antialiasing = true;
				background.add(limoCar1);

				limoCar1 = new FlxSprite(0, 550);
				limoCar1.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bglimo');
				limoCar1.animation.addByPrefix('idle', 'background limo blue', 24);
				limoCar1.animation.play('idle');
				limoCar1.antialiasing = true;
				background.add(limoCar1);

				limoCar2 = new FlxSprite(120, 600);
				limoCar2.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/limoDrive');
				limoCar2.animation.addByPrefix('idle', 'Limo stage', 24);
				limoCar2.animation.play('idle');
				limoCar2.antialiasing = true;
				background.add(limoCar2);
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage) {
		var gfVersion:String = 'gf';

		switch (curStage) {
			case 'hell':
				gfVersion = 'sonic';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void {
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter) {
				case 'gf':
					char.setPosition(gf.x, gf.y);
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void {
		switch (curStage) {
			case 'escola':
				dad.setPosition(1700, 1800);
				boyfriend.setPosition(2700, 1950);
			case 'hell':
				dad.setPosition(540, 920);
				boyfriend.setPosition(2080, 950);
			case "stage":
				dad.setPosition(0, 0);
				boyfriend.setPosition(0, 0);
		}
	}

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character) {
		switch (PlayState.curStage) {
			
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character) {
		switch (PlayState.curStage) {

		}
	}
}