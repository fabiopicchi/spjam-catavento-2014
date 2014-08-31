package  ;

import openfl.events.Event;

/**
 * ...
 * @author Chambers
 */
class CircuitEvent extends Event {
	
	var objectId:Int;
	var step:Int;
	
	public function new(name:String, objectId:Int, step:Int) {
		super (name, true, false);
		this.objectId = objectId;
		this.step = step;
	}
	
}