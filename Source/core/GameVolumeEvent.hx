package core;

import openfl.events.Event;

class GameVolumeEvent extends Event
{
    public var volume:Float;

    public static var BG_MUSIC:String = "bgmusic";
    public static var SFX:String = "sfx";

    public function new(name:String, volume:Float)
    {
        super(name, true, false);
        this.volume = volume;
    }
}
