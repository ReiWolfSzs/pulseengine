package gameObjects.userInterface.notes;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import meta.state.PlayState;

class NoteSplash extends FlxSprite {
	private var idleAnim:String;
	private var textureLoaded:String = null;
	var game = PlayState;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = "noteSplashes";

		loadAnims(skin);

		setupNoteSplash(x, y, note);
		antialiasing = true;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null) {
		setPosition(x, y);
		alpha = 0.6;

		if (texture == null) {
			texture = "noteSplashes";
		}

		if (textureLoaded != texture) {
			loadAnims(texture);
		}

		switch(game.curStage) {
			case "stage": // only in musics that have one animation for splash
				animation.play('note', true);
		}

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		if (animation.curAnim != null)animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		switch(game.curStage) {
			/*case "stage": unused but only for sprites have one animation
				frames = Paths.getSparrowAtlas(skin, "assets/collection");
				animation.addByPrefix("note", "vanilla " + i, 24, false);
				offset.set(30, 15);
				trace("CustomSplash");*/
			default:
				if (game.assetModifier == 'pixel') {
					frames = Paths.getSparrowAtlas("splashskins/pixel/" + skin);
					antialiasing = false;
					for (i in 0...3) {
						animation.addByPrefix("note1-" + i, "blue " + i, 24, false);
						animation.addByPrefix("note2-" + i, "green " + i, 24, false);
						animation.addByPrefix("note0-" + i, "purple " + i, 24, false);
						animation.addByPrefix("note3-" + i, "orange " + i, 24, false);
					}
					scale.set(3, 3);
					offset.set(-50, -30);
					//trace("pixelSplash");
				} else {
					frames = Paths.getSparrowAtlas("splashskins/default/" + skin);
					for (i in 0...3) {
						animation.addByPrefix("note1-" + i, "note impact " + i + " blue", 24, false);
						animation.addByPrefix("note2-" + i, "note impact " + i + " green", 24, false);
						animation.addByPrefix("note0-" + i, "note impact " + i + " purple", 24, false);
						animation.addByPrefix("note3-" + i, "note impact " + i + " red", 24, false);
					}
					offset.set(60, 70);
					//trace("defaultSplash");
				}
		}
	}

	override function update(elapsed:Float) {
		if (animation.curAnim != null) if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}