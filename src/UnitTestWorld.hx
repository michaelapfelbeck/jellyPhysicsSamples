package;

import jellyPhysics.Body;
import jellyPhysics.PointMass;
import jellyPhysics.test.*;
import lime.math.Vector2;
import haxe.unit.TestRunner;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;
import test.TestArrayCollider;
import test.TestBody;
import test.TestClosedShape;
import test.TestMaterialMatrix;
import test.TestPressureBody;
import test.TestSpringBody;
import test.TestVectorTools;
import test.TestWorld;

/**
 * ...
 * @author Michael Apfelbeck
 * 
 * Unit test world
 */
class UnitTestWorld extends TestWorldBase
{

    public function new(inputPoll:InputPoll) 
    {
        super(inputPoll);
		        
        var runner:TestRunner = new TestRunner();
        runner.add(new TestMaterialMatrix());
        runner.add(new TestVectorTools());
        runner.add(new TestAABB());
        runner.add(new TestClosedShape());
        runner.add(new TestBody());
        runner.add(new TestSpringBody());
        runner.add(new TestPressureBody());
        runner.add(new TestArrayCollider());
        runner.add(new TestWorld());
        runner.run();
    }
    
    override function Close(e:Event):Void 
    {
        super.Close(e);
        
        removeChildren(0, this.numChildren);
    }
    
    override public function setupDrawParam(render:DrawDebugWorld):Void 
    {
        super.setupDrawParam(render);
        render.DrawingBackground = false;
    }
}