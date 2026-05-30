package quark.graphics;

import lime.utils.ArrayBufferView;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLVertexArrayObject;

class VertexBuffer {
	public var vao(default, null):GLVertexArrayObject;
	public var vbo(default, null):GLBuffer;
	public var layout(default, null):VertexLayout;

	public var vertexCount(default, null):Int = 0;
	public var size(default, null):Int = 0;

	public function new(data:ArrayBufferView, layout:VertexLayout, dyn:Bool = false) {
		this.layout = layout;

		vao = GL.createVertexArray();
		vbo = GL.createBuffer();

		bind();

		GL.bufferData(GL.ARRAY_BUFFER, data, dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);

		size = data.byteLength;

		setupAttributes();

		unbind();
	}

	function setupAttributes():Void {
		var offset:Int = 0;

		for (i in 0...layout.attributes.length) {
			var attr = layout.attributes[i];

			GL.enableVertexAttribArray(i);

			GL.vertexAttribPointer(i, attr.size, toGLType(attr.type), attr.normalized, layout.stride, offset);

			offset += attr.size * VertexLayout.byteSizeOf(attr.type);
		}
	}

	public function setData(data:ArrayBufferView, dyn:Bool = true):Void {
		bind();

		GL.bufferData(GL.ARRAY_BUFFER, data, dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);

		size = data.byteLength;
	}

	public function setSubData(offset:Int, data:ArrayBufferView):Void {
		bind();

		GL.bufferSubData(GL.ARRAY_BUFFER, offset, data);
	}

	public inline function setSubDataFloats(floatOffset:Int, data:ArrayBufferView):Void {
		setSubData(floatOffset * 4, data);
	}

	public inline function bind():Void {
		GL.bindVertexArray(vao);
		GL.bindBuffer(GL.ARRAY_BUFFER, vbo);
	}

	public static inline function unbind():Void {
		GL.bindVertexArray(null);
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	public function dispose():Void {
		GL.deleteBuffer(vbo);
		GL.deleteVertexArray(vao);
	}

	static function toGLType(type:VertexAttributeType):Int {
		return switch (type) {
			case FLOAT: GL.FLOAT;
			case HALF_FLOAT: GL.HALF_FLOAT;

			case BYTE: GL.BYTE;
			case SHORT: GL.SHORT;
			case INT: GL.INT;

			case UNSIGNED_BYTE: GL.UNSIGNED_BYTE;
			case UNSIGNED_SHORT: GL.UNSIGNED_SHORT;
			case UNSIGNED_INT: GL.UNSIGNED_INT;

			case INT_2_10_10_10_REV:
				GL.INT_2_10_10_10_REV;

			case UNSIGNED_INT_2_10_10_10_REV:
				GL.UNSIGNED_INT_2_10_10_10_REV;

			case UNSIGNED_INT_10F_11F_11F_REV:
				GL.UNSIGNED_INT_10F_11F_11F_REV;
		}
	}

	public function bindInstanced(shader:Shader, divisor:Int) {
		GL.bindBuffer(GL.ARRAY_BUFFER, vbo);
		var offset = 0;
		for (i in 0...layout.attributes.length) {
			var attr = layout.attributes[i];
			var loc = GL.getAttribLocation(shader.program, attr.name);
			if (loc < 0) {
				offset += attr.size * VertexLayout.byteSizeOf(attr.type);
				continue;
			}
			GL.enableVertexAttribArray(loc);
			GL.vertexAttribPointer(loc, attr.size, toGLType(attr.type), attr.normalized, layout.stride, offset);
			GL.vertexAttribDivisor(loc, divisor); // 0 = por vértice, 1 = por instancia
			offset += attr.size * VertexLayout.byteSizeOf(attr.type);
		}
	}

	public function unbindInstanced(shader:Shader) {
		for (attr in (layout : Array<Dynamic>)) {
			var loc = GL.getAttribLocation(shader.program, attr.name);
			if (loc >= 0) {
				GL.vertexAttribDivisor(loc, 0); // resetear divisor
				GL.disableVertexAttribArray(loc);
			}
		}
	}
}
