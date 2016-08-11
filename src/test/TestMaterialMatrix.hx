package test;

import haxe.unit.TestCase;
import haxe.Constraints.Function;
import jellyPhysics.MaterialMatrix;
import jellyPhysics.MaterialPair;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestMaterialMatrix extends TestCase
{
    public function testSingle() 
    {
        var defaultPair:MaterialPair = new MaterialPair();
        defaultPair.Collide = true;
        defaultPair.CollisionFilter = null;
        defaultPair.Elasticity = 0.8;
        defaultPair.Friction = 0.1;
        
        var matrix:MaterialMatrix = new MaterialMatrix(defaultPair, 1);
        
        assertEquals(1, matrix.Count);
        assertTrue(matrix.Get(0, 0).Collide);
        
        try{
            var outOfBounds = matrix.Get(1, 3);
            assertTrue(false);
        }catch (err:Dynamic)
        {
            assertTrue(true);
        }
    }

    public function testSizeFive() 
    {
        var defaultPair:MaterialPair = new MaterialPair();
        defaultPair.Collide = true;
        defaultPair.CollisionFilter = null;
        defaultPair.Elasticity = 0.8;
        defaultPair.Friction = 0.1;
        
        var matrix:MaterialMatrix = new MaterialMatrix(defaultPair, 3);
        
        assertEquals(3, matrix.Count);
        assertTrue(matrix.Get(0, 0).Collide);
        
        var newPair:MaterialPair = new MaterialPair();
        newPair.Collide = false;
        newPair.CollisionFilter = null;
        newPair.Elasticity = 0.9;
        newPair.Friction = 0.25;
        
        matrix.AddMaterial();
        matrix.AddMaterial(newPair);
        
        assertEquals(5, matrix.Count);
        assertFalse(matrix.Get(4, 4).Collide);
    }
}