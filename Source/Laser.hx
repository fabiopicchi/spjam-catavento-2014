import openfl.geom.Rectangle;

import core.Element;
import core.SpriteSheet;

/**
 * ...
 * @author Chambers
 */
class Laser extends Element
{
    private var _arSegments:Array<SpriteSheet>;
    private var _length:Int;

    public var BLUE:String = "blue";
    public var GREEN:String = "green";
    public var RED:String = "red";
    
    private var FRAME_WIDTH:Int = 30;
    private var FRAME_HEIGHT:Int = 21;

    public function new (x:Float, y:Float, length:Int, direction:Int,
            colour:String) 
    {
        super();

        this.x = x;
        this.y = y;
        _length = length;

        var ss:SpriteSheet;
        ss = new SpriteSheet("assets/laser" + colour +
                    "_start01.png", FRAME_WIDTH, FRAME_HEIGHT) ;

        var animFramedata:Array<Rectangle> = new Array<Rectangle>();
        animFramedata.push(new Rectangle(0, 0, FRAME_WIDTH, FRAME_HEIGHT));
        animFramedata.push(new Rectangle(FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT));

        _arSegments = new Array<SpriteSheet>();
        _arSegments.push(ss);

        for (i in 0...(_length - 2))
        {
            ss = new SpriteSheet("assets/laser" + colour +
                    "_middle01.png", FRAME_WIDTH, FRAME_HEIGHT);            
            if (direction % 2 == 0)
                ss.x = (i + 1) * FRAME_WIDTH ;
            else 
                ss.y = (i + 1) * FRAME_WIDTH ;
            _arSegments.push(ss);
        }

        ss = new SpriteSheet("assets/laser" + colour +
                "_end01.png", FRAME_WIDTH, FRAME_HEIGHT);            
        if (direction % 2 == 0)
            ss.x = (_length - 1) * FRAME_WIDTH;
        else 
            ss.y = (_length - 1) * FRAME_WIDTH;
        _arSegments.push(ss);

        for (seg in _arSegments) 
        {
            seg.addAnimation("on", animFramedata, true, 10);
            seg.setAnimation("on");
            switch(direction)
            {
                case 1,3:
                    seg.rotation = 90;
                    seg.x = FRAME_HEIGHT;
            }
            addElement(seg);
        }

        switch(direction)
        {
            case 2:
                this.x += width;
                scaleX = -1;
            case 3:
                this.y += height;
                scaleY = -1;
        }
    }
}
