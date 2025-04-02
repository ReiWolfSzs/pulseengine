package meta.state.menus;

import gameObjects.userInterface.SquareRiser;
import flixel.util.FlxSpriteUtil;
import gameObjects.userInterface.AudioVisualizer.BarVisualizer;
import gameObjects.Character;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import gameObjects.userInterface.PhillyGlow.PhillyGlowParticle;
import shaders.ShaderObject;
import meta.data.Song;
import flixel.FlxG;
import flixel.util.FlxColor;
import gameObjects.userInterface.PhillyGlow.PhillyGlowGradient;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import meta.MusicBeat.MusicBeatState;
import hxcodec.VideoSprite;

class CachingState extends MusicBeatState{
	var credits:Map<String, String> = [
		"Shadow" => ""
	];
	
    var songName:String;
    public function new(song:String)
    {
        super();
        songName = song;
    }

    override function create() {
        super.create();

		new FlxSound().loadEmbedded(Paths.sound("county-sounds/rumble"));

		var textThing = new FlxText(0, 0, 0, 'NOW PLAYING:\n\n"' + songName.toUpperCase() + '"\n\n' + "BY " + credits[songName] + ".", 60);
		textThing.font = Paths.font("vcr.ttf");
		textThing.alignment = CENTER;
		textThing.screenCenter();
		FlxTween.shake(textThing, 0.004, 99, Y);

		@:privateAccess
		FlxG.camera._filters =[ShaderObject.getShader("vhs")];

        var loading = new FlxTypeText(1000, 630, FlxG.width, "LOADING...", 40);
        loading.font = Paths.font("vcr.ttf");
        loading.sounds = [new FlxSound().loadEmbedded(Paths.sound("county-sounds/typewriter"))];
        add(loading);

        
        new FlxTimer().start(1.5, function(e:FlxTimer) {
            loading.start(0.1, false, false, null, function() {
                switch (songName) {
					/*case "Example":
						FlxG.bitmap.add(Paths.image("county-sprites/befriended/vignette"));
						FlxG.bitmap.add(Paths.image("county-sprites/befriended/intruder"));
						FlxG.bitmap.add(Paths.image("county-sprites/befriended/eyes"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/bg"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/shine"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/TV"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/light"));

						var beginningIntro:VideoSprite;
						beginningIntro = new VideoSprite(250);
						beginningIntro.openingCallback = beginningIntro.bitmap.stop;
						beginningIntro.playVideo("assets/images/county-sprites/befriended/beginning.mp4");
						add(beginningIntro);
						beginningIntro.scale.set();

						var staticBg = new FlxSprite(-400, 0);
						staticBg.frames = Paths.getSparrowAtlas("county-sprites/befriended/static");
						staticBg.animation.addByPrefix("static", "static", 24, true);
						staticBg.animation.play("static");
						staticBg.scale.set();
						staticBg.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(staticBg);

						var dad = new Character();
						dad.setCharacter(0, 0, "intruderlured_alt");
						dad.playAnim("idle");
						dad.playAnim("singLEFT");
						dad.playAnim("singRIGHT");
						dad.playAnim("singUP");
						dad.playAnim("singDOWN");
						dad.scale.set();
						dad.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad);

						var bf = new Character();
						bf.setCharacter(0, 0, "adamyoung");
						bf.playAnim("idle");
						bf.playAnim("singLEFT");
						bf.playAnim("singRIGHT");
						bf.playAnim("singUP");
						bf.playAnim("singDOWN");
						bf.playAnim("singUPmiss");
						bf.playAnim("singLEFTmiss");
						bf.playAnim("singRIGHTmiss");
						bf.playAnim("singDOWNmiss");
						bf.scale.set();
						bf.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(bf);

						var statics = new FlxSprite();
						statics.frames = Paths.getSparrowAtlas("county-sprites/befriended/statics");
						statics.animation.addByPrefix("loop", "static", 24);
						add(statics);
						statics.scrollFactor.set();
						statics.animation.play("loop");
						statics.screenCenter();
						statics.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						statics.scale.set();

						var blackOverlay = new FlxSprite();
						blackOverlay.makeGraphic(3000, 3000, FlxColor.BLACK);
						blackOverlay.scale.set();
						blackOverlay.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(blackOverlay);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));*/
                }

				new FlxTimer().start(1.5, function(e:FlxTimer) {
                    loading.erase(0.1, false, null, function() {
						new FlxTimer().start(1.5, function(e:FlxTimer) {
							FlxG.sound.play(Paths.sound("count/base3"));
							add(textThing);
							new FlxTimer().start(4, function(e:FlxTimer) {
								FlxG.sound.play(Paths.sound("count/base2"));
								textThing.size = 80;
								textThing.text = "3";
								textThing.screenCenter();
								new FlxTimer().start(1, function(e:FlxTimer) {
									FlxG.sound.play(Paths.sound("count/base1"));
									textThing.text = "2";
									textThing.screenCenter();
									new FlxTimer().start(1, function(e:FlxTimer) {
										FlxG.sound.play(Paths.sound("count/baseGo"));
									    textThing.text = "1";
										textThing.screenCenter();
										new FlxTimer().start(1, function(e:FlxTimer) {
											PlayState.isStoryMode = false;
											PlayState.storyDifficulty = 2;
											PlayState.SONG = Song.loadFromJson(songName.toLowerCase() + "-hard", songName.toLowerCase());
											Main.switchState(this, new PlayState());
								   		});
								    });
								});
							});
						});
                    });
                });
            });
        });
    }
}