package  ;

import core.Element;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author Chambers
 */
class Circuit extends Element {
	
	public var id:Int;
	
	public var active:Bool;
	public var route:Array<Point>;
	public var currentTargetId:Int = 0;
	public var target:Point;
	
	public var speed:Float = 400;
	
	public function new(id:Int, r:Array<Point>) {
		super ();
		
		var s : Shape = new Shape();
        s.graphics.beginFill(0xFF0000);
        s.graphics.drawRect(0, 0, 60, 60);
        addChild(s);
		
		//exclamation = new Exclamation ();
		//addChild (exclamation);
		
		route = r ;
		
		reset();
	}
	
	override public function update(dt:Float):Void 
    {
        super.update(dt);
		
		if (active) {
			x -= Math.sin(angle) * dt * speed;
			y -= Math.cos(angle) * dt * speed;
			if (Point.distance(new Point (x,y), target) < 2) {
				x = target.x;
				y = target.y;
				arrive();
			}
		}
    }
	
	public function activate():Void 
	{
		reset();
		active = true;
		loadNextStep();
	}
	
	public function reset():Void {
		x = route[0].x;
		y = route[0].y;
		currentTargetId = 0;
		active = false;
	}
	
	public function loadNextStep():Void
	{
		currentTargetId ++;
		if (currentTargetId == route.length-1) {
			dispatchEvent(new CircuitEvent("shootEvent", id, 1) );
			active = false;
		}
		startWalkingTo(route[currentTargetId]);
	}
	
	public function startWalkingTo(t:Point):Void 
	{
		state = 1;
		target = t;
		angle = Math.atan2(x - target.x, y - target.y);
		faceDirection = Math.floor((angle / (Math.PI / 2)) % 4);
	}
	
	public function arrive():Void 
	{
		loadNextStep();
	}
	
	override public function draw():Void 
    {
        super.draw();
    }
	
	public function alert():Void {
		
	}
}