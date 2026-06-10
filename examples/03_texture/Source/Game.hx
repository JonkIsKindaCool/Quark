package;

import lime.graphics.Image;
import lime.graphics.RenderContext;
import lime.graphics.opengl.GL;
import lime.utils.Float32Array;
import lime.utils.UInt32Array;
import quark.app.App;
import quark.utils.Color;
import quark.graphics.GLShader;
import quark.graphics.Texture;
import quark.graphics.buffer.VertexBuffer;
import quark.graphics.buffer.IndexBuffer;
import quark.graphics.vertex.VertexArray;
import quark.graphics.vertex.VertexLayout;

class Game extends App {
	var GLShader:GLShader;

	var vao:VertexArray;
	var vbo:VertexBuffer;
	var ibo:IndexBuffer;

	var texture:Texture;

	override function onCreate():Void {
		Image.loadFromFile("assets/test.png").onComplete(image -> {
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

			GLShader = new GLShader(vertSrc, fragSrc);

			vbo = new VertexBuffer(new Float32Array([
				-0.5, -0.5, 0, 1,
				 0.5, -0.5, 1, 1,
				-0.5,  0.5, 0, 0,
				 0.5,  0.5, 1, 0
			]));

			ibo = new IndexBuffer(new UInt32Array([
				0, 1, 2,
				1, 3, 2
			]));

			vao = new VertexArray();

			vao.addBuffer(vbo, VertexLayout.POS2_UV2);

			vao.setIndexBuffer(ibo);

			texture = new Texture(image);
		});
	}

	override function onRender(ctx:RenderContext):Void {
		var color:Color = ctx.attributes.background;

		GL.clearColor(color.rf, color.gf, color.bf, color.af);

		GL.clear(GL.COLOR_BUFFER_BIT);

		if (texture == null)
			return;

		GLShader.bind();

		texture.bind(0);
		GLShader.setTexture("tex", 0);

		vao.bind();

		GL.drawElements(GL.TRIANGLES, ibo.count, GL.UNSIGNED_INT, 0);
	}

	override function onResize(width:Int, height:Int):Void {
		GL.viewport(0, 0, width, height);
	}

	override function onClose():Void {
		if (texture != null)
			texture.dispose();

		if (vao != null)
			vao.dispose();

		if (vbo != null)
			vbo.dispose();

		if (ibo != null)
			ibo.dispose();

		if (GLShader != null)
			GLShader.dispose();
	}
}
