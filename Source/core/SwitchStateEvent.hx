package core;

import openfl.events.Event;

class SwitchStateEvent extends Event
{
    public var state:State;

    public static var SWITCH_STATE:String = "switchstate";

    public function new(name:String, s:State)
    {
        super(name, true, false);
        this.state = s;
    }
}
