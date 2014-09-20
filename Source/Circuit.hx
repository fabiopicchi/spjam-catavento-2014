package  ;

import core.Element;
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
	public var currentTargetId:Int = 0;
	public var target:Point;
	
    private var _path:Path;
	public var speed:Float = 400;
	public var angle:Float = 0;
	
	public function new(id:Int, r:Array<Point>) {
        this.id = id;
		super ();
		
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, 10, 10);
        visible = false;
		
        _path = new Path(r, speed);
        _path.setBackForth(false);
        _path.setWalkOnNode(true);
        _path.addEventListener(PathEvent.PATH_ENDED, function (e)
        {
            dispatchEvent(new CircuitEvent(CircuitEvent.DEACTIVATE, id));
            active = false;
            visible = false;
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
        visible = true;
	}
	
	public function reset():Void 
    {
        _path.reset();
        x = _path.getX();
        y = _path.getY();
        visible = true;
		active = false;
	}
}
