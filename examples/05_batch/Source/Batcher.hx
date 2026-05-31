package;

import lime.graphics.opengl.GL;
import lime.utils.Float32Array;
import lime.utils.UInt32Array;

import quark.app.App;

import quark.math.Rect;
import quark.math.Vec2;

import quark.graphics.Shader;
import quark.graphics.Texture;

import quark.graphics.buffer.BufferUsage;
import quark.graphics.buffer.IndexBuffer;
import quark.graphics.buffer.VertexBuffer;

import quark.graphics.vertex.VertexArray;
import quark.graphics.vertex.VertexLayout;

class Batcher {

	public static inline var MAX_ELEMENTS:Int = 1000;

	private static inline var VERTICES_PER_QUAD:Int = 4;
	private static inline var INDICES_PER_QUAD:Int = 6;
	private static inline var FLOATS_PER_VERTEX:Int = 4;

	private static var _shader:Shader;

	private static var _vao:VertexArray;
	private static var _vbo:VertexBuffer;
	private static var _ibo:IndexBuffer;

	private static var _currentTexture:Texture;

	private static var _count:Int = 0;

	public static function init():Void {

		var vertSrc:String = "#version 300 es

		uniform mat4 projection;

		in vec2 position;
		in vec2 uv;

		out vec2 ouv;

		void main()
		{
			ouv = uv;
			gl_Position = projection * vec4(position, 0.0, 1.0);
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

		_shader = new Shader(
			vertSrc,
			fragSrc
		);

		_vbo = new VertexBuffer(
			new Float32Array(
				MAX_ELEMENTS
				* VERTICES_PER_QUAD
				* FLOATS_PER_VERTEX
			),
			BufferUsage.DYNAMIC_DRAW
		);

		var indices = new UInt32Array(
			MAX_ELEMENTS * INDICES_PER_QUAD
		);

		for (i in 0...MAX_ELEMENTS) {

			var base:Int = i * 4;
			var idx:Int = i * 6;

			indices[idx + 0] = base;
			indices[idx + 1] = base + 1;
			indices[idx + 2] = base + 2;

			indices[idx + 3] = base + 1;
			indices[idx + 4] = base + 2;
			indices[idx + 5] = base + 3;
		}

		_ibo = new IndexBuffer(indices);

		_vao = new VertexArray();

		_vao.addBuffer(
			_vbo,
			VertexLayout.POS2_UV2
		);

		_vao.setIndexBuffer(_ibo);
	}

	private static function addQuad(
		pos:Rect,
		uv:Rect
	):Void {

		if (_count >= MAX_ELEMENTS)
			flush();

		var vertexOffset:Int =
			_count
			* VERTICES_PER_QUAD
			* FLOATS_PER_VERTEX
			* 4;

		_vbo.setSubData(
			vertexOffset,
			new Float32Array([
				pos.x,
				pos.y,
				uv.x,
				uv.y,

				pos.x + pos.w,
				pos.y,
				uv.x + uv.w,
				uv.y,

				pos.x,
				pos.y + pos.h,
				uv.x,
				uv.y + uv.h,

				pos.x + pos.w,
				pos.y + pos.h,
				uv.x + uv.w,
				uv.y + uv.h
			])
		);

		_count++;
	}

	public static function drawTexture(
		position:Vec2,
		texture:Texture
	):Void {

		if (
			_currentTexture != null
			&& _currentTexture._internal != texture._internal
		) {
			flush();
		}

		_currentTexture = texture;

		addQuad(
			new Rect(
				position.x,
				position.y,
				texture.width,
				texture.height
			),
			new Rect(
				0,
				0,
				1,
				1
			)
		);
	}

	public static function flush():Void {

		if (_count == 0)
			return;

		_currentTexture.bind(0);

		_shader.bind();

		_shader.setMat4(
			"projection",
			Game.projection
		);

		_shader.setTexture(
			"tex",
			0
		);

		_vao.bind();

		GL.drawElements(
			GL.TRIANGLES,
			_count * INDICES_PER_QUAD,
			GL.UNSIGNED_INT,
			0
		);

		_count = 0;
	}

	public static function dispose():Void {

		if (_vao != null)
			_vao.dispose();

		if (_ibo != null)
			_ibo.dispose();

		if (_vbo != null)
			_vbo.dispose();

		if (_shader != null)
			_shader.dispose();

		_currentTexture = null;
		_count = 0;
	}
}