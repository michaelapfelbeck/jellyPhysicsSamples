package test;

import haxe.unit.TestCase;
import lime.math.Vector2;
import jellyPhysics.ArrayCollider;
import jellyPhysics.BodyCollisionInfo;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestArrayCollider extends TestCase
{

    public function testAdd() 
    {
        var collider:ArrayCollider = new ArrayCollider(0.05);
        
        var closedShape:ClosedShape = new ClosedShape();

        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(4, 0));
        closedShape.AddVertex(new Vector2(4, 4));
        closedShape.AddVertex(new Vector2(0, 4));
        closedShape.Finish(true);

        var testBody1:Body = new Body(closedShape, 5, new Vector2(0, 0), 0, new Vector2(1, 1), false);
        var testBody2:Body = new Body(closedShape, 5, new Vector2(1, 1), 0, new Vector2(1, 1), false);
        var testBody3:Body = new Body(closedShape, 5, new Vector2(10, 10), 0, new Vector2(1, 1), false);
        
        collider.Add(testBody1);
        collider.Add(testBody2);
        
        assertEquals(2, collider.Count);
        assertTrue(collider.Contains(testBody1));
        assertFalse(collider.Contains(testBody3));
        
        var collisions:Array<BodyCollisionInfo> = collider.BuildCollisions();
        
        assertEquals(2, collisions.length);
    }
    
}