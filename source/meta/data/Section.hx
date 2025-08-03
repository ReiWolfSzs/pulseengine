package meta.data;

typedef SwagSection =
{
	var sectionBeats:Int;
	var sectionNotes:Array<Dynamic>;
	var gfSection:Bool;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var mustSecondOpponentSection:Bool;
	var noteSpeed:Float;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}

class Section
{
	public var sectionBeats:Int = 4;
	public var sectionNotes:Array<Dynamic> = [];
	public var gfSection:Bool = false;
	public var lengthInSteps:Int = 16;
	public var typeOfSection:Int = 0;
	public var mustHitSection:Bool = true;
	public var mustSecondOpponentSection:Bool = false;

	/**
	 *	Copies the first section into the second section!
	 */
	public static var COPYCAT:Int = 0;

	public function new(lengthInSteps:Int = 16)
	{
		this.lengthInSteps = lengthInSteps;
	}
}
