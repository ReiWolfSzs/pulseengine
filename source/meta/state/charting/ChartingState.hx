package meta.state.charting;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;


import lime.media.AudioBuffer;
import haxe.io.Bytes;
import flash.geom.Rectangle;

import meta.data.*;
import gameObjects.*;
import gameObjects.userInterface.*;
import gameObjects.userInterface.notes.*;

import meta.MusicBeat.MusicBeatState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Section.SwagSection;
import meta.data.Song.SwagSong;
import meta.data.ChartLoader;

using StringTools;

/**
	In case you dont like the forever engine chart editor, here's the base game one instead.
**/
class ChartingState extends MusicBeatState
{
	var _file:FileReference;

	var UI_box:FlxUITabMenu;

	/**
	 * Array of notes showing when each section STARTS in STEPS
	 * Usually rounded up??
	 */
	var curSection:Int = 0;

	var curNoteType:Int = 0;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var strumLine:FlxSprite;
	var curSong:String = '';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;

	var highlight:FlxSprite;

	public static var GRID_SIZE:Int = 40;

	var dummyArrow:FlxSprite;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedNoteTypes:FlxTypedGroup<FlxText>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;

	var gridBG:FlxSprite;
	var bg:FlxSprite;

	var _song:SwagSong;

	var typingShit:FlxInputText;
	/*
	 * WILL BE THE CURRENT / LAST PLACED NOTE
	**/
	var curSelectedNote:Array<Dynamic>;

	var tempBpm:Float = 0;

	var vocals:FlxSound;

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;
	var waveformSprite:FlxSprite;

	var playTicksBf:FlxUICheckBox = null;
	var playTicksDad:FlxUICheckBox = null;

	var noteTypes:Array<String> = [
		"Normal",
		"Second Opponent",
		"Both Opponent"
	];

