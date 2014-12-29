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

    private var _flagManager:FlagManager;

    private var _path:Path;
    public var speed:Float = 100;

    public var waitingTimer:Float;
    public var rotateTimer:Float;
    public var attentionTimer:Float = 0;

    public var faceDirection:Int = 0;

    //public var exclamation:Exclamation;

    public var eye:Point; //coordenadas do olho do guarda

    private var _ss:SpriteSheet;
    private var anim_x:Float;
    private var anim_y:Float;
    private var FRAME_WIDTH:Int = 112;
    private var FRAME_HEIGHT:Int = 120;

    private var _body:Body;
    private var BODY_WIDTH:Int = 30;
    private var BODY_HEIGHT:Int = 20;

    private var WAITING_TIME:Int = 2;
    private var INSPECTING_TIME:Int = 1;
    private var DIZZY_TIME:Int = 10;
    private var ATTENTION_TIME:Int = 1;

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

        anim_x = (BODY_WIDTH - FRAME_WIDTH) / 2;
        anim_y = BODY_HEIGHT - FRAME_HEIGHT;

        _ss = new SpriteSheet("assets/guard.png", FRAME_WIDTH, FRAME_HEIGHT);
        _ss.loadAnimationsFromJSON("assets/ss_guard.json");
        _ss.x = anim_x;
        _ss.y = anim_y;
        addElement(_ss);

        setGuardAnimation("idle");

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
                    setGuardAnimation("idle");
                    waitingTimer = WAITING_TIME;
                },
                null
                );

        _flagManager.add("walking",
                function (dt) {
                    _path.update(dt);
                    _body.position.x = _path.getX();
                    _body.position.y = _path.getY();
                },
                function () {
                    _path.resume();
                    faceDirection = Math.floor((_path.getAngle() + Math.PI / 4) / (Math.PI / 2));
                    if (faceDirection > 3) faceDirection -= 4;
                    else if (faceDirection < 0) faceDirection += 4;
                    setGuardAnimation("walk");
                },
                function () {
                    _body.speed.x = _body.speed.y = 0;
                }
                );

        _flagManager.add("inspecting",
                function (dt) {
                    rotateTimer -= dt;
                    if (rotateTimer <= 0) {
                        faceDirection += (Math.random() > 0.5) ? -1 : 1;
                        if (faceDirection > 3) faceDirection -= 4;
                        else if (faceDirection < 0) faceDirection += 4;
                        setGuardAnimation("idle");
                        rotateTimer = INSPECTING_TIME;
                    }
                },
                function () {
                    rotateTimer = INSPECTING_TIME;
                    setGuardAnimation("idle");
                }
                );

        _flagManager.add("falling",
                function (dt) {
                    if (_ss.isOver())
                    {
                        _flagManager.reset("falling");
                        _flagManager.set("dizzy");
                    }
                },
                function () {
                    setGuardAnimation("fall");
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
                    if(_ss.isOver())
                    {
                        _flagManager.reset("gettingUp");
                        _flagManager.set("walking");
                    }
                },
                function () 
                {
                    setGuardAnimation("getup");
                }
                );

        _flagManager.add("alert",
                function (dt)
                {
                    attentionTimer -=dt;
                    if (attentionTimer <= 0)
                    {
                        _flagManager.reset("alert");
                        _flagManager.set("walking");
                    }
                },
                function ()
                {
                    setGuardAnimation("idle");
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
        graphics.beginFill(0xFF0000);
        graphics.drawCircle(eye.x - x, eye.y - y, 5);
        graphics.endFill();
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

    private function setGuardAnimation(animName:String):Void
    {
        if (animName == "walk" || animName == "idle")
        {
            switch(faceDirection)
            {
                case 0:
                    _ss.setAnimation(animName + "-side");
                    _ss.scaleX = -1;
                    _ss.x = anim_x + _ss.width;
                case 1:
                    _ss.setAnimation(animName + "-front");
                    _ss.scaleX = 1;
                    _ss.x = anim_x;
                case 2:
                    _ss.setAnimation(animName + "-side");
                    _ss.scaleX = 1;
                    _ss.x = anim_x;
                case 3:
                    _ss.setAnimation(animName + "-back");
                    _ss.scaleX = 1;
                    _ss.x = anim_x;
            }
        }

        else if (animName == "fall" || animName == "getup")
        {
            _ss.setAnimation(animName);
            switch(faceDirection)
            {
                case 0, 1:
                    _ss.scaleX = -1;
                    _ss.x = anim_x +_ss.width;
                case 2, 3:
                    _ss.scaleX = 1;
                    _ss.x = anim_x;
            }
        }
    }
}
