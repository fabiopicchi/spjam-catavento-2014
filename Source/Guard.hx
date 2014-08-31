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
    private var _body:Body;
	
	//public var exclamation:Exclamation;

    private var _eyeRef:Shape;
	
	public function new(b:Int, r:Array<Point>) {
		super ();
		
        behaviorType = b;
		route = r;

        _body = new Body(60, 60);
        _body.position.x = route[0].x;
        _body.position.y = route[0].y;
		
		//exclamation = new Exclamation ();
		//addChild (exclamation);
		
		var s : Shape = new Shape();
        s.graphics.beginFill(0xFF0000);
        s.graphics.drawRect(0, 0, 60, 60);
        addChild(s);

        _eyeRef = new Shape();
        _eyeRef.graphics.beginFill(0x00FF00);
        _eyeRef.graphics.drawRect(0, 0, 6, 6);
        addChild(_eyeRef);
		
		eye = new Point();
		
		goingBack = false;
		loadNextStep();
	}

	public function loadNextStep():Void
	{
		if (!goingBack) {
			currentTargetId++;
			if (currentTargetId == route.length - 1) {
				goingBack = true;
				//trace ("going back!" + route);
			}
		}
		else {
			currentTargetId--;
			if (currentTargetId == 0) {
				goingBack = false;
			}
		}
		startWalkingTo(route[currentTargetId]);
	}
	
	public function startWalkingTo(t:Point):Void 
	{
		state = 1;
		target = t;
		angle = Math.atan2(target.y - _body.position.y, 
                target.x - _body.position.x);
        if (angle < 0) angle += 2 * Math.PI;
		faceDirection = Math.floor(angle / (Math.PI / 2));
	}
	
	public function walk(dt:Float):Void 
    {
        _body.position.x += Math.cos(angle) * dt * speed;
		_body.position.y += Math.sin(angle) * dt * speed;
		if ((_body.position.x - target.x) * (_body.position.x - target.x) +
            (_body.position.y - target.y) * (_body.position.y - target.y) <= 4) 
        {
			_body.position.x = target.x;
			_body.position.y = target.y;
			arrive();
		}
    }
	
	public function arrive():Void 
	{
		switch (behaviorType) {
			case 0:
				loadNextStep();
			case 1, 2:
				startWaiting(2);
		}
	}
	
	public function startWaiting(time:Float):Void 
	{
		state = 0;
		waitingTimer = time;
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
        if (faceDirection < 0) faceDirection += 4;
		faceDirection = faceDirection % 4;
	}

	public function alert():Void 
    {

	}

    public function getBody():Body
    {
        return _body;
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
		
		visionAngle = faceDirection * Math.PI / 2;

        switch(faceDirection)
        {
            case 0:
                _eyeRef.x = 60;
                _eyeRef.y = 27;
            case 1:
                _eyeRef.x = 27;
                _eyeRef.y = 60;
            case 2:
                _eyeRef.x = -6;
                _eyeRef.y = 27;
            case 3:
                _eyeRef.x = 27;
                _eyeRef.y = -6;
        }
		eye.x = _body.position.x + _eyeRef.x;
		eye.y = _body.position.y + _eyeRef.y;
    }

	override public function draw():Void 
    {
        x = _body.position.x;
        y = _body.position.y;
        super.draw();
    }
	
}
