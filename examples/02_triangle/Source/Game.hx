package;

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

	override function onCreate() {
		super.onCreate();

		var vertSrc:String = "#version 300 es

		in vec2 position;
		in vec4 color;

		out vec4 vColor;

		void main()
		{
			vColor = color;
			gl_Position = vec4(position, 0.0, 1.0);
		}";

		var fragSrc:String = "#version 300 es
		#ifdef GL_ES
		precision mediump float;
		#endif

		in vec4 vColor;
		out vec4 FragColor;

		void main() {
			FragColor = vColor;
		}";

		shader = new Shader(vertSrc, fragSrc);

		vertex = new VertexBuffer(new Float32Array([
			 0.0,  0.5, 1, 0, 0, 1,
			-0.5, -0.5, 0, 1, 0, 1,
			 0.5, -0.5, 0, 0, 1, 1
		]), VertexLayout.POS2_COL4);

		index = new IndexBuffer(new UInt32Array([0, 1, 2]));
	}

	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);

		var color:Color = ctx.attributes.background;

		App.GL.clearColor(color.rf, color.gf, color.bf, color.af);
		App.GL.clear(App.GL.COLOR_BUFFER_BIT);

		shader.bind();
		vertex.bind();
		index.bind();

		App.GL.drawElements(App.GL.TRIANGLES, index.count, App.GL.UNSIGNED_INT, 0);
	}

	override function onResize(width:Int, height:Int) {
		super.onResize(width, height);
		App.GL.viewport(0, 0, width, height);
	}

	override function onClose() {
		super.onClose();

		vertex.dispose();
		index.dispose();
		shader.dispose();
	}
}
