package  ;

import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.events.Event;

/**
 * ...
 * @author Chambers
 */
class Guard extends Element {
	
	public var attention:Float = 0;
	public var direction:Int = 0;
	public var visionAngle:Float = 0;
	public var visionWidth:Float = Math.PI/3;
		
	private var image:Bitmap;
	
	public function new() {
		super ();
	}
	
	public function update(dt:Float):Void 
    {
        super.update(dt);
    }
	
	public function draw():Void 
    {
        super.draw();
    }
}