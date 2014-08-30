package  ;

import core.Element;
import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author Chambers
 */
class Guard extends Element {
	
	public var behaviorType:Int; // 0 = noWait, 1 = wait
	public var route:Array<Point>;
	public var currentTargetId:Int = 0;
	public var target:Point;
	public var goingBack:Bool;
	
	public var state:Int; // 0 = waiting, 1 = walking
	public var speed:Float = 100;
	public var angle:Float = 0;
	public var waitingTimer:Float;
	
	public var attention:Float = 0;
	public var faceDirection:Int = 0;
	public var visionAngle:Float = 0;
	public var visionWidth:Float = Math.PI / 3;
	
	private var image:Bitmap;
	
	public function new(behaviorType:Int) {
		super ();
		
		var s : Shape = new Shape();
        s.graphics.beginFill(0xFF0000);
        s.graphics.drawRect(0, 0, 60, 60);
        addChild(s);
		
		this.behaviorType = behaviorType;
		route = [ new Point (40, 40), new Point (120, 40), new Point (120, 120) ] ;
		
		goingBack = false;
		loadNextStep();
	}
	
	override public function update(dt:Float):Void 
    {
        super.update(dt);
		
		if (state == 0) {
			wait(dt);
		}
		else if (state == 1) {
			walk(dt);
		}
    }
	
	public function startWalkingTo(t:Point):Void 
	{
		state = 1;
		target = t;
		angle = Math.atan2(x - target.x, y - target.y);
		faceDirection = Math.floor((angle / (Math.PI / 2)) % 4);
	}
	
	public function walk(dt:Float):Void 
    {
        x -= Math.sin(angle) * dt * speed;
		y -= Math.cos(angle) * dt * speed;
		if (Point.distance(new Point (x,y), target) < 2) {
			x = target.x;
			y = target.y;
			arrive();
		}
    }
	
	public function arrive():Void 
	{
		switch (behaviorType) {
			case 0:
				loadNextStep();
			case 1:
				startWaiting(2);
		}
	}
	
	public function startWaiting(time:Float):Void 
	{
		state = 0;
		waitingTimer  = time;
	}
	
	public function wait(dt:Float):Void 
	{
		waitingTimer -= dt;
		if (waitingTimer <= 0) {
			loadNextStep();
		}
	}
	
	override public function draw():Void 
    {
        super.draw();
    }
	
	public function loadNextStep():Void
	{
		if (!goingBack) {
			currentTargetId ++;
			if (currentTargetId == route.length-1) {
				goingBack = true;
			}
		}
		else {
			currentTargetId --;
			if (currentTargetId == 0) {
				goingBack = false;
			}
		}
		startWalkingTo(route[currentTargetId]);
	}
}