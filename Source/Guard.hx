import core.Element;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;

import core.AnimatedSprite;

/**
 * ...
 * @author Chambers
 */
class Guard extends Element {

    public var behaviorType:Int; // 0 = noWait, 1 = Wait, 2 = LookAround

    private var _flagManager:FlagManager;

    private var _path:Path;
    public var speed:Float = 100;

    public var waitingTimer:Float;
    public var rotateTimer:Float;
    public var attentionTimer:Float = 0;

    public var faceDirection:Int = 0;

    //public var exclamation:Exclamation;

    public var eye:Point; //coordenadas do olho do guarda

    private var _anim:AnimatedSprite;
	private var _animAlert:AnimatedSprite;

    private var _body:Body;
    private var BODY_WIDTH:Int = 30;
    private var BODY_HEIGHT:Int = 20;

    private var WAITING_TIME:Int = 2;
    private var INSPECTING_TIME:Int = 1;
    private var DIZZY_TIME:Int = 10;
    private var ATTENTION_TIME:Int = 2;

    public function new(b:Int, r:Array<Point>) {
        super ();

        behaviorType = b;
        _path = new Path(r, speed);
        _path.setBackForth(true);
        if(behaviorType == 0)
        {
            _path.setWalkOnNode(true);
        }
        else
        {
            _path.setWalkOnNode(false);
            _path.addEventListener(PathEvent.NODE_ARRIVED, function (e)
            {
                switch (behaviorType) {
                    case 0:
                        _flagManager.reset("walking");
                        _flagManager.set("walking");
                    case 1:
                        _flagManager.reset("walking");
                        _flagManager.set("waiting");
                    case 2:
                        _flagManager.reset("walking");
                        _flagManager.set("waiting");
                        _flagManager.set("inspecting");
                }
            });
        }

        _body = new Body(BODY_WIDTH, BODY_HEIGHT);
        _body.position.x = _path.getX();
        _body.position.y = _path.getY();

        _anim = new AnimatedSprite("assets/animations.json", "guard");
        _anim.setAnimation("idle-" + animationDirection);
        addElement(_anim);
	
		_animAlert = new AnimatedSprite("assets/animations.json", "alert");
		_animAlert.visible = false;
        _animAlert.setAnimation("question");
        addElement(_animAlert);


        eye = new Point();

        _flagManager = new FlagManager();
        _flagManager.add("waiting",
                function (dt) {
                    waitingTimer -= dt;
                    if (waitingTimer <= 0) {
                        _flagManager.reset("waiting");
                        _flagManager.reset("inspecting");
                        _flagManager.set("walking");
                    }
                },
                function () {
                    _anim.setAnimation("idle-" + animationDirection);
                    waitingTimer = WAITING_TIME;
                },
                null
                );

        _flagManager.add("walking",
                function (dt) {
                    _path.update(dt);
                    _body.position.x = _path.getX();
                    _body.position.y = _path.getY();

                    var dir:Int = (Math.floor((_path.getAngle() + Math.PI / 4) / (Math.PI / 2)) + 4) % 4;
                    if(dir != faceDirection)
                    {
                        faceDirection = dir;
                        _anim.setAnimation("walk-" + animationDirection);
                    }
                },
                function () {
                    _path.resume();
                    _anim.setAnimation("walk-" + animationDirection);
                },
                function () {
                    _body.speed.x = _body.speed.y = 0;
                }
                );

        _flagManager.add("inspecting",
                function (dt) {
                    rotateTimer -= dt;
                    if (rotateTimer <= 0) 
                    {
                        faceDirection = (4 + faceDirection + ((Math.random() > 0.5) ? -1 : 1)) % 4;
                        _anim.setAnimation("idle-" + animationDirection);
                        rotateTimer = INSPECTING_TIME;
                    }
                },
                function () {
                    rotateTimer = INSPECTING_TIME;
                    _anim.setAnimation("idle-" + animationDirection);
                }
                );

        _flagManager.add("falling",
                function (dt) {
                    if (_anim.isOver())
                    {
                        _flagManager.reset("falling");
                        _flagManager.set("dizzy");
                    }
                },
                function () {
                    _anim.setAnimation("fall-" + animationDirection);
                }
                );

        _flagManager.add("dizzy", 
                function (dt)
                {
                    waitingTimer -= dt;
                    if (waitingTimer <= 0)
                    {
                        _flagManager.reset("dizzy");
                        _flagManager.set("gettingUp");

                    }
                },
                function ()
                {
                    waitingTimer = DIZZY_TIME;
                }
                );

        _flagManager.add("gettingUp", 
                function (dt)
                {
                    if(_anim.isOver())
                    {
                        _flagManager.reset("gettingUp");
                        _flagManager.set("walking");
                    }
                },
                function () 
                {
                    _anim.setAnimation("getup-" + animationDirection);
                }
                );

        _flagManager.add("alert",
                function (dt)
                {
                    attentionTimer -= dt;
                    if (attentionTimer <= 0)
                    {
                        _flagManager.reset("alert");
                        _flagManager.set("walking");
			            _animAlert.visible = false;
                    }
                    else if (attentionTimer <= ATTENTION_TIME - 0.5)
                    {
                        _animAlert.setAnimation("question");
                    }
                    else
                    {
                        _animAlert.visible = false;
                    }
                },
                function ()
                {
                    _anim.setAnimation("idle-" + animationDirection);

			        _animAlert.visible = true;
			        _animAlert.setAnimation("exclamation");
                    attentionTimer = ATTENTION_TIME;
                }
                );

        _flagManager.set("walking");
    }

