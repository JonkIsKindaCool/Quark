package;

import quark.math.Vec2;
import quark.math.Vec3;
import lime.app.Application;
import quark.math.Mat4;
import quark.graphics.Texture;
import lime.graphics.Image;
import lime.utils.UInt32Array;
import lime.utils.Float32Array;
import lime.graphics.opengl.GL;
import quark.graphics.GLShader;
import quark.utils.Color;
import lime.graphics.RenderContext;
import quark.app.App;

class Game extends App {
	public static var projection:Mat4;

	var tex:Texture;

	var pos:Array<Vec2> = [];

	override function onCreate() {
		super.onCreate();

		Batcher.init();

		projection = Mat4.ortho(0, Application.current.window.width, Application.current.window.height, 0, -100, 100);

		Image.loadFromFile("assets/test.png").onComplete(img -> {
			tex = new Texture(img);

			for (i in 0...100) {
				pos.push(new Vec2(Std.random(1280), Std.random(720)));
			}
		});
	}

	override function onUpdate(dt:Float) {
		super.onUpdate(dt);
	}

	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);

		var color:Color = ctx.attributes.background;

		GL.clearColor(color.rf, color.gf, color.bf, color.af);
		GL.clear(GL.COLOR_BUFFER_BIT);

		if (tex != null) {
			for (pos in pos) {
				Batcher.drawTexture(pos, tex);
			}
		}

		Batcher.flush();
	}

	override function onResize(width:Int, height:Int) {
		super.onResize(width, height);

		projection = Mat4.ortho(0, width, height, 0, -1000, 1000);

		GL.viewport(0, 0, width, height);
	}

	override function onClose() {
		super.onClose();
		tex.dispose();
		Batcher.dispose();
	}
}
