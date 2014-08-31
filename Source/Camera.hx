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
	
	public static var BLUE:String = "blue";
    public static var GREEN:String = "green";
    public static var RED:String = "red";
	
	private var FRAME_WIDTH:Int = 30;
    private var FRAME_HEIGHT:Int = 21;
	
	public var initialAngle:Float;
	public var deltaMax:Float = Math.PI / 6;
	public var ANGULAR_SPEED:Float = 8;
	public var goingBack:Bool;
	public var waitTimer:Float;
	
	public var eye:Point;
	public var angle:Float = 0;
	public var visionWidth:Float = Math.PI / 6;
	
	public var deactivationTimer:Float = 0;
	
	//public var exclamation:Exclamation;
	
	public function new(x:Float, y:Float, initialAngle:Float, color:String, id:Int) {
		super ();
		
		var s : Shape = new Shape();
        s.graphics.beginFill(0xFF0000);
        s.graphics.drawRect(0, 0, 60, 60);
        addChild(s);
		
		this.x = x;
		this.y = y;
		
		eye = new Point();
		this.initialAngle = initialAngle;
		angle = initialAngle;
		goingBack = false;
		
		var s : Shape = new Shape();
        s.graphics.beginFill(0xFF0000);
        s.graphics.drawRect(0, 0, 60, 60);
        addChild(s);
	}
	
	override public function update(dt:Float):Void 
    {
        super.update(dt);
		
		eye.x = x;
		eye.y = y;
		
		if (waitTimer > 0) {
			waitTimer -= dt;
		}
		else {
			if (deactivationTimer > 0) {
				deactivationTimer -= dt;
			}
			else{
				
				if (!goingBack) {
					angle += dt * ANGULAR_SPEED;
					if (angle > initialAngle + deltaMax) {
						angle = initialAngle + deltaMax;
						goingBack = true;
						waitTimer = 300;
					}
				}
				else {
					angle -= dt * ANGULAR_SPEED;
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