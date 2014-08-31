package  ;

import core.Element;
import core.SpriteSheet;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Chambers
 */
class Camera extends Element {
	
	public var circuitId:Int;
	
	public var deactivationTimer:Float = 0;
	private var _ss:SpriteSheet;
    private var _light:Bitmap;
	
	public static var BLUE:String = "blue";
    public static var GREEN:String = "green";
    public static var RED:String = "red";
	
	private var FRAME_WIDTH:Int = 60;
    private var FRAME_HEIGHT:Int = 60;
	
	public var initialAngle:Float;
	public var angle:Float = 0;
	public var deltaMax:Float = Math.PI / 6;
	public var ANGULAR_SPEED:Float = 0.5;
	public var animPos:Int = 0;
	public var goingBack:Bool;
	public var waitTimer:Float;
	
	public var eye:Point;
	public var visionWidth:Float = 1* Math.PI / 6;
	
	public function new(x:Float, y:Float, color:String, id:Int) {
		super ();
		
		this.x = x;
		this.y = y;
		
		eye = new Point();
		initialAngle = 1;
		angle = 1;
		goingBack = false;
		
		_ss = new SpriteSheet("assets/camera.png", FRAME_WIDTH, FRAME_HEIGHT) ;
		
		for (i in 0...7)
		{
			_ss.addAnimation("a"+i, [new Rectangle(i*FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT)], true, 1);
		}
		_ss.setAnimation("a0");
		
		_ss.x = 0;
		_ss.y = 0;
		
		addElement(_ss);
	}
	
	override public function update(dt:Float):Void 
    {
        super.update(dt);
		
		eye.x = x + 30;
		eye.y = y + 25;
		
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
						waitTimer = 1;
					}
				}
				else {
					angle -= dt * ANGULAR_SPEED;
					if (angle < initialAngle - deltaMax) {
						angle = initialAngle - deltaMax;
						goingBack = false;
						waitTimer = 1;
					}
				}
				
			}
		}
		
		animPos = Math.floor( 0.5 + (angle / deltaMax) * 3 - 3);

		_ss.setAnimation("a"+animPos);
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
