package;

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
	
	private var image:Bitmap;
	
	public function new() {
		super ();
	}
	
	public function update(dt:Float):Void 
    {
        super.update(dt);
    }
}