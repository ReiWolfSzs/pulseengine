package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class Backupriser extends FlxSpriteGroup {
	public var minX:Float = 0;
    public var maxX:Float = 0;

    var squareAlpha:Float = 0.2;
    var squareScale:Float = 1;

    static var die:Array<FlxSprite> = [];

    public function new(X:Float = 0, Y:Float = 0) //mago psttt psstttttt
    {
        super(X, Y);
        die = [];
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.random.bool(70 * elapsed * 5))
            spawnSquare();
    }

    public function setAlpha(alpha:Float = 0.2)
    {
        squareAlpha = alpha;
		for (i in die)
			i.alpha = squareAlpha;
    }

	public function setScale(scale:Float = 1)
	{
		squareScale = scale;
		for (i in die)
			i.scale.set(squareScale, squareScale);
	}

    public static function removeMember(obj:FlxSprite) {
        die.remove(obj);
    }

    function spawnSquare()
    {
        var numToSpawn = FlxG.random.int(10, 15);
        var width = 9000 / numToSpawn;

		for (i in 0...numToSpawn)
		{
			var duh = new Grtrtg(FlxG.random.float(minX, maxX) - 300 + width * i, 2500);
            duh.makeGraphic(1, 1);
            duh.scale.set(70 * squareScale, 70 * squareScale);
            duh.alpha = squareAlpha;
            add(duh);
            die.push(duh);
        }
    }
}

class Grtrtg extends FlxSprite
{
	var lifeSpan:Float = 15;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);
		makeGraphic(70, 70);
		angularVelocity = 100;
		velocity.y -= 200;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		lifeSpan -= elapsed;
		if (lifeSpan <= 0)
		{
			Backupriser.removeMember(this);
			destroy();
		}
	}
}