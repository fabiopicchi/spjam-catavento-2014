import openfl.geom.Point;

class Body {

    public var position:Point;
    public var lastPosition:Point;
    public var speed:Point;
    public var width:Float;
    public var height:Float;
    
    private var _delta:Point;
    private var _entry:Point;
    private var _entryDistance:Point;

    public function new(width:Float, height:Float)
    {
        this.width = width;
        this.height = height;

        position = new Point();
        lastPosition = new Point();
        speed = new Point();

        _delta = new Point();
        _entry = new Point();
        _entryDistance = new Point();
    }

    public function update(dt:Float)
    {
        lastPosition.x = position.x;
        lastPosition.y = position.y;

        position.x = position.x + speed.x * dt;
        position.y = position.y + speed.y * dt;
    }

    public function overlapBody(b : Body):Bool
    {
        return (position.x < b.position.x + b.width &&
                position.x + width > b.position.x &&
                position.y < b.position.y + b.height &&
                position.y + height > b.position.y);
    }

    public function collideBody(b : Body):Bool
    {
        if(overlapBody(b))
        {
            _delta.x = (position.x - lastPosition.x) - (b.position.x -
                    b.lastPosition.x);
            _delta.y = (position.y - lastPosition.y) - (b.position.y -
                    b.lastPosition.y);

            if (_delta.x != 0)
            {
                if (_delta.x > 0)
                {
                    _entryDistance.x = b.lastPosition.x - lastPosition.x -
                        width;
                }
                else
                {
                    _entryDistance.x = b.lastPosition.x + b.width -
                        lastPosition.x;
                }
                _entry.x = _entryDistance.x / _delta.x;
            }
            else
            {
                _entry.x = Math.NEGATIVE_INFINITY;
            }

            if (_delta.y != 0)
            {
                if (_delta.y > 0)
                {
                    _entryDistance.y = b.lastPosition.y - lastPosition.y -
                        height;
                }
                else
                {
                    _entryDistance.y = b.lastPosition.y + b.height -
                        lastPosition.y;
                }
                _entry.y = _entryDistance.y / _delta.y;
            }
            else
            {
                _entry.y = Math.NEGATIVE_INFINITY;
            }

            var entryTime:Float = Math.max(_entry.x, _entry.y);

            if (entryTime >= 0 && entryTime <= 1)
            {
                position.x = lastPosition.x + (position.x - lastPosition.x) *
                    entryTime;
                position.y = lastPosition.y + (position.y - lastPosition.y) *
                    entryTime;

                if (entryTime == _entry.x)
                {
                    b.speed.x = 0;
                    speed.x = 0;
                    b.position.x = b.lastPosition.x + 
                        (b.position.x - b.lastPosition.x) * entryTime;
                    b.position.y = b.lastPosition.y + 
                        (b.position.y - b.lastPosition.y);
                }
                else
                {
                    b.speed.y = 0;
                    speed.y = 0;
                    b.position.x = b.lastPosition.x + 
                        (b.position.x - b.lastPosition.x);
                    b.position.y = b.lastPosition.y + 
                        (b.position.y - b.lastPosition.y) * entryTime;
                }
                return true;
            }
        }
        return false;
    }

    public function inRange(x:Float, y:Float, range:Float):Bool
    {
        return ((this.position.x + this.width / 2 - x) * 
                (this.position.x + this.width / 2 - x) + 
                (this.position.y + this.height / 2 - y) * 
                (this.position.y + this.height / 2 - y) <= range * range);
    }
}
