package gameObjects.userInterface;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import flixel.FlxCamera;
import flixel.addons.display.shapes.FlxShapeLine;
import flixel.util.FlxSpriteUtil;
import sys.io.File;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

typedef BarModifier = {
	var minHeight:Float;
	var maxHeight:Float;

	var startingSpectrum:Int;

	var multiplier:Float;
}
/**
 * MUST HAVE AN AUDIO SPECTRUM DATA FILE
 * 
 * WARNING: BAR AMOUNT MUST CORRESPOND WITH SPECTRUM DATA AMOUNT
 */
class BarVisualizer extends FlxSpriteGroup {
	public var audio:FlxSound;
	var barGroup:Array<FlxSprite> = [];
	var spectrumData:String = "";
	var originalY:Float = 0;
	var trimmedSpectrumData:Array<Array<Dynamic>>;

	var mods:BarModifier;

	var songTime:Float;
	var spectrumOrder:Int;
	public function new(X:Float = 0, Y:Float = 0, barAmount:Int, barWidth:Int, spaceBetweenBars:Float, spectrumFile:String, ?modifiers:BarModifier)
	{
		super(X, Y);
		originalY = Y;

		spectrumData = File.getContent(spectrumFile);
		var xVal = X;
		for (i in 0...barAmount + 1)
		{
			if (i != 0)
			    xVal += barGroup[i - 1].width + barWidth;
			var bar = new FlxSprite(xVal, Y);
			bar.makeGraphic(barWidth, 1);
			add(bar);
			barGroup.push(bar);
		}
		
		trimmedSpectrumData = retrievesSpectrumData();
		
		mods = {
			minHeight: 0,
			maxHeight: Math.POSITIVE_INFINITY,
			startingSpectrum: 0,
			multiplier: 1
		}
		if (modifiers != null)
			mods = modifiers;
	}
	override function update(elapsed:Float) {
		super.update(elapsed);
		if (audio != null && audio.playing)
		{
			songTime = audio.time / 1000;
			spectrumOrder = 0;

			var time = trimmedSpectrumData[0];
			for (i in time)
				if (Math.abs(songTime - i) <= 0.03)
					spectrumOrder = time.indexOf(i);
			for (i in 0...barGroup.length)
			{
				var order = i;
				if (flipX) order = barGroup.length - 1 - i;
				barGroup[order].scale.y = FlxMath.lerp(barGroup[order].scale.y, mods.minHeight + (trimmedSpectrumData[1][spectrumOrder][i + mods.startingSpectrum] * (mods.maxHeight - mods.minHeight) * 5 * mods.multiplier), FlxG.elapsed / (1 / 60) * 0.3);
				barGroup[order].updateHitbox();
				if (!flipY)
					barGroup[order].y = originalY;
				else 
					barGroup[order].y = originalY - barGroup[order].height;
			}
		}
	}
	function retrievesSpectrumData():Array<Array<Dynamic>>
	{
		var splitSpecData = spectrumData.split("||");

		var totalTime:Array<Float> = [];
		var totalFreq:Array<Array<Float>> = [];

		for (splittedData in splitSpecData)
		{
		    var time = Std.parseFloat(splittedData.split(";")[0]); 
			totalTime.push(time);

			var freq:Array<Float> = [];
			for (freqData in splittedData.split(";")[1].split(","))
			{
				freq.push(Std.parseFloat(freqData));
			}
			totalFreq.push(freq);
		}

		var filteredSpectrumData:Array<Array<Dynamic>> = [
			totalTime,
			totalFreq
		];

		return filteredSpectrumData;
	}
}

/////////////////////////////////////////////////////////////////////////////

typedef WaveModifier =
{
	public var jointAmt:Int;
	public var multiplier:Float;
	public var thickness:Float;
}

class WaveVisualizer extends FlxSprite
{

	public var music:FlxSound;

	var joints:Array<Float> = [];
	var modifier:WaveModifier;

	var timer:Float = 0;

	public function new(X:Float = 0, Y:Float = 0, modifier:WaveModifier)
	{
		super(X, Y);
		makeGraphic(1280, 720, FlxColor.TRANSPARENT);

		for (i in 0...modifier.jointAmt)
			joints.push(0);
		this.modifier = modifier;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		for (i in 0...joints.length)
		{
			var lerp = FlxMath.lerp(joints[i], music.amplitude * 3000 * modifier.multiplier * FlxG.random.float(-1, 1), elapsed / (1 / 60));
			if (i != 0 && i != 1 && i != joints.length - 1)
				joints[i] = FlxMath.bound(lerp, -100, 100);
		}

		timer += elapsed;
		if (timer >= 1 / 30)
		{
			timer = 0;
			
			pixels.fillRect(new Rectangle(0, 0, 1280, 720), FlxColor.TRANSPARENT);
			for (joint in 0...joints.length)
				if (joint != 0 && joint != joints.length - 1)
					FlxSpriteUtil.drawLine(this, 1280 / joints.length * joint, 360 + joints[joint], 1280 / joints.length * (joint + 1),
						360 + joints[joint + 1], {
							thickness: modifier.thickness,
							color: FlxColor.WHITE
						});
		}
	}
}