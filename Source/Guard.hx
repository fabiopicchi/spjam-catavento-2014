package  ;

import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author Chambers
 */
class Guard extends Element {
	
	public var route:Array<Point>;
	public var currentTarget:Int = 0;
	public var targetX, targetY:Int;
	public var goingBack:Bool;
	public var speed:Float;
	public var direction:Int = 0;
	public var behaviorType:String;
	
	public var attention:Float = 0;
	public var visionAngle:Float = 0;
	public var visionWidth:Float = Math.PI / 3;
	
	private var image:Bitmap;
	
	public function new(routeId:String) {
		super ();
		route = [ new Point (40,40), new Point (120,40), new Point (120,120) ] ;
		goingBack = false;
		currentTarget = 1;
	}
	
	public function update(dt:Float):Void 
    {
        super.update(dt);
    }
	
	public function draw():Void 
    {
        super.draw();
    }
	
	public function loadNextStep():Void
	{

	}
}