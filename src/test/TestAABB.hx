package test;

import haxe.unit.TestCase;
import lime.math.Vector2;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestAABB extends TestCase
{
    public function testInside() 
    {
        var box:AABB = new AABB();
        
        box.Clear();
        
        box.ExpandToInclude(new Vector2(1, 1));
        box.ExpandToInclude(new Vector2(5, 5));
        
        assertTrue(box.ContainsPoint(new Vector2(2, 2)));
    }
    
    public function testOutside() 
    {
        var box:AABB = new AABB();
        
        box.Clear();
        
        box.ExpandToInclude(new Vector2(1, 1));
        box.ExpandToInclude(new Vector2(5, 5));
        
        assertFalse(box.ContainsPoint(new Vector2(0, 0)));
    }
}