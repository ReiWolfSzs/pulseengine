package gameObjects.userInterface;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class PhillyGlowParticle extends FlxSprite
{
	var lifeTime:Float = 0;
	var decay:Float = 0;
	var originalScale:Float = 1;
	public function new(x:Float, y:Float, color:FlxColor)
	{
		super(x, y);
		this.color = color;

		loadGraphic(Paths.image('county-sprites/glow/particle'));
		lifeTime = FlxG.random.float(2, 3);
		decay = FlxG.random.float(0.8, 1);
		decay *= 0.5;
		alpha = 0.35;

		originalScale = FlxG.random.float(1.5, 2);
		scale.set(originalScale, originalScale);

		scrollFactor.set(FlxG.random.float(0.3, 0.75), FlxG.random.float(0.65, 0.75));
		velocity.set(FlxG.random.float(-40, 40), FlxG.random.float(-175, -250));
		acceleration.set(FlxG.random.float(-10, 10), 25);
	}

	override function update(elapsed:Float)
	{
		lifeTime -= elapsed;
		if(lifeTime < 0)
		{
			lifeTime = 0;
			alpha -= decay * elapsed;
			scale.set(originalScale * alpha, originalScale * alpha);
		}
		super.update(elapsed);
	}
}

class PhillyGlowGradient extends FlxSprite
{
	public var originalY:Float;
	public var originalHeight:Int = 600;
	public var intendedAlpha:Float = 1;
	public function new(x:Float, y:Float)
	{
		super(x, y);
		originalY = y;

		loadGraphic(Paths.image('county-sprites/glow/gradient'));
		scrollFactor.set(0, 0.75);
		setGraphicSize(5000, originalHeight);
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		var newHeight:Int = Math.round(height - 800 * elapsed);
		if(newHeight > 0)
		{
			alpha = intendedAlpha;
			setGraphicSize(5000, newHeight);
			updateHitbox();
			if (!flipY)
			    y = originalY + (originalHeight - height);
			else 
				y = originalY - (originalHeight - height);
		}
		else
		{
			alpha = 0;
			y = -5000;
		}

		super.update(elapsed);
	}

	public function bop()
	{
		setGraphicSize(5000, originalHeight);
		updateHitbox();
		if (!flipY)
		    y = originalY;
		else
			y = originalY + height;
		alpha = intendedAlpha;
	}
}