    public function interrupt():Void
    {
        if (_flagManager.isFlagSet("walking")) {
            _flagManager.reset("walking");
            _flagManager.set("falling");
        }
    }

    public function isInterrupted():Bool
    {
        return (_flagManager.isFlagSet("falling") ||
                _flagManager.isFlagSet("dizzy") ||
                _flagManager.isFlagSet("gettingUp"));
    }

    public function alert():Void 
    {
        _flagManager.reset("waiting");
        _flagManager.reset("walking");
        _flagManager.reset("inspecting");
        _flagManager.reset("alert");
        _flagManager.set("alert");
    }

    public function getBody():Body
    {
        return _body;
    }

    public function isFacing(direction:Float):Bool
    {
        return (direction >= faceDirection * Math.PI / 2 - Math.PI / 4 && 
                direction <= faceDirection * Math.PI / 2 + Math.PI / 4);
    }

    override public function update(dt:Float):Void 
    {
        _flagManager.update(dt);
        _body.update(dt);
        super.update(dt);
        eye.x = _body.position.x;
        eye.y = _body.position.y;
    }

    override public function draw():Void 
    {
        x = _body.position.x;
        y = _body.position.y;

        super.draw();

        #if debug
        graphics.clear();
        //Body
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, _body.width, _body.height);
        graphics.endFill();
        //Eye
        graphics.beginFill(0xFFFF00);
        graphics.drawCircle(eye.x - x, eye.y - y, 5);
        graphics.endFill();
        //Range
        graphics.lineStyle(1, 0x00FF00);
        graphics.moveTo(eye.x - x, eye.y - y);
        graphics.lineTo(eye.x - x + 300 * Math.cos(faceDirection * Math.PI / 2),
                            eye.y - y + 300 * Math.sin(faceDirection * Math.PI / 2));
        graphics.moveTo(eye.x - x, eye.y - y);
        graphics.lineTo(
                eye.x - x + 300 * Math.cos(faceDirection * Math.PI / 2 - Math.PI / 4),
                eye.y - y + 300 * Math.sin(faceDirection * Math.PI / 2 - Math.PI / 4));
        graphics.moveTo(eye.x - x, eye.y - y);
        graphics.lineTo(
                eye.x - x + 300 * Math.cos(faceDirection * Math.PI / 2 + Math.PI / 4),
                eye.y - y + 300 * Math.sin(faceDirection * Math.PI / 2 + Math.PI / 4));
        graphics.drawCircle(eye.x - x, eye.y - y, 300);
        #end
    }

    private var animationDirection(get,null):String;
    private function get_animationDirection():String
    {
        switch(faceDirection)
        {
            case 0:
                return "right";
            case 1:
                return "down";
            case 2:
                return "left";
            case 3:
                return "up";
            default:
                trace("INVALID FACING DIRECTION");
                return "none";
        }
    } 
}
