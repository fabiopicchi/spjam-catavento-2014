package  ;

import core.Element;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author Chambers
 */
class Guard extends Element {
	
	public var behaviorType:Int; // 0 = noWait, 1 = Wait, 2 = LookAround
	public var route:Array<Point>;
	public var currentTargetId:Int = 0;
	public var target:Point;
	public var goingBack:Bool;
	
	public var state:Int; // 0 = waiting, 1 = walking
	public var speed:Float = 100;
	public var angle:Float = 0;
	
	public var waitingTimer:Float;
	public var rotateTimer:Float;
	
	public var attention:Float = 0;
	public var faceDirection:Int = 0;
	
	public var eye:Point;							//coordenadas do olho do guarda
	public var visionAngle:Float = 0;				//direção da visão do guarda
	public var visionWidth:Float = Math.PI / 6;		//delta máximo para enxergar o herói
	
	public function new(b:Int, r:Array<Point>) {
		super ();
		
		var s : Shape = new Shape();
        s.graphics.beginFill(0xFF0000);
        s.graphics.drawRect(0, 0, 60, 60);
        addChild(s);
		
		behaviorType = b;
		route = r ;
		
		x = route[0].x;
		y = route[0].y;
		
		eye = new Point();
		
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
		
		eye.x = x + 42;
		eye.y = y + 42;
		visionAngle = faceDirection * Math.PI / 2;
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
		rotateTimer = 1;
	}
	
	public function wait(dt:Float):Void 
	{
		waitingTimer -= dt;
		rotateTimer -= dt;
		
		if (behaviorType == 2) {
			if (rotateTimer <= 0) {
				rotate();
				rotateTimer = 1;
			}
		}
		
		if (waitingTimer <= 0) {
			loadNextStep();
		}
	}
	
	public function rotate():Void 
	{
		faceDirection += (Math.random() > 0.5) ? -1 : 1;
		faceDirection = faceDirection % 4;
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