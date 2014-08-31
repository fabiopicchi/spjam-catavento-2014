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
	public var angle:Float = 0;
	
	public function new(id:Int, r:Array<Point>) {
        this.id = id;
		super ();
		
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, 10, 10);
        visible = false;
		
		route = r;
		
		reset();
	}
	
	override public function update(dt:Float):Void 
    {
        super.update(dt);
		
		if (active) {
			x -= Math.sin(angle) * dt * speed;
			y -= Math.cos(angle) * dt * speed;
		    if ((x - target.x) * (x - target.x) +
                (y - target.y) * (y - target.y) <= 50) 
            {
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
        visible = true;
	}
	
	public function reset():Void 
    {
        visible = true;
		x = route[0].x;
		y = route[0].y;
		currentTargetId = 0;
		active = false;
	}
	
	public function loadNextStep():Void
	{
		currentTargetId ++;
		if (currentTargetId == route.length-1) {
            visible = false;
			active = false;
            dispatchEvent(new CircuitEvent(CircuitEvent.DEACTIVATE, id));
		}
		startWalkingTo(route[currentTargetId]);
	}
	
	public function startWalkingTo(t:Point):Void 
	{
		target = t;
		angle = Math.atan2(x - target.x, y - target.y);
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
