package;

import openfl.geom.Point;
import openfl.events.EventDispatcher;

class Path extends EventDispatcher {

    private var _walkOnNode:Bool = true;
    private var _backForth:Bool = true;
    private var _nodes:Array<Point>;
    private var _x:Float;
    private var _y:Float;
    private var _speed:Float;
    private var _vx:Float;
    private var _vy:Float;
    private var _angle:Float;
    private var _ascending:Bool;
    private var _currentNodeIndex:Int;
    private var _nextNodeIndex:Int;
    private var _stop:Bool;

    public function new (r:Array<Point>, speed:Float) {
        super();
        _ascending = true;
        _stop = false;
        _nodes = r;
        _speed = speed;
        _x = _nodes[0].x;
        _y = _nodes[0].y;
        _currentNodeIndex = 0;
        _nextNodeIndex = 1;
        setDirection();
    }

    private function setNextNode () {

        if (_ascending)
        {
            _currentNodeIndex++;
            if (_currentNodeIndex == (_nodes.length - 1))
            {
                if (_backForth)
                {
                    _nextNodeIndex = _currentNodeIndex - 1;
                    _ascending = false;
                }
                else
                {
                    dispatchEvent(new PathEvent(PathEvent.PATH_ENDED));
                }
            }
            else
            {
                _nextNodeIndex++;
            }
        }
        else
        {
            _currentNodeIndex--;
            if (_currentNodeIndex == 0)
            {
                if (_backForth)
                {
                    _nextNodeIndex = _currentNodeIndex + 1;
                    _ascending = true;
                }
                else
                {
                    dispatchEvent(new PathEvent(PathEvent.PATH_ENDED));
                }
            }
            else
            {
                _nextNodeIndex--;
            }
        }
    }

    private function setDirection () {
        var currentNode:Point = _nodes[_currentNodeIndex];
        var nextNode:Point = _nodes[_nextNodeIndex];
        _angle = Math.atan2(nextNode.y - currentNode.y, 
                    nextNode.x - currentNode.x);
        if (_angle < 0) _angle += 2 * Math.PI;
        _vx = Math.cos(_angle) * _speed;
        _vy = Math.sin(_angle) * _speed;
    }

    public function update(dt:Float) {
        if (!_stop)
        {
            var dx = _vx * dt;
            var dy = _vy * dt;

            var distX = _nodes[_nextNodeIndex].x - _x;
            var distY = _nodes[_nextNodeIndex].y - _y;

            if (Math.abs(distX) <= Math.abs(dx) && 
                    Math.abs(distY) <= Math.abs(dy))
            {
                dx = distX;
                dy = distY;
                if (!_walkOnNode) {
                    _stop = true;
                }
                else {
                    setNextNode();
                    setDirection();
                }
				dispatchEvent(new PathEvent(PathEvent.NODE_ARRIVED));
            }

            _x += dx;
            _y += dy;
        }
    }

    public function resume () {
        if (_stop)
        {
            setNextNode();
            setDirection();
            _stop = false;
        }
    }

    public function reset () {
        _ascending = true;
        _x = _nodes[0].x;
        _y = _nodes[0].y;
        _currentNodeIndex = 0;
        _nextNodeIndex = 1;
        setDirection();
    }

    public function getX():Float {
        return _x;
    }

    public function getY():Float {
        return _y;
    }

    public function getSpeed():Float {
        return _speed;
    }

    public function getAngle():Float {
        return _angle;
    }

    public function setSpeed(s:Float) {
        _speed = s;
    }

    public function isWalkOnNode() {
        return _walkOnNode;
    }

    public function setWalkOnNode(walkOnNode:Bool) {
        _walkOnNode = walkOnNode;
    }

    public function isBackForth() {
        return _backForth;
    }

    public function setBackForth(backForth:Bool) {
        _backForth = backForth;
    }

}
