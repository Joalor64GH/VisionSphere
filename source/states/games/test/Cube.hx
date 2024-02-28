package states.games.test;

import flx3D.FlxView3D;
import away3d.entities.Mesh;
impory away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;

class Cube extends FlxView3D
{
    var mesh:Mesh;
    var material:ColorMaterial;

    public function new()
    {
        super();

        material = new ColorMaterial(0x7836F3);

        mesh = new Mesh(new CubeGeometry(), material);
        mesh.scale(5);
        mesh.rotationY = 45;

        view.scene.addChild(mesh);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (mesh != null)
            mesh.rotationY += 10 * elapsed;
    }

    override function destroy()
    {
        super.destroy;
        mesh = dispose(mesh);
    }
}