package  ;

import openfl.events.Event;

/**
 * ...
 * @author Chambers
 */
class CircuitEvent extends Event {
	
	var objectId:Int;

    public static var OFF:String = "off";
	
	public function new(name:String, objectId:Int) {
		super (name, true, false);
		this.objectId = objectId;
	}
	
}