	override function create() {
		curSection = lastSection;

		bg = new FlxSprite(0, 0).makeGraphic(1280, 720, FlxColor.GRAY);
		bg.screenCenter();
		add(bg);

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
		gridBG.y = 37;
		add(gridBG);

		var gridBlackLine:FlxSprite = new FlxSprite(gridBG.x + gridBG.width / 2, 37).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedNoteTypes = new FlxTypedGroup<FlxText>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

		if (PlayState.SONG != null) {
			_song = PlayState.SONG;
		} else {
			_song = {
				song: 'satin-panties',
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'bf',
				player3: 'none',
				gfVersion: 'gf',
				speed: 1,
				validScore: false,
				stage: 'stage',
				noteSkin: 'default',
				assetModifier: 'base'
			};
		}

		FlxG.mouse.visible = true;
		FlxG.save.bind('collection', 'rei');

		tempBpm = _song.bpm;

		addSection();

		var sections = _song.notes;

		updateGrid();
		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		bpmTxt = new FlxText(1000, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();
		add(bpmTxt);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(FlxG.width / 2) - 320, 4);
		add(strumLine);

		var tabs = [
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2;
		UI_box.y = 20;
		add(UI_box);

		addSongUI();
		addSectionUI();
		updateSectionUI();
		addNoteUI();
		updateWaveform();

		FlxG.sound.pause();

		super.create();

		waveformSprite = new FlxSprite(GRID_SIZE, 0).makeGraphic(FlxG.width, FlxG.height, 0x00FFFFFF);
		add(waveformSprite);

		add(curRenderedNotes);
		add(curRenderedNoteTypes);
		add(curRenderedSustains);

		leftIcon = new HealthIcon('bf');
		rightIcon = new HealthIcon('dad');

		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.scale.set(0.3, 0.3);
		rightIcon.scale.set(0.3, 0.3);

		add(leftIcon);
		add(rightIcon);
	}

	function addSongUI():Void {
		var UI_songTitle = new FlxUIInputText(10, 10, 70, _song.song, 8);
		typingShit = UI_songTitle;

		var check_voices = new FlxUICheckBox(10, 25, null, null, "Has voice track", 100);
		check_voices.checked = _song.needsVoices;
		// _song.needsVoices = check_voices.checked;
		check_voices.callback = function() {
			_song.needsVoices = check_voices.checked;
			trace('CHECKED!');
		};

		var check_mute_inst = new FlxUICheckBox(10, 330, null, null, "Mute Instrumental (in editor)", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function() {
			var vol:Float = 1;

			if (check_mute_inst.checked) {
				vol = 0;
			}
			songMusic.volume = vol;
		};

		var check_mute_vocals = new FlxUICheckBox(check_mute_inst.x + 120, check_mute_inst.y - 5, null, null, "Mute Vocals (in editor)", 100);
		check_mute_vocals.checked = false;
		check_mute_vocals.callback = function() {
			if (vocals != null) {
				var vol:Float = 1;
				if (check_mute_vocals.checked) vol = 0;
				vocals.volume = vol;
			}
		};

		var saveButton:FlxButton = new FlxButton(110, 8, "Save", function() {
			saveLevel();
		});

		var reloadSong:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload Audio", function() {
			loadSong(_song.song);
			updateWaveform();
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, saveButton.y + 30, "Reload JSON", function() {
			loadJson(_song.song.toLowerCase());
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', loadAutosave);
		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(10, 80, 0.1, 1, 0.1, 10, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(10, 65, 1, 1, 1, 339, 0);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var player1DropDown = new FlxUIDropDownMenu(10, 100, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String) {
			_song.player1 = characters[Std.parseInt(character)];
		});
		player1DropDown.selectedLabel = _song.player1;

		var player2DropDown = new FlxUIDropDownMenu(140, 100, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String) {
			_song.player2 = characters[Std.parseInt(character)];
		});
		player2DropDown.selectedLabel = _song.player2;

		var charactersWithNone:Array<String> = characters.copy();
		charactersWithNone.insert(0, "none");

		var player3DropDown = new FlxUIDropDownMenu(140, 140, FlxUIDropDownMenu.makeStrIdLabelArray(charactersWithNone, true), function(character:String) {
			_song.player3 = charactersWithNone[Std.parseInt(character)];
		});
		player3DropDown.selectedLabel = _song.player3;

		var assetModifiers:Array<String> = CoolUtil.returnAssetsLibrary('UI/default');
		var assetModifierDropDown = new FlxUIDropDownMenu(player1DropDown.x, player1DropDown.y + 40,
			FlxUIDropDownMenu.makeStrIdLabelArray(assetModifiers, true), function(character:String) {
			_song.assetModifier = assetModifiers[Std.parseInt(character)];
		});
		assetModifierDropDown.selectedLabel = _song.assetModifier;

		playTicksBf = new FlxUICheckBox(check_mute_inst.x, 350, null, null, 'Play Hitsounds (Boyfriend - in editor)', 100);
		playTicksBf.checked = false;

		playTicksDad = new FlxUICheckBox(check_mute_inst.x + 120, playTicksBf.y, null, null, 'Play Hitsounds (Opponent - in editor)', 100);
		playTicksDad.checked = false;

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";
		tab_group_song.add(UI_songTitle);

		tab_group_song.add(check_voices);
		tab_group_song.add(check_mute_inst);
		tab_group_song.add(check_mute_vocals);
		tab_group_song.add(saveButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(player1DropDown);
		tab_group_song.add(player2DropDown);
		tab_group_song.add(player3DropDown);
		tab_group_song.add(playTicksBf);
		tab_group_song.add(playTicksDad);
		tab_group_song.add(assetModifierDropDown);

		UI_box.addGroup(tab_group_song);
		UI_box.scrollFactor.set();
	}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_mustSecondOpponentSection:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		stepperLength = new FlxUINumericStepper(10, 10, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSection].lengthInSteps;
		stepperLength.name = "section_length";

		stepperSectionBPM = new FlxUINumericStepper(10, 80, 1, Conductor.bpm, 0, 999, 0);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';

		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(110, 130, 1, 1, -999, 999, 0);

		var copyButton:FlxButton = new FlxButton(10, 130, "Copy last section", function() {
			copySection(Std.int(stepperCopy.value));
		});

		var clearSectionButton:FlxButton = new FlxButton(10, 150, "Clear", clearSection);
		var swapSection:FlxButton = new FlxButton(10, 170, "Swap section", function() {
			for (i in 0..._song.notes[curSection].sectionNotes.length) {
				var note = _song.notes[curSection].sectionNotes[i];
				note[1] = (note[1] + 4) % 8;
				_song.notes[curSection].sectionNotes[i] = note;
				updateGrid();
			}
		});

		check_mustHitSection = new FlxUICheckBox(10, 30, null, null, "Must hit section", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = true;
		// _song.needsVoices = check_mustHit.checked;

		check_mustSecondOpponentSection = new FlxUICheckBox(150, 30, null, null, "Must hit second opponent", 100);
		check_mustSecondOpponentSection.name = 'check_mustSecondOpponent';

		check_altAnim = new FlxUICheckBox(10, 400, null, null, "Alt Animation", 100);
		check_altAnim.name = 'check_altAnim';

		check_changeBPM = new FlxUICheckBox(10, 60, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';

		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_mustSecondOpponentSection);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(swapSection);

		UI_box.addGroup(tab_group_section);
	}

	var stepperSusLength:FlxUINumericStepper;
	var dropDownType:FlxUIDropDownMenu;
	var disableAutoScrolling:FlxUICheckBox;

	function addNoteUI():Void {
		var tab_group_note = new FlxUI(null, UI_box);
		tab_group_note.name = 'Note';

		disableAutoScrolling = new FlxUICheckBox(10, 320, null, null, "Disable Autoscroll (Not Recommended)", 120,
			function() {
				FlxG.save.data.chart_noAutoScroll = disableAutoScrolling.checked;
			}
		);
		if (FlxG.save.data.chart_noAutoScroll == null) FlxG.save.data.chart_noAutoScroll = false;
		disableAutoScrolling.checked = FlxG.save.data.chart_noAutoScroll;

		stepperSusLength = new FlxUINumericStepper(10, 10, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 16);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		var applyLength:FlxButton = new FlxButton(100, 10, 'Apply');

		tab_group_note.add(stepperSusLength);
		tab_group_note.add(applyLength);

		/*
		// note types
		stepperType = new FlxUINumericStepper(10, 30, Conductor.stepCrochet / 125, 0, 0, (Conductor.stepCrochet / 125) + 10); // 10 is placeholder
		// I have no idea what i'm doing lmfao
		stepperType.value = 0;
		stepperType.name = 'note_type';
		*/

		dropDownType = new FlxUIDropDownMenu(10, 30, FlxUIDropDownMenu.makeStrIdLabelArray(noteTypes, true), function(type:String) {
			curNoteType = Std.parseInt(type);
		});

		//tab_group_note.add(stepperType);
		tab_group_note.add(dropDownType);
		tab_group_note.add(disableAutoScrolling);

		UI_box.addGroup(tab_group_note);
		// I'm genuinely tempted to go around and remove every instance of the word "sus" it is genuinely killing me inside
	}

	var songMusic:FlxSound;
	function loadSong(daSong:String):Void {
		if (songMusic != null) songMusic.stop();
		if (vocals != null) vocals.stop();

		songMusic = new FlxSound().loadEmbedded(Paths.inst(daSong), false, true);
		if (_song.needsVoices) vocals = new FlxSound().loadEmbedded(Paths.voices(daSong), false, true);
		else vocals = new FlxSound();

		FlxG.sound.list.add(songMusic);
		FlxG.sound.list.add(vocals);

		songMusic.play();
		vocals.play();

		pauseMusic();

		songMusic.onComplete = function() {
			ForeverTools.killMusic([songMusic, vocals]);
			loadSong(daSong);
			changeSection();
		};
	}

	function pauseMusic() {
		songMusic.time = Math.max(songMusic.time, 0);
		songMusic.time = Math.min(songMusic.time, songMusic.length);

		songMusic.pause();
		vocals.pause();
	}

	function generateUI():Void {
		while (bullshitUI.members.length > 0) {
			bullshitUI.remove(bullshitUI.members[0], true);
		}

		// general shit
		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if (id == FlxUICheckBox.CLICK_EVENT) {
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label) {
				case 'Must hit section':
					_song.notes[curSection].mustHitSection = check.checked;
				case 'Must hit second opponent':
					_song.notes[curSection].mustSecondOpponentSection = check.checked;
				case 'Change BPM':
					_song.notes[curSection].changeBPM = check.checked;
					FlxG.log.add('changed bpm shit');
				case "Alt Animation":
					_song.notes[curSection].altAnim = check.checked;
			}
		} else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
			// ew what was this before? made it switch cases instead of else if
			switch (wname) {
				case 'section_length':
					_song.notes[curSection].lengthInSteps = Std.int(nums.value); // change length
					//updateGrid(); // vrrrrmmm
				case 'song_speed':
					_song.speed = nums.value; // change the song speed
				case 'song_bpm':
					tempBpm = Std.int(nums.value);
					Conductor.mapBPMChanges(_song);
					Conductor.changeBPM(Std.int(nums.value));
				case 'note_susLength': // STOP POSTING ABOUT AMONG US
					curSelectedNote[2] = nums.value; // change the currently selected note's length
					updateGrid(); // oh btw I know sus stands for sustain it just bothers me
				case 'note_type':
					curNoteType = Std.int(nums.value); // oh yeah dont forget this has to be an integer
				// set the new note type for when placing notes next!
				case 'section_bpm':
					_song.notes[curSection].bpm = Std.int(nums.value); // redefine the section's bpm
					updateGrid(); // update the note grid
			}
		}

		// FlxG.log.add(id + " WEED " + sender + " WEED " + data + " WEED " + params);
	}

	var updatedSection:Bool = false;
	function sectionStartTime():Float {
		var daBPM:Float = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection) {
			if (_song.notes[i].changeBPM) {
				daBPM = _song.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	function calculateTime(miliseconds:Float = 0):String {
		var seconds = Std.int(miliseconds / 1000);
		var minutes = Std.int(seconds / 60);
		seconds = seconds % 60;
		return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
	}

	var lastSongPos:Null<Float> = null;
	override function update(elapsed:Float) {
		curStep = recalculateSteps();

		Conductor.songPosition = songMusic.time;
		_song.song = typingShit.text;

		// real thanks for the help with this ShadowMario, you are the best -Ghost
		var playedSound:Array<Bool> = [];
		for (i in 0...8) {
			playedSound.push(false);
		}

		if(!disableAutoScrolling.checked) {
			if (Math.ceil(strumLine.y) >= gridBG.height + 50) {
				if (_song.notes[curSection + 1] == null) {
					addSection();
				}
				changeSection(curSection + 1, false);
			} else if(strumLine.y < -10) {
				changeSection(curSection - 1, false);
			}
		}

		curRenderedNotes.forEachAlive(function(note:Note) {
			if (note.strumTime < songMusic.time) {
				var data:Int = note.noteData % 4;
				if (songMusic.playing && !playedSound[data] && note.noteData > -1 && note.strumTime >= lastSongPos) {
					if ((playTicksBf.checked) && (note.mustPress) || (playTicksDad.checked) && (!note.mustPress)) {
						FlxG.sound.play(Paths.sound('soundNoteTick'));
						playedSound[data] = true;
					}
				}
			}
		});

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps));
		if (curBeat % 4 == 0 && curStep >= 16 * (curSection + 1)) {
			//trace(curStep);
			//trace((_song.notes[curSection].lengthInSteps) * (curSection + 1));
			//trace('DUMBSHIT');
			changeSection(curSection + 1, false);

			if (_song.notes[curSection + 1] == null) {
				addSection();
			}
		}

		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);
		if (FlxG.mouse.justPressed) {
			if (FlxG.mouse.overlaps(curRenderedNotes)) {
				curRenderedNotes.forEach(function(note:Note) {
					if (FlxG.mouse.overlaps(note)) {
						if (FlxG.keys.pressed.CONTROL) {
							selectNote(note);
						} else {
							trace('tryin to delete note...');
							deleteNote(note);
						}
					}
				});
			} else {
				if (FlxG.mouse.x > gridBG.x
					&& FlxG.mouse.x < gridBG.x + gridBG.width
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps)) {
					FlxG.log.add('added note');
					addNote();
				}
			}
		}

