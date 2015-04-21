package  ;

import core.Element;
import core.AnimatedSprite;
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
	
	public var id:Int;

    private var _flagManager:FlagManager;
	
	private var _anim:AnimatedSprite;
	private var _animSpark:AnimatedSprite;
	private var _animAlert:AnimatedSprite;
    private var _light:Bitmap;
	
	public static var BLUE:String = "blue";
    public static var GREEN:String = "green";
    public static var RED:String = "red";

	private var ANGULAR_SPEED:Float = 0.5;
    private var ATTENTION_TIME:Int = 2;
	
	public var active(get, null):Bool;
	public var initialAngle:Float;
	public var angle:Float = 0;
	public var deltaMax:Float = 0.3;
    public var angularSpeed:Float = 0;
	public var animPos:Float = 0;
	public var goingBack:Bool;
	public var waitingTime:Float;
	public var attentionTimer:Float = 0;
	
	public var eye:Point;
	
	public function new(x:Float, y:Float, color:String, id:Int) {
        this.id = id;
		super ();
		
		this.x = x;
		this.y = y;
		
		eye = new Point();
		initialAngle = 1;
		angle = 1;
		goingBack = false;
        angularSpeed = -ANGULAR_SPEED;
		
		_anim = new AnimatedSprite("assets/animations.json", "camera") ;
		addElement(_anim);
	
		_animAlert = new AnimatedSprite("assets/animations.json", "camera-alert");
        _animAlert.setAnimation("question");
        _animAlert.visible = false;
        _animAlert.x = 25;
        _animAlert.y = -30;
        addElement(_animAlert);

		_animSpark = new AnimatedSprite("assets/animations.json", "spark");
		_animSpark.setAnimation("idle");
		_animSpark.visible = false;
		addElement(_animSpark);

		eye.x = x + 30;
		eye.y = y + 40 * 2 + 3;

        _flagManager = new FlagManager();
        _flagManager.add("seeking", 
            function(dt) {
                angle += angularSpeed * dt;
                if(angle > initialAngle + deltaMax || angle < initialAngle - deltaMax)
                {
                    _flagManager.reset("seeking");
                    _flagManager.set("waiting");
                }
            });

        _flagManager.add("waiting",
            function(dt) {
			    waitingTime -= dt;
                if(waitingTime <= 0)
                {
                    _flagManager.reset("waiting");
                    _flagManager.set("seeking");
                }
            },
            function() {
                if(!goingBack)
                {
                    angle = initialAngle - deltaMax;
                }
                else
                {
                    angle = initialAngle + deltaMax;
                }
                goingBack = !goingBack;
                angularSpeed = -angularSpeed;
                waitingTime = 1;
   
            },
            function() {
                waitingTime = 0;
            });

        _flagManager.add("broken",
            null,
            function(){
                _flagManager.reset("alert");
                _flagManager.reset("seeking");
                _flagManager.reset("waiting");
                _animSpark.visible = true;
                _animAlert.visible = false;
            },
            function(){
                _animSpark.visible = false;
                _flagManager.set("seeking");
            }
        );

        _flagManager.add("alert",
            function (dt)
            {
                attentionTimer -= dt;
                if(attentionTimer <= 0)
                {
                    _flagManager.reset("alert");
                }
                else if (attentionTimer <= 0.75 * ATTENTION_TIME)
                {
                    _animAlert.setAnimation("question");
                }
            },
            function ()
            {
                _flagManager.reset("seeking");
                _flagManager.reset("waiting");
                _animAlert.visible = true;
                _animAlert.setAnimation("exclamation");
                attentionTimer = ATTENTION_TIME;
            },
            function ()
            {
                _animAlert.visible = false;
                _flagManager.set("seeking");
            });
        _flagManager.set("seeking");
	}
	
	override public function update(dt:Float):Void 
    {
        _flagManager.update(dt);
        super.update(dt);
    }

    override public function draw():Void 
    {
        super.draw();

        animPos = Math.abs(Math.floor((angle - 0.7) / (2 * deltaMax) * 6.99) - 6);
        _anim.setAnimation("a" + animPos);

        #if debug
        graphics.clear();
        graphics.beginFill(0xFF0000);
        graphics.drawCircle(eye.x - x, eye.y - y, 5);
        graphics.endFill();
        graphics.lineStyle(1, 0x00FF00);
        graphics.moveTo(eye.x - x, eye.y - y);
        graphics.lineTo(eye.x - x + 300 * Math.cos(angle * Math.PI / 2),
                            eye.y - y + 300 * Math.sin(angle * Math.PI / 2));
        graphics.moveTo(eye.x - x, eye.y - y);
        graphics.lineTo(
                eye.x - x + 300 * Math.cos(angle * Math.PI / 2 - Math.PI / 4),
                eye.y - y + 300 * Math.sin(angle * Math.PI / 2 - Math.PI / 4));
        graphics.moveTo(eye.x - x, eye.y - y);
        graphics.lineTo(
                eye.x - x + 300 * Math.cos(angle * Math.PI / 2 + Math.PI / 4),
                eye.y - y + 300 * Math.sin(angle * Math.PI / 2 + Math.PI / 4));
        graphics.drawCircle(eye.x - x, eye.y - y, 300);
        #end
    }

    public function focusOnHero(p:Point):Void {

    }

    public function activate():Void {
        _flagManager.reset("broken");
    }

    public function deactivate():Void {
        _flagManager.set("broken");
    }

	public function alert():Void 
    {
        _flagManager.set("alert");
	}

    private function get_active():Bool
    {
        return !_flagManager.isFlagSet("broken");
    }
}
