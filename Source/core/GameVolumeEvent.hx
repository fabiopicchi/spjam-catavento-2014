package core;

import openfl.events.Event;

class GameVolumeEvent extends Event
{
    public var volume:Float;

    public static var BG_MUSIC:String = "volumebgmusic";
    public static var SFX:String = "volumesfx";

    public function new(name:String, volume:Float)
    {
        super(name, true, false);
        this.volume = volume;
    }
}
