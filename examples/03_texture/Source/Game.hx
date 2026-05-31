package;

import quark.graphics.Texture;
import lime.graphics.Image;
import lime.utils.UInt32Array;
import quark.graphics.VertexLayout;
import lime.utils.Float32Array;
import lime.utils.Assets;
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

	var texture:Texture;

	override function onCreate() {
		super.onCreate();

		Image.loadFromFile("assets/test.png").onComplete(img -> {
			var vertSrc:String = "#version 300 es

		in vec2 position;
		in vec2 uv;

		out vec2 ouv;

		void main()
		{
			ouv = uv;
			gl_Position = vec4(position, 0.0, 1.0);
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

			vertex = new VertexBuffer(new Float32Array([
				-0.5, -0.5, 0, 1,
				 0.5, -0.5, 1, 1,
				-0.5,  0.5, 0, 0,
				 0.5,  0.5, 1, 0,
			]), VertexLayout.POS2_UV2);

			index = new IndexBuffer(new UInt32Array([0, 1, 2, 1, 2, 3]));

			texture = new Texture(img);
		});
	}

	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);

		var color:Color = ctx.attributes.background;

		App.GL.clearColor(color.rf, color.gf, color.bf, color.af);
		App.GL.clear(App.GL.COLOR_BUFFER_BIT);

		if (texture != null) {
			texture.bind();

			shader.bind();
			shader.setTexture("tex", 0);
			vertex.bind();
			index.bind();

			App.GL.drawElements(App.GL.TRIANGLES, index.count, App.GL.UNSIGNED_INT, 0);
		}
	}

	override function onClose() {
		super.onClose();
		shader.dispose();
		vertex.dispose();
		index.dispose();

		texture.destroy();
	}

	override function onResize(width:Int, height:Int) {
		super.onResize(width, height);
		App.GL.viewport(0, 0, width, height);
	}
}
