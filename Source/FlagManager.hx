import haxe.ds.StringMap;

private class Flag
{
    public var setRaw:Bool = false;
    public var set:Bool = false;
    public var update:Float->Void;
    public var onEnter:Void->Void;
    public var onLeave:Void->Void;

    public function new(update:Float->Void, onEnter:Void->Void,
            onLeave:Void->Void)
    {
        this.update = update;
        this.onEnter = onEnter;
        this.onLeave = onLeave;
    }
}

class FlagManager {

    private var _flagList:StringMap<Flag>;

    private var DEFAULT_UPDATE:Float->Void = function(f:Float):Void {};
    private var DEFAULT_ON_ENTER:Void->Void = function():Void {};
    private var DEFAULT_ON_LEAVE:Void->Void = function():Void {};

    public function new()
    {
        _flagList = new StringMap<Flag>();
    }

    public function add(name:String, update:Float->Void = null,
            onEnter:Void->Void = null, onLeave:Void->Void = null):Bool
    {
        if(update == null)
            update = DEFAULT_UPDATE;
        if(onEnter == null)
            onEnter = DEFAULT_ON_ENTER;
        if(onLeave == null)
            onLeave = DEFAULT_ON_LEAVE;

        if (!_flagList.exists(name))
        {
            _flagList.set(name, new Flag(update, onEnter, onLeave));
            return true;
        }
        return false;
    }

    public function set(name:String):Void
    {
        _flagList.get(name).setRaw = true;
        _flagList.get(name).onEnter();
    }

    public function reset(name:String):Void
    {
        _flagList.get(name).setRaw = false;
        _flagList.get(name).onLeave();
    }

    public function isFlagSet(name:String):Bool
    {
        return _flagList.get(name).setRaw;
    }

    public function update(dt:Float):Void
    {
        for(flag in _flagList)
        {
            flag.set = flag.setRaw;

            if(flag.set)
                flag.update(dt);
        }
    }
}
