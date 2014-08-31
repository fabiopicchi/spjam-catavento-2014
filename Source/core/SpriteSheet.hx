package core;

import haxe.Json;
import haxe.ds.StringMap;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;

private class Animation {
    public var arFrames:Array<BitmapData>;
    public var looped:Bool;
    public var fps:Int;

    public function new (arFrames:Array<BitmapData>, looped:Bool, fps:Int)
    {
        this.arFrames = arFrames;
        this.looped = looped;
        this.fps = fps;
    }
}

class SpriteSheet extends Element {

    private var _animationData:StringMap<Animation>;
    private var _currentFrame:Int;
    private var _currentAnimation:Animation;
    private var _currentAnimationName:String;
    private var _timeAcc:Float;
    private var _framePeriod:Float;
    private var _frameWidth:Int;
    private var _frameHeight:Int;

    private var _bitmap:Bitmap;
    private var _sourceImage:BitmapData;
    
    public function new(path:String, width:Int, height:Int)
    {
        super();

        _frameWidth = width;
        _frameHeight = height;
        _sourceImage = Assets.getBitmapData(path);
        _bitmap = new Bitmap();
        //_bitmap.x = -width/2;
        addChild(_bitmap);

        _currentFrame = 0;
        _timeAcc = 0;
        _animationData = new StringMap<Animation>();
    }

    public function addAnimation(name:String, frameData:Array<Rectangle>,
            looped:Bool, fps:Int):Void
    {
        var arFrames:Array<BitmapData> = new Array<BitmapData>();
        var point:Point = new Point();

        for (r in frameData)
        {
            var bmp:BitmapData = new BitmapData(_frameWidth, _frameHeight, true);
            bmp.copyPixels(_sourceImage, r, point);
            arFrames.push(bmp);
        }
        _animationData.set(name, new Animation(arFrames, looped, fps));
    }

    public function loadAnimationsFromJSON(path:String):Void
    {
        var obj:Dynamic = Json.parse(Assets.getText(path));

        for (a in Reflect.fields(obj))
        {
            var arRect:Array<Rectangle> = new Array<Rectangle>();
            var objAnimation:Dynamic = Reflect.field(obj, a);
            var arFrames:Array<Dynamic> = objAnimation.frames;

            for (o in arFrames)
            {
                arRect.push(new Rectangle(o.x, o.y, _frameWidth, _frameHeight));
            }
            addAnimation(a, arRect, objAnimation.looped, objAnimation.fps);
        }
    }

    public function setAnimation(name:String):Void
    {
        if (name != _currentAnimationName)
        {
            _currentAnimationName = name;
            _currentAnimation = _animationData.get(name);
            _framePeriod = 1 / _currentAnimation.fps;
            _currentFrame = 0;
            _timeAcc = 0;
            _bitmap.bitmapData = _currentAnimation.arFrames[_currentFrame];
        }
    }

    public function isOver():Bool
    {
        return (_currentAnimation.looped ||
                _currentFrame >= _currentAnimation.arFrames.length - 1);
    }

    override public function update(dt:Float):Void
    {
        _timeAcc += dt;
        if (_timeAcc >= _framePeriod)
        {
            if (_currentAnimation.looped)
            {
                _currentFrame = (_currentFrame + 1) % 
                    _currentAnimation.arFrames.length; 
            }
            else if (_currentFrame < _currentAnimation.arFrames.length - 1)
            {
                _currentFrame++;
            }
            _timeAcc = 0;
        }

        super.update(dt);
    }

    override public function draw():Void
    {
        _bitmap.bitmapData = _currentAnimation.arFrames[_currentFrame];
        super.draw();
    }
}
