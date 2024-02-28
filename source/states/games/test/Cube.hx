package states.games.test;

import flx3D.FlxView3D;
import away3d.entities.Mesh;
import away3d.materials.ColorMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.lights.DirectionalLight;
import away3d.primitives.CubeGeometry;

class Cube extends FlxView3D
{
    var mesh:Mesh;
    var material:ColorMaterial;

    var light:DirectionalLight;
    var lightPicker:StaticLightPicker;

    public function new()
    {
        super();

        light = new DirectionalLight();
        light.ambient = 0.5;
        light.z -= 10;

        view.scene.addChild(light);

        lightPicker = new StaticLightPicker([light]);

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