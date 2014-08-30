import openfl.Assets;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import core.Element;

class Tilemap extends Element
{
    private var _tileWidth:Int;
    private var _tileHeight:Int;
    private var _widthInTiles:Int;
    private var _heightInTiles:Int;
    private var _tileset:BitmapData;
    private var _tiles:Array<Int>;
    private var _tileQuads:Array<BitmapData>;
    private var _bodies:Array<Body>;
    private var _collisionArray:Array<Body>;

    public function new(mapLayer:Dynamic, tileset:BitmapData, 
            tileWidth:Int, tileHeight:Int)
    {
        super();

        _collisionArray = new Array<Body>();

        _tileset = tileset;
        _tileWidth = tileWidth;
        _tileHeight = tileHeight;
        _widthInTiles = mapLayer.width;
        _heightInTiles = mapLayer.height;
        _tiles = mapLayer.data;

        _tileQuads = new Array<BitmapData>();
        _bodies = new Array<Body>();

        var tilesetWidthInTiles:Int = Math.floor(_tileset.width / 
                _tileWidth);
        var tilesetHeightInTiles:Int = Math.floor(_tileset.height / 
                _tileHeight);
        var point:Point = new Point();
        for (j in 0...tilesetHeightInTiles)
        {
            for(i in 0...tilesetWidthInTiles)
            {
                var bmp:BitmapData = new BitmapData(_tileWidth, _tileHeight,
                        true);
                bmp.copyPixels(_tileset, new Rectangle(i * _tileWidth, j *
                            _tileHeight, _tileWidth, _tileHeight), point);
                _tileQuads.push(bmp);
            }
        }

        var tileCounter = 0;
        for(tile in _tiles)
        {
            var bitmap:Bitmap = new Bitmap(_tileQuads[tile - 1]);
            bitmap.x = (tileCounter % _widthInTiles) * _tileWidth;
            bitmap.y = Math.floor(tileCounter / _widthInTiles) * _tileHeight;
            
            if (tile > 1)
            {
                var body:Body = new Body(_tileWidth, _tileHeight);
                body.position.x = (tileCounter % _widthInTiles) * _tileWidth;
                body.position.y = Math.floor(tileCounter / _widthInTiles) * _tileHeight;
                body.lastPosition.x = body.position.x;
                body.lastPosition.y = body.position.y;
                _bodies.push(body);
            }
            tileCounter++;
            addChild(bitmap);
        }
    }

    public function collideTilemap(body : Body):Bool
    {
        var ret:Bool = false;
        for (b in _bodies)
        {
            if (b.inRange(body.position.x + body.width/2,
                        body.position.y + body.height/2,
                        2 * body.width))
            {
                if (b.overlapBody(body))
                {
                    _collisionArray.push(b);
                }
            }
        }

        _collisionArray.sort(function (b1:Body, b2:Body):Int
        {
            var d1:Float = (b1.position.x - body.position.x) * 
                (b1.position.x - body.position.x) + 
                (b1.position.y - body.position.y) * 
                (b1.position.y - body.position.y);

            var d2:Float = (b2.position.x - body.position.x) * 
                (b2.position.x - body.position.x) + 
                (b2.position.y - body.position.y) * 
                (b2.position.y - body.position.y);

            if(d1 < d2) return -1;
            else if(d1 > d2) return 1;
            else return 0;
        });

        for (b in _collisionArray) 
        {
            b.collideBody(body);
        }

        if (_collisionArray.length > 0)
            return false;
        else
        {
            while(_collisionArray.length != 0) _collisionArray.pop();
            return true;
        }
    }

	function canSee ():Bool {
		var c:Bool;
		c = true;
		return c;
	}
}
