package test;

import haxe.unit.TestCase;
import jellyPhysics.PressureBody;
import jellyPhysics.math.Vector2;

/**
 * ...
 * @author MIchael Apfelbeck
 */
class TestPressureBody extends TestCase
{

    public function testCreate() 
    {
        var closedShape:ClosedShape = new ClosedShape();
        
        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(5, 0));
        closedShape.AddVertex(new Vector2(5, 5));
        closedShape.AddVertex(new Vector2(0, 5));
        closedShape.Finish(true);
        
        var testBody:SpringBody = new PressureBody(
        closedShape, 5, new Vector2(5, 5), 0, new Vector2(0, 0), false,
        5.0, 1.0, 3.0, 1.0, 1.2);
        
        assertEquals(4, testBody.GlobalShape.length);		
    }
    
}