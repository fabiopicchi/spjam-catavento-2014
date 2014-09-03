import core.Element;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;

import core.SpriteSheet;

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
	
	public var eye:Point; //coordenadas do olho do guarda
	public var visionAngle:Float = 0; //direção da visão do guarda
	public var visionWidth:Float = Math.PI / 6;	//delta máximo para enxergar o herói
    private var _body:Body;
	
	//public var exclamation:Exclamation;

    private var _eyeRef:Shape;
    private var interrupted:Bool;

    private var anim_x:Float;
    private var anim_y:Float;
	private var FRAME_WIDTH:Int = 112;
    private var FRAME_HEIGHT:Int = 120;
	
	private var BODY_WIDTH:Int = 30;
	private var BODY_HEIGHT:Int = 20;
	
    private var _ss:SpriteSheet;
	
	public function new(b:Int, r:Array<Point>) {
		super ();

        interrupted = false;
		
        behaviorType = b;
		route = r;

        _body = new Body(BODY_WIDTH, BODY_HEIGHT);
        _body.position.x = route[0].x;
        _body.position.y = route[0].y;
		
		//exclamation = new Exclamation ();
		//addChild (exclamation);
		
		anim_x = (BODY_WIDTH - FRAME_WIDTH) / 2;
		anim_y = BODY_HEIGHT - FRAME_HEIGHT;

        _ss = new SpriteSheet("assets/guard.png", FRAME_WIDTH, FRAME_HEIGHT);
        _ss.loadAnimationsFromJSON("assets/ss_guard.json");
		_ss.x = anim_x;
		_ss.y = anim_y;
        addElement(_ss);
		
        _eyeRef = new Shape();
        //_eyeRef.graphics.beginFill(0x00FF00);
        //_eyeRef.graphics.drawRect(0, 0, 6, 6);
        addChild(_eyeRef);
		
		eye = new Point();
		
		goingBack = false;
		loadNextStep();

        switch(faceDirection)
        {
            case 0:
                _ss.setAnimation("idle-side");
                _ss.scaleX = -1;
                //_ss.x = -_ss.width;
            case 1:
                _ss.setAnimation("idle-front");
                _ss.scaleX = 1;
                //_ss.x = 0;
            case 2:
                _ss.setAnimation("idle-side");
                _ss.scaleX = 1;
                //_ss.x = 0;
            case 3:
                _ss.setAnimation("idle-back");
                _ss.scaleX = 1;
                //_ss.x = 0;
        }
	}

	public function loadNextStep():Void
	{
		if (!goingBack) {
			currentTargetId++;
			if (currentTargetId == route.length - 1) {
				goingBack = true;
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
		faceDirection = Math.floor( (angle + Math.PI/4) / (Math.PI / 2));
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

        setGuardAnimation("walk");
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

        if (!interrupted)
        {
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
        else
        {
            if (waitingTimer <= 0)
            {
                interrupted = false;
                loadNextStep();
            }
        }

        setGuardAnimation ("idle");

    }

    public function interrupt():Void
    {
        waitingTimer = 10;
        interrupted = true;
        state = 0;
    }

    public function isInterrupted():Bool
    {
        return interrupted;
    }

    public function rotate():Void 
    {
        faceDirection += (Math.random() > 0.5) ? -1 : 1;
        if (faceDirection < 0) faceDirection += 4;
        faceDirection = faceDirection % 4;
    }

    public function alert():Void 
    {
		attention = 1;
	}

    public function getBody():Body
    {
        return _body;
    }

    override public function update(dt:Float):Void 
    {
        super.update(dt);
		
		if (attention > 0) {
			attention -=(dt);
		}
		else {			
			if (state == 0) {
				wait(dt);
			}
			else if (state == 1) {
				walk(dt);
			}
		}
		
		visionAngle = faceDirection * Math.PI / 2;

        /*
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
		*/
		_eyeRef.x = _body.width/2;
        _eyeRef.y = _body.height/2;
        eye.x = _body.position.x + _eyeRef.x;
        eye.y = _body.position.y + _eyeRef.y;
    }

    override public function draw():Void 
    {
        x = _body.position.x;
        y = _body.position.y;
        super.draw();
    }
	
	private function setGuardAnimation(animName:String):Void
	{
		
		if (animName == "walk")
		{
			switch(faceDirection)
			{
				case 0:
					_ss.setAnimation("walk-side");
					_ss.scaleX = -1;
					_ss.x = anim_x + _ss.width;
				case 1:
					_ss.setAnimation("walk-front");
					_ss.scaleX = 1;
					_ss.x = anim_x;
				case 2:
					_ss.setAnimation("walk-side");
					_ss.scaleX = 1;
					_ss.x = anim_x;
				case 3:
					_ss.setAnimation("walk-back");
					_ss.scaleX = 1;
					_ss.x = anim_x;
			}
		}
		if (animName == "idle")
		{
			switch(faceDirection)
			{
				case 0:
					_ss.setAnimation("idle-side");
					_ss.scaleX = -1;
					_ss.x = anim_x +_ss.width;
				case 1:
					_ss.setAnimation("idle-front");
					_ss.scaleX = 1;
					_ss.x = anim_x;
				case 2:
					_ss.setAnimation("idle-side");
					_ss.scaleX = 1;
					_ss.x = anim_x;
				case 3:
					_ss.setAnimation("idle-back");
					_ss.scaleX = 1;
					_ss.x = anim_x;
			}
		}
	}

}
