package test;

import haxe.ds.Vector;
import haxe.unit.TestCase;
import jellyPhysics.AABB;
import jellyPhysics.World;
import jellyPhysics.math.Vector2;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestWorld extends TestCase
{
    public function testCreate(){
        var closedShape:ClosedShape = new ClosedShape();

        closedShape.Begin();
        closedShape.AddVertex(new Vector2(0, 0));
        closedShape.AddVertex(new Vector2(4, 0));
        closedShape.AddVertex(new Vector2(4, 4));
        closedShape.AddVertex(new Vector2(0, 4));
        closedShape.Finish(true);

        var testBody1:Body = new Body(closedShape, 5, new Vector2(0, 0), 0, new Vector2(1, 1), false);
        var testBody2:Body = new Body(closedShape, 5, new Vector2(5, 5), 0, new Vector2(1, 1), false);
        
        var bounds:AABB = new AABB(new Vector2( -20, -20), new Vector2(20, 20));
        
        var defaultPair:MaterialPair = new MaterialPair();
        defaultPair.Collide = true;
        defaultPair.CollisionFilter = null;
        defaultPair.Elasticity = 0.8;
        defaultPair.Friction = 0.1;
        
        var matrix:MaterialMatrix = new MaterialMatrix(defaultPair, 1);
        
        var world:World = new World(1, matrix, defaultPair, 0.05, bounds);
        
        assertTrue(world.AddBody(testBody1) != -1);
        assertTrue(world.AddBody(testBody2) != -1);
        
        assertTrue(world.AddBody(testBody1) == -1);
        
        assertTrue(testBody1.BodyNumber != testBody2.BodyNumber);
        
        assertTrue(world.GetBody(1) != null);
    }
}