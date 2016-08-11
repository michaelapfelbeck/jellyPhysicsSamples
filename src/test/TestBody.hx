package test;

import haxe.unit.TestCase;
import lime.math.Vector2;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestBody extends TestCase
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
        
        var testBody:Body = new Body(closedShape, 5, new Vector2(5, 5), 0, new Vector2(1, 1), false);
        
        assertEquals(4, testBody.GlobalShape.length);
    }
    
    public function testContains()
    {
        var closedShape:ClosedShape = new ClosedShape();
        
        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(5, 0));
        closedShape.AddVertex(new Vector2(5, 5));
        closedShape.AddVertex(new Vector2(0, 5));
        closedShape.Finish(true);

        var testBody:Body = new Body(closedShape, 5, new Vector2(5, 5), 0, new Vector2(1, 1), false);
        
        var inside:Vector2 = new Vector2(7, 7);
        var outside:Vector2 = new Vector2(2, 2);
        
        assertTrue(testBody.Contains(inside));
        assertFalse(testBody.Contains(outside));
    }
    
    public function testClosestPointOnEdge()
    {
        var closedShape:ClosedShape = new ClosedShape();
        
        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(4, 0));
        closedShape.AddVertex(new Vector2(4, 4));
        closedShape.AddVertex(new Vector2(0, 4));
        closedShape.Finish(true);

        var testBody:Body = new Body(closedShape, 5, new Vector2(3, 3), 0, new Vector2(1, 1), false);
        
        var pointOnEdge:PointOnEdge = testBody.GetClosestPointOnEdge(new Vector2(6, 3), 1);
        //trace("pointOnEdge.EdgeNum: " + pointOnEdge.EdgeNum);
        //trace("pointOnEdge.Distance: " + pointOnEdge.Distance);
        //trace("pointOnEdge.Point: [" + pointOnEdge.Point.x + ", " + pointOnEdge.Point.y + "]");
        //trace("pointOnEdge.Normal: [" + pointOnEdge.Normal.x + ", " + pointOnEdge.Normal.y + "]");
        //trace("pointOnEdge.EdgeDistance: " + pointOnEdge.EdgeDistance);

        assertEquals(1, pointOnEdge.EdgeNum);
        assertEquals(1.0, pointOnEdge.Distance);
        assertEquals(5.0, pointOnEdge.Point.x);
        assertEquals(3.0, pointOnEdge.Point.y);
        assertEquals(0.5, pointOnEdge.EdgeDistance);
    }
    
    public function testClosestPoint()
    {
        var closedShape:ClosedShape = new ClosedShape();
        
        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(4, 0));
        closedShape.AddVertex(new Vector2(4, 4));
        closedShape.AddVertex(new Vector2(0, 4));
        closedShape.Finish(true);

        var testBody:Body = new Body(closedShape, 5, new Vector2(3, 3), 0, new Vector2(1, 1), false);
        
        var point:PointOnEdge = testBody.GetClosestPoint(new Vector2(3, 0));
        //trace("point.EdgeNum: " + point.EdgeNum);
        //trace("point.Distance: " + point.Distance);
        //trace("point.Point: [" + point.Point.x + ", " + point.Point.y + "]");
        //trace("point.Normal: [" + point.Normal.x + ", " + point.Normal.y + "]");
        //trace("point.EdgeDistance: " + point.EdgeDistance);

        assertEquals(0, point.EdgeNum);
        assertEquals(1.0, point.Distance);
        assertEquals(3.0, point.Point.x);
        assertEquals(1.0, point.Point.y);
        assertEquals(0.5, point.EdgeDistance);
    }
    
    public function testCollide()
    {
        var closedShape:ClosedShape = new ClosedShape();
        
        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(4, 0));
        closedShape.AddVertex(new Vector2(4, 4));
        closedShape.AddVertex(new Vector2(0, 4));
        closedShape.Finish(true);

        var bodyA:Body = new Body(closedShape, 5, new Vector2(0, 0), 0, new Vector2(1, 1), false);
        var bodyB:Body = new Body(closedShape, 5, new Vector2(1, 1), 0, new Vector2(1, 1), false);
        
        var collisions : Array<BodyCollisionInfo> = Body.BodyCollide(bodyA, bodyB, 0.1);

        assertTrue(null != collisions);
        assertEquals(1, collisions.length);
    }
    
    public function testClosestPointOnEdgeSquared()
    {
        var closedShape:ClosedShape = new ClosedShape();
        
        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(4, 0));
        closedShape.AddVertex(new Vector2(4, 4));
        closedShape.AddVertex(new Vector2(0, 4));
        closedShape.Finish(true);

        var testBody:Body = new Body(closedShape, 5, new Vector2(0, 0), 0, new Vector2(1, 1), false);
        
        var pointOnEdge:PointOnEdge = testBody.GetClosestPointOnEdgeSquared(new Vector2(0, -4), 0);

        assertEquals(0, pointOnEdge.EdgeNum);
        assertTrue(4.001 > pointOnEdge.Distance);
        assertTrue(3.999 < pointOnEdge.Distance);
        assertEquals(0.0, pointOnEdge.Point.x);
        assertEquals(-2.0, pointOnEdge.Point.y);
        assertEquals(0.5, pointOnEdge.EdgeDistance);
    }
}