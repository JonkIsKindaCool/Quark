package;

import quark.math.Vec3;
import lime.app.Application;
import quark.math.Mat4;
import quark.graphics.Texture;
import lime.graphics.Image;
import lime.utils.UInt32Array;
import quark.graphics.VertexLayout;
import lime.utils.Float32Array;
import quark.graphics.IndexBuffer;
import quark.graphics.VertexBuffer;
import quark.graphics.Shader;
import quark.graphics.Color;
import lime.graphics.RenderContext;
import quark.app.App;

class Game extends App {
	var shader:Shader;
	var vertex:VertexBuffer;
	var index:IndexBuffer;

	var projection:Mat4;
	var model:Mat4;

	var texture:Texture;
	var w:Int;
	var h:Int;

	override function onCreate() {
		super.onCreate();

		projection = Mat4.ortho(0, Application.current.window.width, Application.current.window.height, 0, -100, 100);
		model = Mat4.identity();

		Image.loadFromFile("assets/test.png").onComplete(img -> {
			var vertSrc:String = "#version 300 es

			uniform mat4 projection;
			uniform mat4 model;
			
			in vec2 position;
			in vec2 uv;

			out vec2 ouv;

			void main()
			{
				ouv = uv;
				gl_Position = projection * model * vec4(position, 0.0, 1.0);
			}";

			var fragSrc:String = "#version 300 es

			#ifdef GL_ES
			precision mediump float;
			#endif

			in vec2 ouv;
			out vec4 FragColor;

			uniform sampler2D tex;

			void main() {
				FragColor = texture(tex, ouv);
			}";

			shader = new Shader(vertSrc, fragSrc);

			w = img.width;
			h = img.height;

			vertex = new VertexBuffer(new Float32Array([
				0, 0, 0, 0,
				w, 0, 1, 0,
				0, h, 0, 1,
				w, h, 1, 1,
			]), VertexLayout.POS2_UV2);

			index = new IndexBuffer(new UInt32Array([0, 1, 2, 1, 2, 3]));
			texture = new Texture(img);
		});
	}

	var angle:Float = 0;

	override function onUpdate(dt:Float) {
		super.onUpdate(dt);

		if (texture == null)
			return;

		angle += dt;

		var winW:Int = Application.current.window.width;
		var winH:Int = Application.current.window.height;

		var cx:Float = (winW - w) / 2;
		var cy:Float = (winH - h) / 2;

		var px:Float = w / 2;
		var py:Float = h / 2;

		model = Mat4.translation(new Vec3(cx + px, cy + py, 0)) * Mat4.rotationZ(angle) * Mat4.rotationY(-angle) * Mat4.translation(new Vec3(-px, -py, 0));
	}

	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);

		var color:Color = ctx.attributes.background;

		App.GL.clearColor(color.rf, color.gf, color.bf, color.af);
		App.GL.clear(App.GL.COLOR_BUFFER_BIT);

		if (texture != null) {
			texture.bind();

			shader.bind();
			shader.setMat4("model", model);
			shader.setMat4("projection", projection);
			shader.setTexture("tex", 0);
			vertex.bind();
			index.bind();

			App.GL.drawElements(App.GL.TRIANGLES, index.count, App.GL.UNSIGNED_INT, 0);
		}
	}

	override function onResize(width:Int, height:Int) {
		super.onResize(width, height);

		projection = Mat4.ortho(0, width, height, 0, -1000, 1000);

		App.GL.viewport(0, 0, width, height);
	}

	override function onClose() {
		super.onClose();
		
		texture.destroy();

		vertex.dispose();
		index.dispose();
		shader.dispose();
	}
}
