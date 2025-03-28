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
	public var direct:String = "assets/collection"; // please make a name music in folder and init write... Thank You ;p

	var moonSky:FlxSprite;
	var moonHills:FlxSprite;
	var moonFloor:FlxSprite;
	var moonFore:FlxSprite;
	public function new(curStage) {
		super();
		this.curStage = curStage;

		switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase())) {
			case "moonlight":
				curStage = 'hell';
			default:
				curStage = 'stage';
		}

		game.curStage = curStage;
		switch (curStage) {
			case 'hell':
				game.defaultCamZoom = 0.5;

				moonSky = new FlxSprite(0, 0).loadGraphic(Paths.image('DXHalloween/bg/sky', direct));
				moonSky.scale.set(1.2, 1.2);
				background.add(moonSky);
				
				moonHills = new FlxSprite(0, 0).loadGraphic(Paths.image('DXHalloween/bg/hills', direct));
				moonHills.scale.set(1.2, 1.2);
				background.add(moonHills);
				
				moonFloor = new FlxSprite(0, 0).loadGraphic(Paths.image('DXHalloween/bg/ground', direct));
				moonFloor.scale.set(1.2, 1.2);
				background.add(moonFloor);

				moonFore = new FlxSprite(0, -30).loadGraphic(Paths.image('DXHalloween/bg/softlight', direct));
				moonFore.scale.set(1.2, 1.2);
				foreground.add(moonFore);
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