package test;
import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import jellyPhysics.math.Vector2;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestClosedShape extends TestCase
{

    public function testTransform() 
    {
        var closedShape:ClosedShape = new ClosedShape();
        
        closedShape.Begin();
        for (i in 0 ... 5){
            closedShape.AddVertex(new Vector2(i, i));
        }
        closedShape.Finish(true);
        var transformed:Array<Vector2> = closedShape.transformVertices(new Vector2(), 0, new Vector2(0.5, 0.5));
        
        assertEquals( -2.0, closedShape.LocalVertices[0].x);
        assertEquals( -1.0, transformed[0].x);
        assertEquals( -1.0, transformed[0].y);
    }
    
}