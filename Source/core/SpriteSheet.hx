package core;

import openfl.Assets;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class SpriteSheet 
{
    private var _frameWidth:Int;
    private var _frameHeight:Int;
    private var _ssColumns:Int;
    private var _ssRows:Int;
    private var _numFrames:Int;
    public var numFrames(get,null):Int;
    private var _arFrames:Array<Bitmap>;
    private var _sourceImage:BitmapData;
    public var frameWidth(get,null):Int;
    public function get_frameWidth():Int{return _frameWidth;}
    public var frameHeight(get,null):Int;
    public function get_frameHeight():Int{return _frameHeight;}

    public function new (path:String, frameWidth:Int, frameHeight:Int, ?numFrames:Int)
    {
        _sourceImage = Assets.getBitmapData(path);
        _frameWidth = frameWidth;
        _frameHeight = frameHeight;
        _ssColumns = Math.floor(_sourceImage.width / _frameWidth);
        _ssRows = Math.floor(_sourceImage.height / _frameHeight);
        _numFrames = (numFrames == null ? _ssColumns * _ssRows : numFrames);
        _arFrames = new Array<Bitmap>();

        var p:Point = new Point();
        for(f in 0..._numFrames)
        {
            var r:Rectangle = new Rectangle(
                (f % _ssColumns) * _frameWidth,
                Math.floor(f / _ssColumns) * _frameHeight,
                _frameWidth,
                _frameHeight
            );

            var bmp:BitmapData = new BitmapData(_frameWidth, _frameHeight, true);
            bmp.copyPixels(_sourceImage, r, p);
            _arFrames.push(new Bitmap(bmp));
        }
    }

    public function getFramedata (index:Int):Bitmap
    {
        return _arFrames[index % _numFrames];
    }

    public function get_numFrames():Int
    {
        return _numFrames;
    }
}
