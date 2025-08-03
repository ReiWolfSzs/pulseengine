package;

import lime.app.Application;
import flixel.effects.particles.FlxEmitter;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import meta.FlxTweenPlayState;
import flixel.util.FlxColor;
import flixel.FlxG;
import shaders.ShaderObject;
import flixel.FlxBasic;
import meta.state.PlayState;

class Events {
	var game = PlayState;
	var game2 = PlayState.instance;
    var songName:String;

	var textMaps:Map<String, FlxText> = new Map();

	var step:Int;
	var beat:Int;

    public function new(name:String) {
        songName = name;
        switch (songName) {
			case 'bopeebo-erect':
				FlxG.updateFramerate = 120;
				FlxG.drawFramerate = 120;
				game.dadOpponent.x = 100;
				game.dadOpponent.angle = 100;
        }
    }

    public function onStep(curStep:Int) {
		step = curStep;
        switch (songName) {
			
        }
    }

    public function onBeat(curBeat:Int) {
		beat = curBeat;
        switch (songName) {
			
        }
    }

	public function onNoteHit(isOpponent:Bool) {
		switch (songName) {
			
		}
	}

    public function onUpdate(elapsed:Float) {
        switch (songName) {
			case 'bopeebo-erect':
				var speed:Float = 60;
				game.dadOpponent.x += speed * elapsed;
				game.dadOpponent.angle += speed * elapsed;
			}
    }

	public function onSection(section:Int) {
		switch (songName) {
			
		}
	}

	public function onPause() {
		switch (songName) {
			
		}
	}

	public function onResume() {
		switch (songName) {
			
		}
	}

	function initLyrics(?word:String, ?axis:Array<Float>, ?color:Int, ?size:Int, ?alignment:FlxTextAlign, ?worldSpace:Bool = false) {
		var text = new FlxText(axis[0], axis[1], 0, word, size);
		text.color = Std.int(color);
		if (worldSpace)
			text.camera = PlayState.camGame;
		else
			text.camera = PlayState.camText;
		text.font = Paths.font("vcr.ttf");
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xff000000, 2);
		text.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		text.scrollFactor.set();
		text.alignment = alignment;
		textMaps.set(word, text);
	}

    function add(Object:FlxBasic, ?layer:Null<Int>) {
        var layerID:Int;
        if (layer != null)
            layerID = layer;
        else
            layerID = PlayState.instance.members.length;

        PlayState.instance.insert(layerID, Object);
    }

	function remove(Obj:FlxBasic) {
		var index = PlayState.instance.members.indexOf(Obj);
		PlayState.instance.members[index] = null;
	}
}