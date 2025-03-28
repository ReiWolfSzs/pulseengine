package gameObjects.userInterface;

import flixel.util.FlxPool;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;

class SquareRiser extends FlxSpriteGroup{
	public var minX:Float = 0;
	public var maxX:Float = 0;

    var pool:Pool<Square>;

    public function new(X:Float = 0, Y:Float = 0)
    {
        super(X, Y);
        pool = new Pool(800, Square);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        for (obj in pool.getActive())
        {
			if (obj.active == false)
				removeMember(obj);
        }
		if (FlxG.random.bool(70 * elapsed * 5))
			spawnSquare();
    }

    public function spawnSquare()
    {
		var numToSpawn = FlxG.random.int(10, 15);
		var width = 9000 / numToSpawn;

		for (i in 0...numToSpawn)
		{
            var obj = pool.pull();

			if (obj == null) break;

            obj.setPosition(FlxG.random.float(minX, maxX) - 300 + width * i, 2500);
            obj.active = true;
            add(obj);
		}
    }

    public function removeMember(obj:Square)
    {
        obj.active = false;
        pool.put(obj);
        remove(obj);
    }


}

class Pool<T> {
    var _class:Class<T>;

    var _pool:Array<T> = [];
    var _active:Array<T> = []; //currently used obj

    public function new(preAllocate:Int = 0, _classObj:Class<T>)
    {
        _class = _classObj;
        if (preAllocate > 0)
        {
            for (i in 0...preAllocate)
                _pool.push(Type.createInstance(_class, []));
        }
    }

    public function getActive():Array<T>
        return _active.copy();

    public function pull():T
    {
        if (_pool.length <= 0) return null;

        var instance = _pool.shift();

		_active.push(instance);

        return instance;
    }

    public function put(obj:Null<T>) {
        if (obj != null)
        {
            _pool.push(_active[_active.indexOf(obj)]);
			_active.remove(_active[_active.indexOf(obj)]);
        }
        else
            _pool.push(_active.shift());
    }
}

class Square extends FlxSprite
{
	var lifeSpan:Float = 15;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);
        active = false;
        
		makeGraphic(70, 70);
        alpha = 0.2;
		angularVelocity = 100;
		velocity.y -= 200;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		lifeSpan -= elapsed;
		if (lifeSpan <= 0)
		{
            lifeSpan = 15;
            active = false;
        }
	}
}