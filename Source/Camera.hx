package  ;

import core.Element;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author Chambers
 */
class Camera extends Element {
	
	public var circuitId:Int;
	
	public var initialAngle:Float;
	public var deltaMax:Float = Math.PI / 6;
	public var angularSpeed:Float;
	public var goingBack:Bool;
	public var waitTimer:Float;
	
	public var eye:Point;
	public var angle:Float = 0;
	public var visionWidth:Float = Math.PI / 6;
	
	public var deactivationTimer:Float = 0;
	
	//public var exclamation:Exclamation;
	
	public function new(x:Float, y:Float, initialAngle:Float, id:Int) {
		super ();
		
		var s : Shape = new Shape();
        s.graphics.beginFill(0xFF0000);
        s.graphics.drawRect(0, 0, 60, 60);
        addChild(s);
		
		this.x = x;
		this.y = y;
		
		eye = new Point();
		initialAngle = initialAngle;
		visionAngle = initialAngle;
		goingBack = false;
	}
	
	override public function update(dt:Float):Void 
    {
        super.update(dt);
		
		eye.x = x;
		eye.y = y;
		
		if (deactivationTimer > 0) {
			deactivationTimer -= dt;
		}
		else {
			if (timer > 0) {
				timer -= dt;
			}
			else{
				
				if (!goingBack) {
					angle += dt * angularSpeed;
					if (angle > initialAngle + deltaMax) {
						angle = initialAngle + deltaMax;
						goingBack = true;
						waitTimer = 300;
					}
				}
				else {
					angle -= dt * angularSpeed;
					if (angle < initialAngle - deltaMax) {
						angle = initialAngle - deltaMax;
						goingBack = true;
						waitTimer = 300;
					}
				}
				
			}
		}
    }
	
	override public function draw():Void 
    {
        super.draw();
    }
	
	public function focusOnHero(p:Point):Void {
		
	}
	
	public function deactivate():Void {
		deactivationTimer = 8;
	}
}