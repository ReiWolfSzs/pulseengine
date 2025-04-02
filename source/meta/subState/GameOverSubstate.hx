package meta.subState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.Boyfriend;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Conductor;
import meta.state.*;
import meta.state.menus.*;

class GameOverSubstate extends MusicBeatSubState {
	var bf:Boyfriend;
	var bgBlack:FlxSprite;
	var camFollow:FlxObject;
	public static var stageSuffix:String = "";
	public function new(x:Float, y:Float) {
		var daBoyfriendType = PlayState.boyfriend.curCharacter;
		var daBf:String = '';
		switch (daBoyfriendType) {
			default:
				daBf = 'bf-dead';
		}
		super();
		FlxG.sound.play(Paths.sound('gameplay/bfDeath' + stageSuffix));

		Conductor.songPosition = 0;

		var bg:FlxSprite = new FlxSprite().makeGraphic(2000, 2000, FlxColor.BLACK);
		bg.screenCenter();
		add(bg);

		bf = new Boyfriend();
		bf.setCharacter(x, y + PlayState.boyfriend.height, daBf);
		add(bf);

		bgBlack = new FlxSprite().makeGraphic(2000, 2000, FlxColor.BLACK);
		bgBlack.screenCenter();
		bgBlack.alpha = 0;
		add(bgBlack);

		PlayState.boyfriend.destroy();

		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 20, bf.getGraphicMidpoint().y - 40, 1, 1);
		add(camFollow);

		Conductor.changeBPM(100);
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (controls.ACCEPT) endBullshit();
		if (controls.BACK) {
			FlxG.sound.music.stop();
			PlayState.deaths = 0;

			if (PlayState.isStoryMode) {
				FlxG.switchState(new StoryMenuState());
			} else FlxG.switchState(new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12) FlxG.camera.follow(camFollow, LOCKON, 0.5);
		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished) FlxG.sound.playMusic(Paths.music('gameplay/gameOver' + stageSuffix));
	}

	override function beatHit() {
		super.beatHit();
		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;
	function endBullshit():Void {
		if (!isEnding) {
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameplay/gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer) {
				FlxTween.tween(bgBlack, {alpha: 1}, 1, { onComplete: function(tmr:FlxTween) {
					Main.switchState(this, new PlayState());
				}});
			});
		}
	}
}

/*class GameOverSubstate extends MusicBeatSubState {

	var game = PlayState;
	var video:VideoSprite;
	var vagalume:Float;
	override function create() {
		vagalume = FlxG.sound.volume;
		FlxG.sound.volume = 0.5;

		video = new VideoSprite(320, 180);
		video.playVideo("assets/videos/die.mp4");
		video.scale.set(2, 2);
		add(video);
		video.cameras = [game.dialogueHUD];
		
		video.bitmap.finishCallback = function() {
			FlxG.sound.volume = vagalume;
			FlxG.switchState(new FreeplayState());
		}
		super.create();
	}
}*/