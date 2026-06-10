package;

import lime.app.Application;
import lime.graphics.Image;
import lime.graphics.RenderContext;
import lime.graphics.opengl.GL;
import lime.utils.Float32Array;
import lime.utils.UInt32Array;
import quark.app.App;
import quark.math.Mat4;
import quark.math.Vec3;
import quark.utils.Color;
import quark.graphics.GLShader;
import quark.graphics.Texture;
import quark.graphics.buffer.IndexBuffer;
import quark.graphics.buffer.VertexBuffer;
import quark.graphics.vertex.VertexArray;
import quark.graphics.vertex.VertexLayout;

class Game extends App {
	var GLShader:GLShader;

	var vao:VertexArray;
	var vbo:VertexBuffer;
	var ibo:IndexBuffer;

	var projection:Mat4;
	var model:Mat4;

	var texture:Texture;

	var w:Int;
	var h:Int;

	override function onCreate() {
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

			vbo = new VertexBuffer(new Float32Array([
				0, 0, 0, 0,
				w, 0, 1, 0,
				0, h, 0, 1,
				w, h, 1, 1
			]));

			ibo = new IndexBuffer(new UInt32Array([
				0, 1, 2,
				1, 2, 3
			]));

			vao = new VertexArray();

			vao.addBuffer(vbo, VertexLayout.POS2_UV2);

			vao.setIndexBuffer(ibo);

			texture = new Texture(img);
		});
	}

	var angle:Float = 0;

	override function onUpdate(dt:Float) {
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
		var color:Color = ctx.attributes.background;

		GL.clearColor(color.rf, color.gf, color.bf, color.af);

		GL.clear(GL.COLOR_BUFFER_BIT);

		if (texture == null)
			return;

		texture.bind();

		shader.bind();

		shader.setMat4("model", model);

		shader.setMat4("projection", projection);

		shader.setTexture("tex", 0);

		vao.bind();

		GL.drawElements(GL.TRIANGLES, ibo.count, GL.UNSIGNED_INT, 0);
	}

	override function onResize(width:Int, height:Int) {
		projection = Mat4.ortho(0, width, height, 0, -1000, 1000);

		GL.viewport(0, 0, width, height);
	}

	override function onClose() {
		if (texture != null)
			texture.dispose();

		if (vao != null)
			vao.dispose();

		if (vbo != null)
			vbo.dispose();

		if (ibo != null)
			ibo.dispose();

		if (shader != null)
			shader.dispose();
	}
}
