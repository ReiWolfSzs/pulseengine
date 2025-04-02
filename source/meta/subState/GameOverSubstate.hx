package meta.subState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.MusicBeat.MusicBeatSubState;
import flixel.input.keyboard.FlxKey;

import meta.state.PlayState;
import meta.state.menus.FreeplayState;

class GameOverSubstate extends MusicBeatSubState {

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
}
