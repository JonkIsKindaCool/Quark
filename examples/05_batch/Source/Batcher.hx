import quark.app.App;
import quark.math.Vec2;
import quark.graphics.Texture;
import quark.math.Rect;
import quark.graphics.Shader;
import lime.utils.UInt32Array;
import quark.graphics.VertexLayout;
import lime.utils.Float32Array;
import quark.graphics.IndexBuffer;
import quark.graphics.VertexBuffer;

class Batcher {
	public static inline var MAX_ELEMENTS:Int = 1000;

	private static var _shader:Shader;

	private static var _vb:VertexBuffer;
	private static var _ib:IndexBuffer;

	private static var _count:Int = 0;

	private static var _vertexs:Int = 4;
	private static var _data_per_vertex:Int = 4;

	private static var _indices:Int = 6;

	private static var _currentTexture:Texture;

	public static function init() {
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

		_shader = new Shader(vertSrc, fragSrc);

		_vb = new VertexBuffer(new Float32Array(MAX_ELEMENTS * _vertexs * _data_per_vertex), VertexLayout.POS2_UV2);
		_ib = new IndexBuffer(new UInt32Array(MAX_ELEMENTS * _indices));
	}

	private static function _addQuad(pos:Rect, uv:Rect) {
		if (_count >= MAX_ELEMENTS) {
			flush();
		}
        
		_vb.setSubData(_count * _vertexs * _data_per_vertex * 4, new Float32Array([
			        pos.x,         pos.y,        uv.x,        uv.y,
			pos.x + pos.w,         pos.y, uv.x + uv.w,        uv.y,
			        pos.x, pos.y + pos.h,        uv.x, uv.y + uv.h,
			pos.x + pos.w, pos.y + pos.h, uv.x + uv.w, uv.y + uv.h,
		]));

		var base:Int = _count * _vertexs;

		_ib.setSubData(_count * _indices * 4, new UInt32Array([
			    base, base + 1, base + 2,
			base + 1, base + 2, base + 3
		]));

		_count++;
	}

	public static function flush() {
		if (_count == 0)
			return;

		_currentTexture.bind();

		_shader.bind();
		_shader.setMat4("projection", Game.projection);
		_shader.setTexture("tex", 0);

		_vb.bind();
		_ib.bind();

		App.GL.drawElements(App.GL.TRIANGLES, _count * _indices, App.GL.UNSIGNED_INT, 0);

		_count = 0;
	}

	public static function dispose() {
		_ib.dispose();
		_vb.dispose();
		_shader.dispose();
	}

	public static function drawTexture(pos:Vec2, tex:Texture) {
		if (_currentTexture != null && _currentTexture._internal != tex._internal) {
			flush();
		}

		_currentTexture = tex;
		_addQuad(new Rect(pos.x, pos.y, tex.width, tex.height), new Rect(0, 0, 1, 1));
	}
}
