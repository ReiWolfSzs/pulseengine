package meta;

import flixel.tweens.motion.QuadPath;
import flixel.math.FlxPoint;
import flixel.tweens.motion.LinearPath;
import flixel.tweens.motion.CircularMotion;
import flixel.tweens.motion.CubicMotion;
import flixel.tweens.motion.QuadMotion;
import flixel.tweens.motion.LinearMotion;
import flixel.FlxObject;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import flixel.tweens.misc.AngleTween;
import flixel.util.FlxAxes;
import flixel.FlxSprite;
import flixel.tweens.misc.ShakeTween;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween.TweenOptions;

/**
 * An FlxTween class used specifically for PlayState
 * 
 * Uses it's own FlxTweenManager in order to implement "tween pausing" while PlayState is paused
 * 
 * (STRONGLY RECOMMEND USING THIS ONE FOR EVENTS IF YOU WANT YOUR TWEENS TO PAUSE WHEN GAME IS PAUSED WITHOUT GLOBALLY PAUSING ALL TWEENS)
 */

class FlxTweenPlayState
{
    public static var globalManager:FlxTweenManager = new FlxTweenManager();

    public static function tween(Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options:TweenOptions):VarTween
    {
        return globalManager.tween(Object, Values, Duration, Options);
    }

    public static function num(FromValue:Float, ToValue:Float, Duration:Float = 1, ?Options:TweenOptions, ?TweenFunction:Float->Void):NumTween
	{
		return globalManager.num(FromValue, ToValue, Duration, Options, TweenFunction);
	}

    public static function shake(Sprite:FlxSprite, Intensity:Float = 0.05, Duration:Float = 1, ?Axes:FlxAxes, ?Options:TweenOptions):ShakeTween
	{
		return globalManager.shake(Sprite, Intensity, Duration, Axes, Options);
	}

    public static function angle(?Sprite:FlxSprite, FromAngle:Float, ToAngle:Float, Duration:Float = 1, ?Options:TweenOptions):AngleTween
	{
		return globalManager.angle(Sprite, FromAngle, ToAngle, Duration, Options);
	}

    public static function color(?Sprite:FlxSprite, Duration:Float = 1, FromColor:FlxColor, ToColor:FlxColor, ?Options:TweenOptions):ColorTween
	{
		return globalManager.color(Sprite, Duration, FromColor, ToColor, Options);
	}

    public static function linearMotion(Object:FlxObject, FromX:Float, FromY:Float, ToX:Float, ToY:Float, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
        ?Options:TweenOptions):LinearMotion
    {
        return globalManager.linearMotion(Object, FromX, FromY, ToX, ToY, DurationOrSpeed, UseDuration, Options);
    }

    public static function quadMotion(Object:FlxObject, FromX:Float, FromY:Float, ControlX:Float, ControlY:Float, ToX:Float, ToY:Float,
            DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:TweenOptions):QuadMotion
    {
        return globalManager.quadMotion(Object, FromX, FromY, ControlX, ControlY, ToX, ToY, DurationOrSpeed, UseDuration, Options);
    }

    public static function cubicMotion(Object:FlxObject, FromX:Float, FromY:Float, aX:Float, aY:Float, bX:Float, bY:Float, ToX:Float, ToY:Float,
            Duration:Float = 1, ?Options:TweenOptions):CubicMotion
    {
        return globalManager.cubicMotion(Object, FromX, FromY, aX, aY, bX, bY, ToX, ToY, Duration, Options);
    }

    public static function circularMotion(Object:FlxObject, CenterX:Float, CenterY:Float, Radius:Float, Angle:Float, Clockwise:Bool,
            DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:TweenOptions):CircularMotion
    {
        return globalManager.circularMotion(Object, CenterX, CenterY, Radius, Angle, Clockwise, DurationOrSpeed, UseDuration, Options);
    }

    public static function linearPath(Object:FlxObject, Points:Array<FlxPoint>, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
            ?Options:TweenOptions):LinearPath
    {
        return globalManager.linearPath(Object, Points, DurationOrSpeed, UseDuration, Options);
    }

    public static function quadPath(Object:FlxObject, Points:Array<FlxPoint>, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
            ?Options:TweenOptions):QuadPath
    {
        return globalManager.quadPath(Object, Points, DurationOrSpeed, UseDuration, Options);
    }

    public static function cancelTweensOf(Object:Dynamic, ?FieldPaths:Array<String>):Void
    {
        globalManager.cancelTweensOf(Object, FieldPaths);
    }

    public static function completeTweensOf(Object:Dynamic, ?FieldPaths:Array<String>):Void
    {
        globalManager.completeTweensOf(Object, FieldPaths);
    }
}