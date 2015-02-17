package;

import core.Element;
import core.SpriteSheet;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author Chambers
 */
class Circuit extends Element {
	
	public var id:Int;
	public var active:Bool;
	
	private var _ss:SpriteSheet;
	private var FRAME_WIDTH:Int = 90;
    private var FRAME_HEIGHT:Int = 90;
	
    private var _path:Path;
	public var speed:Float = 400;
	
	public function new(id:Int, r:Array<Point>) {
        this.id = id;
		super ();
		
		_ss = new SpriteSheet("assets/spark.png", FRAME_WIDTH, FRAME_HEIGHT);
        _ss.loadAnimationsFromJSON("assets/ss_spark.json");
		_ss.setAnimation("idle");
		//_ss.x = - FRAME_WIDTH / 2;
		//_ss.y = - FRAME_HEIGHT / 2;
		_ss.scaleX = 0.3;
		_ss.scaleY = 0.3;
		_ss.visible = false;
		addElement(_ss);
		
        _path = new Path(r, speed);
        _path.setBackForth(false);
        _path.setWalkOnNode(true);
        _path.addEventListener(PathEvent.PATH_ENDED, function (e)
        {
            dispatchEvent(new CircuitEvent(CircuitEvent.DEACTIVATE, id));
            active = false;
            _ss.visible = false;
        });

		
		reset();
	}
	
	override public function update(dt:Float):Void 
    {
        super.update(dt);
        if (active)
        {
            _path.update(dt);
            x = _path.getX();
            y = _path.getY();
        }
    }
	
	public function activate():Void 
	{
        reset();
		active = true;
        _ss.visible = true;
	}
	
	public function reset():Void 
    {
        _path.reset();
        x = _path.getX();
        y = _path.getY();
		active = false;
		_ss.visible = false;
	}
}
