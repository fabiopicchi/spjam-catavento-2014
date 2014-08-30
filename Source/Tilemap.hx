import haxe.Json;

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

    public function new(tmxPath:String)
    {
        super();

        var tilemapData:Dynamic = Json.parse(Assets.getText(tmxPath));

        _tileset = Assets.getBitmapData("assets/" +
                tilemapData.tilesets[0].image);

        _tileWidth = tilemapData.tilewidth;
        _tileHeight = tilemapData.tileheight;
        _widthInTiles = tilemapData.width;
        _heightInTiles = tilemapData.height;
        _tiles = tilemapData.layers[0].data;

        _tileQuads = new Array<BitmapData>();

        var tilesetWidthInTiles:Int = Math.floor(_tileset.width / _tileWidth);
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
        for (tile in _tiles)
        {
            var bitmap:Bitmap = new Bitmap(_tileQuads[tile - 1]);
            bitmap.x = (tileCounter % _widthInTiles) * _tileWidth;
            bitmap.y = Math.floor(tileCounter / _widthInTiles) * _tileHeight;
            tileCounter++;
            addChild(bitmap);
        }
    }
}
