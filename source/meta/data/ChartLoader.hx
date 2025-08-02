package meta.data;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gameObjects.userInterface.notes.*;
import gameObjects.userInterface.notes.Note.EventNote;
import meta.data.Section.SwagSection;
import meta.data.Song.SwagSong;
import meta.state.PlayState;

/**
	This is the chartloader class. it loads in charts, but also exports charts, the chart parameters are based on the type of chart, 
	say the base game type loads the base game's charts, the forever chart type loads a custom forever structure chart with custom features,
	and so on. This class will handle both saving and loading of charts with useful features and scripts that will make things much easier
	to handle and load, as well as much more modular!
**/
class ChartLoader {
	// hopefully this makes it easier for people to load and save chart features and such, y'know the deal lol
	public static function generateChart(songData:SwagSong):Array<Note> {
		var unspawnNotes:Array<Note> = [];
		var noteData:Array<SwagSection>;

		noteData = songData.notes; // load fnf style charts (PRE 2.8)
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData) {
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			for (songNotes in section.sectionNotes) {
				var daStrumTime:Float = #if !neko songNotes[0] - Init.trueSettings['Offset'] /* - | late, + | early */ #else songNotes[0] #end;
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				// define the note's animation (in accordance to the original game)!
				var daNoteAlt:Float = 0;

				var daNoteType:Int = 0;
				if (songNotes.length > 2) {
					daNoteType = songNotes[3];
				}

				// very stupid but I'm lazy
				/*if (songNotes.length > 2)
					daNoteAlt = songNotes[3];
				*/
				// check the base section
				var gottaHitNote:Bool = section.mustHitSection;

				// if the note is on the other side, flip the base section of the note
				if (songNotes[1] > 3)
					gottaHitNote = !section.mustHitSection;

				// define the note that comes before (previous note)
				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else // if it exists, that is
					oldNote = null;

				// create the new note
				var swagNote:Note = ForeverAssets.generateArrow(PlayState.assetModifier, daStrumTime, daNoteData, daNoteType, daNoteAlt);
				// set note speed
				swagNote.noteSpeed = songData.speed;

				// set the note's length (sustain note)
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);
				var susLength:Float = swagNote.sustainLength; // sus amogus
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength)) {
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					var sustainNote:Note = ForeverAssets.generateArrow(PlayState.assetModifier,
						daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, daNoteType, daNoteAlt, true, oldNote);
					sustainNote.scrollFactor.set();

					unspawnNotes.push(sustainNote);
					sustainNote.mustPress = gottaHitNote;
				}
				// oh and set the note's must hit section
				swagNote.mustPress = gottaHitNote;
			}
			daBeats += 1;
		}
		return unspawnNotes;
	}

	public static function generateEvents(songData:SwagSong):Array<EventNote> {
		var eventNotes:Array<EventNote> = [];
		if (songData.events == null) return eventNotes;
		for(event in songData.events) {
			for(i in 0...event[1].length) {
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0],
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				eventNotes.push(subEvent);
			}
		}
		return eventNotes;
	}
}