		if (FlxG.mouse.x > gridBG.x
			&& FlxG.mouse.x < gridBG.x + gridBG.width
			&& FlxG.mouse.y > gridBG.y
			&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps)) {
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
			if (FlxG.keys.pressed.SHIFT) {
				dummyArrow.y = FlxG.mouse.y;
			} else {
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE - 3;
			}
		}

		if (FlxG.keys.justPressed.ENTER) {
			lastSection = curSection;
			PlayState.SONG = _song;
			songMusic.stop();
			vocals.stop();
			Main.switchState(this, new PlayState());
		}

		if (FlxG.keys.justPressed.E) {
			changeNoteSustain(Conductor.stepCrochet);
		}
		
		if (FlxG.keys.justPressed.Q) {
			changeNoteSustain(-Conductor.stepCrochet);
		}

		if (FlxG.keys.justPressed.TAB) {
			if (FlxG.keys.pressed.SHIFT) {
				UI_box.selected_tab -= 1;
				if (UI_box.selected_tab < 0) {
					UI_box.selected_tab = 2;
				}
			} else {
				UI_box.selected_tab += 1;
				if (UI_box.selected_tab >= 3) {
					UI_box.selected_tab = 0;
				}
			}
		}

		if (!typingShit.hasFocus) {
			if (FlxG.keys.justPressed.SPACE) {
				if (songMusic.playing) {
					songMusic.pause();
					vocals.pause();
				} else {
					vocals.play();
					songMusic.play();
				}
			}

			if (FlxG.keys.justPressed.R) {
				if (FlxG.keys.pressed.SHIFT) {
					resetSection(true);
				} else {
					resetSection();
				}
			}

			if (FlxG.mouse.wheel != 0) {
				songMusic.pause();
				vocals.pause();

				songMusic.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.4);
				vocals.time = songMusic.time;
			}

			if (!FlxG.keys.pressed.SHIFT) {
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S) {
					songMusic.pause();
					vocals.pause();

					var daTime:Float = 700 * FlxG.elapsed;

					if (FlxG.keys.pressed.W)
					{
						songMusic.time -= daTime;
					} else {
						songMusic.time += daTime;
					}
					vocals.time = songMusic.time;
				}
			} else {
				if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.S) {
					songMusic.pause();
					vocals.pause();

					var daTime:Float = Conductor.stepCrochet * 2;

					if (FlxG.keys.justPressed.W) {
						songMusic.time -= daTime;
					} else {
						songMusic.time += daTime;
					}
					vocals.time = songMusic.time;
				}
			}
		}

		_song.bpm = tempBpm;

		var shiftThing:Int = 1;
		if (FlxG.keys.pressed.SHIFT) {
			shiftThing = 4;
		}

		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) {
			changeSection(curSection + shiftThing);
		}

		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) {
			changeSection(curSection - shiftThing);
		}

		bpmTxt.text = calculateTime(FlxMath.roundDecimal(songMusic.time, 2))
			+ " / "
			+ calculateTime(songMusic.length)
			+ "\nSection: "
			+ curSection
			+ "\nBeat: "
			+ curBeat
			+ "\nStep: "
			+ curStep;

		lastSongPos = Conductor.songPosition;
		super.update(elapsed);

		if (_song.notes[curSection].mustHitSection == false) {
			leftIcon.setPosition(170, 5);
			rightIcon.setPosition(9, 5);
		} else {
			rightIcon.setPosition(170, 5);
			leftIcon.setPosition(9, 5);
		}
	}

	var waveformPrinted:Bool = true;
	var wavData:Array<Array<Array<Float>>> = [[[0], [0]], [[0], [0]]];
	function updateWaveform() {
		#if desktop
		waveformPrinted = false;

		if(!FlxG.save.data.chart_waveformInst && !FlxG.save.data.chart_waveformVoices) {
			//trace('Epic fail on the waveform lol');
			return;
		}

		wavData[0][0] = [];
		wavData[0][1] = [];
		wavData[1][0] = [];
		wavData[1][1] = [];

		var steps:Int = Math.round(getSectionBeats() * 4);
		var st:Float = sectionStartTime();
		var et:Float = st + (Conductor.stepCrochet * steps);

		if (FlxG.save.data.chart_waveformInst) {
			var sound:FlxSound = FlxG.sound.music;
			@:privateAccess
			if (sound._sound != null && sound._sound.__buffer != null) {
				var bytes:Bytes = sound._sound.__buffer.data.toBytes();

				wavData = waveformData(
					sound._sound.__buffer,
					bytes,
					st,
					et,
					1,
					wavData,
					Std.int(gridBG.height)
				);
			}
		}

		if (FlxG.save.data.chart_waveformVoices) {
			var sound:FlxSound = vocals;
			@:privateAccess
			if (sound._sound != null && sound._sound.__buffer != null) {
				var bytes:Bytes = sound._sound.__buffer.data.toBytes();

				wavData = waveformData(
					sound._sound.__buffer,
					bytes,
					st,
					et,
					1,
					wavData,
					Std.int(gridBG.height)
				);
			}
		}

		// Draws
		var gSize:Int = Std.int(GRID_SIZE * 8);
		var hSize:Int = Std.int(gSize / 2);

		var lmin:Float = 0;
		var lmax:Float = 0;

		var rmin:Float = 0;
		var rmax:Float = 0;

		var size:Float = 1;

		var leftLength:Int = (
			wavData[0][0].length > wavData[0][1].length ? wavData[0][0].length : wavData[0][1].length
		);

		var rightLength:Int = (
			wavData[1][0].length > wavData[1][1].length ? wavData[1][0].length : wavData[1][1].length
		);

		var length:Int = leftLength > rightLength ? leftLength : rightLength;

		var index:Int;
		for (i in 0...length) {
			index = i;

			lmin = FlxMath.bound(((index < wavData[0][0].length && index >= 0) ? wavData[0][0][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;
			lmax = FlxMath.bound(((index < wavData[0][1].length && index >= 0) ? wavData[0][1][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;

			rmin = FlxMath.bound(((index < wavData[1][0].length && index >= 0) ? wavData[1][0][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;
			rmax = FlxMath.bound(((index < wavData[1][1].length && index >= 0) ? wavData[1][1][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;

			waveformSprite.pixels.fillRect(new Rectangle(hSize - (lmin + rmin), i * size, (lmin + rmin) + (lmax + rmax), size), FlxColor.BLUE);
		}

		waveformPrinted = true;
		#end
	}

	function waveformData(buffer:AudioBuffer, bytes:Bytes, time:Float, endTime:Float, multiply:Float = 1, ?array:Array<Array<Array<Float>>>, ?steps:Float):Array<Array<Array<Float>>> {
		#if (lime_cffi && !macro)
		if (buffer == null || buffer.data == null) return [[[0], [0]], [[0], [0]]];

		var khz:Float = (buffer.sampleRate / 1000);
		var channels:Int = buffer.channels;

		var index:Int = Std.int(time * khz);

		var samples:Float = ((endTime - time) * khz);

		if (steps == null) steps = 1280;

		var samplesPerRow:Float = samples / steps;
		var samplesPerRowI:Int = Std.int(samplesPerRow);

		var gotIndex:Int = 0;

		var lmin:Float = 0;
		var lmax:Float = 0;

		var rmin:Float = 0;
		var rmax:Float = 0;

		var rows:Float = 0;

		var simpleSample:Bool = true;//samples > 17200;
		var v1:Bool = false;

		if (array == null) array = [[[0], [0]], [[0], [0]]];

		while (index < (bytes.length - 1)) {
			if (index >= 0) {
				var byte:Int = bytes.getUInt16(index * channels * 2);

				if (byte > 65535 / 2) byte -= 65535;

				var sample:Float = (byte / 65535);

				if (sample > 0) {
					if (sample > lmax) lmax = sample;
				} else if (sample < 0) {
					if (sample < lmin) lmin = sample;
				}

				if (channels >= 2) {
					byte = bytes.getUInt16((index * channels * 2) + 2);

					if (byte > 65535 / 2) byte -= 65535;

					sample = (byte / 65535);

					if (sample > 0) {
						if (sample > rmax) rmax = sample;
					} else if (sample < 0) {
						if (sample < rmin) rmin = sample;
					}
				}
			}

			v1 = samplesPerRowI > 0 ? (index % samplesPerRowI == 0) : false;
			while (simpleSample ? v1 : rows >= samplesPerRow) {
				v1 = false;
				rows -= samplesPerRow;

				gotIndex++;

				var lRMin:Float = Math.abs(lmin) * multiply;
				var lRMax:Float = lmax * multiply;

				var rRMin:Float = Math.abs(rmin) * multiply;
				var rRMax:Float = rmax * multiply;

				if (gotIndex > array[0][0].length) array[0][0].push(lRMin);
					else array[0][0][gotIndex - 1] = array[0][0][gotIndex - 1] + lRMin;

				if (gotIndex > array[0][1].length) array[0][1].push(lRMax);
					else array[0][1][gotIndex - 1] = array[0][1][gotIndex - 1] + lRMax;

				if (channels >= 2) {
					if (gotIndex > array[1][0].length) array[1][0].push(rRMin);
						else array[1][0][gotIndex - 1] = array[1][0][gotIndex - 1] + rRMin;

					if (gotIndex > array[1][1].length) array[1][1].push(rRMax);
						else array[1][1][gotIndex - 1] = array[1][1][gotIndex - 1] + rRMax;
				}
				else {
					if (gotIndex > array[1][0].length) array[1][0].push(lRMin);
						else array[1][0][gotIndex - 1] = array[1][0][gotIndex - 1] + lRMin;

					if (gotIndex > array[1][1].length) array[1][1].push(lRMax);
						else array[1][1][gotIndex - 1] = array[1][1][gotIndex - 1] + lRMax;
				}

				lmin = 0;
				lmax = 0;

				rmin = 0;
				rmax = 0;
			}

			index++;
			rows++;
			if(gotIndex > steps) break;
		}

		return array;
		#else
		return [[[0], [0]], [[0], [0]]];
		#end
	}

	function changeNoteSustain(value:Float):Void {
		if (curSelectedNote != null) {
			if (curSelectedNote[2] != null) {
				curSelectedNote[2] += value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}
		updateNoteUI();
		updateGrid();
	}

	function recalculateSteps():Int {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...Conductor.bpmChangeMap.length) {
			if (songMusic.time > Conductor.bpmChangeMap[i].songTime) {
				lastChange = Conductor.bpmChangeMap[i];
			}
		}
		curStep = lastChange.stepTime + Math.floor((songMusic.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void {
		updateGrid();
		updateWaveform();

		songMusic.pause();
		vocals.pause();

		// Basically old shit from changeSection???
		songMusic.time = sectionStartTime();

		if (songBeginning) {
			songMusic.time = 0;
			curSection = 0;
		}

		vocals.time = songMusic.time;

		updateCurStep();
		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void {
		//trace('changing section' + sec);
		if (_song.notes[sec] != null) {
			curSection = sec;
			updateGrid();
			if (updateMusic) {
				songMusic.pause();
				vocals.pause();

				songMusic.time = sectionStartTime();
				vocals.time = songMusic.time;
				updateCurStep();
			}
			updateGrid();
			updateSectionUI();
			updateWaveform();
		}
	}

	function copySection(?sectionNum:Int = 1) {
		var daSec = FlxMath.maxInt(curSection, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes) {
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);
			var copiedNote:Array<Dynamic> = [strum, note[1], note[2]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}
		updateGrid();
	}

	function updateSectionUI():Void {
		var sec = _song.notes[curSection];

		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_mustSecondOpponentSection.checked = sec.mustSecondOpponentSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;
	}

	function updateHeads():Void {
		var healthIconP1:String = _song.player1;
		var healthIconP2:String = _song.player2;

		if (_song.notes[curSection].mustHitSection) {
			leftIcon.updateIcon(healthIconP1);
			rightIcon.updateIcon(healthIconP2);
			if (_song.notes[curSection].gfSection) leftIcon.updateIcon('gf');
		} else {
			leftIcon.updateIcon(healthIconP2);
			rightIcon.updateIcon(healthIconP1);
			if (_song.notes[curSection].gfSection) leftIcon.updateIcon('gf');
		}
	}

	function updateNoteUI():Void {
		if (curSelectedNote != null) stepperSusLength.value = curSelectedNote[2];
	}

	function updateGrid():Void {
		curRenderedNotes.clear();
		curRenderedNoteTypes.clear();
		curRenderedSustains.clear();

		while (curRenderedNotes.members.length > 0) {
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		}

		while (curRenderedNoteTypes.members.length > 0) {
			curRenderedNoteTypes.remove(curRenderedNoteTypes.members[0], true);
		}

		while (curRenderedSustains.members.length > 0) {
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		}

		var sectionInfo:Array<Dynamic> = _song.notes[curSection].sectionNotes;
		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0) {
			Conductor.changeBPM(_song.notes[curSection].bpm);
			FlxG.log.add('CHANGED BPM!');
		} else {
			// get last bpm
			var daBPM:Float = _song.bpm;
			for (i in 0...curSection) {
				if (_song.notes[i].changeBPM) {
					daBPM = _song.notes[i].bpm;
				}
			}
			Conductor.changeBPM(daBPM);
		}

		for (i in sectionInfo) {
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];
			var daNoteType = 0;

			if (i.length > 2) {
				daNoteType = i[3];
			}

			var note:Note = ForeverAssets.generateArrow(PlayState.assetModifier, daStrumTime, daNoteInfo % 4, daNoteType, 0);
			note.sustainLength = daSus;
			note.noteType = daNoteType;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.updateHitbox();
			note.x = Math.floor(daNoteInfo * GRID_SIZE);
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));
			note.mustPress = _song.notes[curSection].mustHitSection;

			if (i[1] > 3) {
				note.mustPress = !note.mustPress;
			}

			curRenderedNotes.add(note);

			if (daNoteType != 0) {
				var noteTypeTxt:FlxText = new FlxText(0, 0, 0, ""+daNoteType);
				noteTypeTxt.setFormat(null, 14, FlxColor.WHITE, "center", OUTLINE, FlxColor.BLACK);
				noteTypeTxt.x = note.x + (GRID_SIZE / 2) - (noteTypeTxt.width / 2);
				noteTypeTxt.y = note.y + (GRID_SIZE / 2) - (noteTypeTxt.height / 2);
				curRenderedNoteTypes.add(noteTypeTxt);
				trace('note type: ' + daNoteType);
			}

			if (daSus > 0) {
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2) - 4,
					note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * 16, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}
		}
	}

	private function addSection(lengthInSteps:Int = 16):Void {
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			mustSecondOpponentSection: false,
			sectionNotes: [],
			gfSection: false,
			typeOfSection: 0,
			altAnim: false
		};
		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void {
		var swagNum:Int = 0;
		for (i in _song.notes[curSection].sectionNotes) {
			if (i.strumTime == note.strumTime && i.noteData % 4 == note.noteData) {
				curSelectedNote = _song.notes[curSection].sectionNotes[swagNum];
			}
			swagNum += 1;
		}
		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void{
		var data:Null<Int> = note.noteData;
		if (data > -1 && note.mustPress != _song.notes[curSection].mustHitSection) data += 4;

		if (data > -1) {
			for (i in _song.notes[curSection].sectionNotes) {
				if (i[0] == note.strumTime && i[1] == data) {
					FlxG.log.add('FOUND EVIL NUMBER');
					_song.notes[curSection].sectionNotes.remove(i);
					break;
				}
			}
		}
		updateGrid();
	}

	function clearSection():Void {
		_song.notes[curSection].sectionNotes = [];
		updateGrid();
	}

	function clearSong():Void {
		for (daSection in 0..._song.notes.length) {
			_song.notes[daSection].sectionNotes = [];
		}
		updateGrid();
	}

	private function addNote():Void {
		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteData = Math.floor(FlxG.mouse.x / GRID_SIZE);
		var noteType = curNoteType; // define notes as the current type
		var noteSus = 0; // ninja you will NOT get away with this

		_song.notes[curSection].sectionNotes.push([noteStrum, noteData, noteSus, noteType]);

		curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		if (FlxG.keys.pressed.CONTROL) {
			_song.notes[curSection].sectionNotes.push([noteStrum, (noteData + 4) % 8, noteSus, noteType]);
		}

		trace(noteStrum);
		trace(curSection);

		updateGrid();
		updateNoteUI();
		autosaveSong();
	}

	function getStrumTime(yPos:Float):Float {
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float {
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}

	private var daSpacing:Float = 0.3;
	function loadLevel():Void {
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic> {
		var noteData:Array<Dynamic> = [];

		for (i in _song.notes) {
			noteData.push(i.sectionNotes);
		}

		return noteData;
	}

	function loadJson(song:String):Void {
		PlayState.SONG = Song.loadFromJson(song.toLowerCase(), song.toLowerCase());
		FlxG.resetState();
	}

	function loadAutosave():Void {
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		FlxG.resetState();
	}

	function autosaveSong():Void {
		FlxG.save.data.autosave = Json.stringify({
			"song": _song
		});
		FlxG.save.flush();
	}

	private function saveLevel() {
		var json = {
			"song": _song
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0)) {
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + ".json");
		}
	}

	function onSaveComplete(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}

	function getSectionBeats(?section:Null<Int> = null) {
		if (section == null) section = curSection;
		var val:Null<Float> = null;
		
		if(_song.notes[section] != null) _song.notes[section].sectionNotes;
		return val != null ? val : 4;
	}
}
