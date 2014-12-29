package  ;

import openfl.events.Event;

/**
 * ...
 * @author Chambers
 */
class PathEvent extends Event {
	
    public static var NODE_ARRIVED:String = "node_arrive";
    public static var PATH_ENDED:String = "path_ended";
	
	public function new(name:String) {
		super (name, true, false);
	}
	
}
