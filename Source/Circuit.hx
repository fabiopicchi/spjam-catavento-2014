package;

import core.Element;
import core.AnimatedSprite;
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
	
	private var _anim:AnimatedSprite;
	private var FRAME_WIDTH:Int = 90;
    private var FRAME_HEIGHT:Int = 90;
	
    private var _path:Path;
	public var speed:Float = 400;
	
	public function new(id:Int, r:Array<Point>) {
        this.id = id;
		super ();

		_anim = new AnimatedSprite("assets/animations.json", "spark");
		_anim.setAnimation("idle-wire");
		_anim.scaleX = 0.3;
		_anim.scaleY = 0.3;
		_anim.visible = false;
		addElement(_anim);
		
        _path = new Path(r, speed);
        _path.setBackForth(false);
        _path.setWalkOnNode(true);
        _path.addEventListener(PathEvent.PATH_ENDED, function (e)
        {
            dispatchEvent(new CircuitEvent(CircuitEvent.DEACTIVATE, id));
            active = false;
            _anim.visible = false;
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

    override public function draw():Void
    {
        #if debug
        graphics.clear();
        graphics.beginFill(0xFF0000);
        graphics.drawRect(_anim.x, _anim.y, _anim.width, _anim.height);
        graphics.endFill();
        #end
    }
	
	public function activate():Void 
	{
        reset();
		active = true;
        _anim.visible = true;
	}
	
	public function reset():Void 
    {
        _path.reset();
        x = _path.getX();
        y = _path.getY();
		active = false;
		_anim.visible = false;
	}
}
