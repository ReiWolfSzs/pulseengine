package gameObjects;

import haxe.io.Path;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
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
	public function new(curStage) {
		super();
		this.curStage = curStage;

		switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase())) {
			default:
				curStage = 'stage';
		}

		switch (curStage) {
			default:
				game.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				background.add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				background.add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				background.add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage) {
		var gfVersion:String = 'gf';
		switch (curStage) {
			default:
				gfVersion = 'gf';
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
			case "stage":
				dad.setPosition(0, 0);
				boyfriend.setPosition(700, 0);
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