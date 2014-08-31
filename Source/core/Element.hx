package core;

import openfl.display.Sprite;

class Element extends Sprite
{
    private var _objectList:List<Element>;

    public function new()
    {
        super();
        this._objectList = new List<Element>();
    }
 
    public function addElement(obj:Element):Element
    {
        this.addChild(obj);
        this._objectList.add(obj);
        return obj;
    }

    public function addElementAt(obj:Element, index:Int):Element
    {
        this.addElement(obj);
        this.setChildIndex(obj, index);
        return obj;
    }

    public function update(dt:Float):Void 
    {
        for (object in _objectList) 
        {
            object.update(dt);
        }
    }
    
    public function draw():Void 
    {
        for (object in _objectList)
        {
            object.draw();
        }
    }
}
