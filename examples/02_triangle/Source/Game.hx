package;

import lime.graphics.RenderContext;
import lime.graphics.opengl.GL;
import lime.utils.Float32Array;
import lime.utils.UInt32Array;
import quark.app.App;
import quark.utils.Color;
import quark.graphics.Shader;
import quark.graphics.buffer.VertexBuffer;
import quark.graphics.buffer.IndexBuffer;
import quark.graphics.vertex.VertexArray;
import quark.graphics.vertex.VertexLayout;

class Game extends App {
	var shader:Shader;

	var vao:VertexArray;
	var vbo:VertexBuffer;
	var ibo:IndexBuffer;

	override function onCreate():Void {
		var vertexSource:String = "#version 300 es

		in vec2 position;
		in vec4 color;

		out vec4 vColor;

		void main() {
			vColor = color;
			gl_Position = vec4(position, 0.0, 1.0);
		}";

		var fragmentSource:String = "#version 300 es

		#ifdef GL_ES
		precision mediump float;
		#endif

		in vec4 vColor;
		out vec4 FragColor;

		void main() {
			FragColor = vColor;
		}";

		shader = new Shader(vertexSource, fragmentSource);

		vbo = new VertexBuffer(new Float32Array([
			 0.0,  0.5, 1, 0, 0, 1,
			-0.5, -0.5, 0, 1, 0, 1,
			 0.5, -0.5, 0, 0, 1, 1
		]));

		ibo = new IndexBuffer(new UInt32Array([0, 1, 2]));

		vao = new VertexArray();

		vao.addBuffer(vbo, VertexLayout.POS2_COL4);

		vao.setIndexBuffer(ibo);
	}

	override function onRender(ctx:RenderContext):Void {
		var color:Color = ctx.attributes.background;

		GL.clearColor(color.rf, color.gf, color.bf, color.af);

		GL.clear(GL.COLOR_BUFFER_BIT);

		shader.bind();
		vao.bind();

		GL.drawElements(GL.TRIANGLES, ibo.count, GL.UNSIGNED_INT, 0);
	}

	override function onResize(width:Int, height:Int):Void {
		GL.viewport(0, 0, width, height);
	}

	override function onClose():Void {
		vao.dispose();
		vbo.dispose();
		ibo.dispose();
		shader.dispose();
	}
}
