package test;

import haxe.unit.TestCase;
import lime.math.Vector2;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestSpringBody extends TestCase
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
        
        var testBody:SpringBody = new SpringBody(
        closedShape, 5, new Vector2(5, 5), 0, new Vector2(0, 0), false,
        5.0, 1.0, 3.0, 1.0);
        
        assertEquals(4, testBody.GlobalShape.length);
    }
    
}