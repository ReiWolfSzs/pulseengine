package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var camFollow:FlxObject;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	//var songList:Array = ['satin-panties'];
	var canSnap:Array<Float> = [];

	var selection:Int = 0;
	override function create() {
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if discord_rpc
		Discord.changePresence('MainMenu', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// add a group for the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// loop through the menu options
		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(0, 80 + (i * 200));
			menuItem.frames = Paths.getSparrowAtlas('menus/base/title/FNF_main_menu_assets');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			canSnap[i] = -1;
			menuItem.ID = i;

			// placements
			menuItem.screenCenter(X);
			if (menuItem.ID % 2 == 0) menuItem.x += 1000;
			else menuItem.x -= 1000;

			// actually add the item
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.updateHitbox();
		}

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float) {
		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if (FlxG.keys.justPressed.SEVEN) {
			FlxG.switchState(new meta.state.charting.ChartingState());
		}

		if ((controlArray.contains(true)) && (!selectedSomethin)) {
			for (i in 0...controlArray.length) {
				if (controlArray[i] == true) {
					if (i > 1) {
						if (i == 2) curSelected--;
						else if (i == 3) curSelected++;
						FlxG.sound.play(Paths.sound('system/scroll'));
					}
					if (curSelected < 0) curSelected = optionShit.length - 1;
					else if (curSelected >= optionShit.length) curSelected = 0;
				}
			}
		} else {
			// reset variables
			counterControl = 0;
		}

		if (controls.BACK && !selectedSomethin) {
			FlxG.switchState(new TitleState());
			selectedSomethin = true;
		}

		if (controls.ACCEPT && !selectedSomethin) { 
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound("system/confirm"));
			menuItems.forEach(function(spr:FlxSprite) {
				if (curSelected != spr.ID){
					FlxTween.tween(spr, {alpha: 0, x: FlxG.width * 2}, 0.4, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween) {
							spr.kill();
						}
					});
				} else {
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker) {
						var daChoice:String = optionShit[Math.floor(curSelected)];
						switch (daChoice) {
							case 'story mode':
								FlxG.switchState(new FreeplayState());
								//Flx.switchState(new CachingState(songList[selection]));
							case 'freeplay':
								FlxG.switchState(new FreeplayState());
							case 'options':
								FlxG.switchState(new OptionsMenuState());
						}
					});
				}
			});
		}
		if (Math.floor(curSelected) != lastCurSelected) updateSelection();

		super.update(elapsed);
		menuItems.forEach(function(menuItem:FlxSprite) {
			menuItem.screenCenter(X);
		});
	}

	var lastCurSelected:Int = 0;
	private function updateSelection() {
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite) {
			spr.animation.play('idle');
			spr.updateHitbox();
		});
		// set the sprites and all of the current selection
		camFollow.setPosition(menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().x, menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().y);

		if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle') menuItems.members[Math.floor(curSelected)].animation.play('selected');
		menuItems.members[Math.floor(curSelected)].updateHitbox();
		lastCurSelected = Math.floor(curSelected);
	}
}
