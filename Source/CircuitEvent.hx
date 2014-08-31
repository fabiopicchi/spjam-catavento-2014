package  ;

import openfl.events.Event;

/**
 * ...
 * @author Chambers
 */
class CircuitEvent extends Event {
	
	public var id:Int;

    public static var REACTIVATE:String = "reactivate";
    public static var DEACTIVATE:String = "deactivate";
	
	public function new(name:String, id:Int) {
		super (name, true, false);
		this.id = id;
	}
	
}
