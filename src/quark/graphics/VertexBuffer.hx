package quark.graphics;

import lime.utils.ArrayBufferView;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLVertexArrayObject;

/**
 * Represents a vertex buffer and its associated vertex array object.
 *
 * A VertexBuffer stores vertex data on the GPU and defines how
 * that data is interpreted through a VertexLayout.
 */
class VertexBuffer {

	/**
	 * Vertex Array Object used to store vertex attribute state.
	 */
	public var vao(default, null):GLVertexArrayObject;

	/**
	 * Native OpenGL vertex buffer.
	 */
	public var vbo(default, null):GLBuffer;

	/**
	 * Layout describing the structure of each vertex.
	 */
	public var layout(default, null):VertexLayout;

	/**
	 * Number of vertices contained in the buffer.
	 *
	 * This value is not automatically calculated and may be
	 * managed externally depending on the data format.
	 */
	public var vertexCount(default, null):Int = 0;

	/**
	 * Total buffer size in bytes.
	 */
	public var size(default, null):Int = 0;

	/**
	 * Creates a new vertex buffer and uploads its data.
	 *
	 * @param data Vertex data.
	 * @param layout Vertex layout description.
	 * @param dyn Whether the buffer will be updated frequently.
	 */
	public function new(data:ArrayBufferView, layout:VertexLayout, dyn:Bool = false) {
		this.layout = layout;

		vao = GL.createVertexArray();
		vbo = GL.createBuffer();

		bind();

		GL.bufferData(
			GL.ARRAY_BUFFER,
			data,
			dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW
		);

		size = data.byteLength;

		setupAttributes();

		unbind();
	}

	/**
	 * Configures vertex attributes according to the vertex layout.
	 *
	 * Called automatically during construction.
	 */
	function setupAttributes():Void {
		var offset:Int = 0;

		for (i in 0...layout.attributes.length) {
			var attr = layout.attributes[i];

			GL.enableVertexAttribArray(i);

			GL.vertexAttribPointer(
				i,
				attr.size,
				toGLType(attr.type),
				attr.normalized,
				layout.stride,
				offset
			);

			offset += attr.size * VertexLayout.byteSizeOf(attr.type);
		}
	}

	/**
	 * Replaces the entire contents of the vertex buffer.
	 *
	 * @param data New vertex data.
	 * @param dyn Whether the buffer should be optimized for updates.
	 */
	public function setData(data:ArrayBufferView, dyn:Bool = true):Void {
		bind();

		GL.bufferData(
			GL.ARRAY_BUFFER,
			data,
			dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW
		);

		size = data.byteLength;
	}

	/**
	 * Updates a portion of the buffer.
	 *
	 * Offset is specified in bytes.
	 *
	 * @param offset Byte offset.
	 * @param data Data to upload.
	 */
	public function setSubData(offset:Int, data:ArrayBufferView):Void {
		bind();

		GL.bufferSubData(GL.ARRAY_BUFFER, offset, data);
	}

	/**
	 * Updates a portion of the buffer using a float offset.
	 *
	 * Assumes each float occupies 4 bytes.
	 *
	 * @param floatOffset Float offset.
	 * @param data Data to upload.
	 */
	public inline function setSubDataFloats(floatOffset:Int, data:ArrayBufferView):Void {
		setSubData(floatOffset * 4, data);
	}

	/**
	 * Binds the VAO and VBO.
	 */
	public inline function bind():Void {
		GL.bindVertexArray(vao);
		GL.bindBuffer(GL.ARRAY_BUFFER, vbo);
	}

	/**
	 * Unbinds the current VAO and VBO.
	 */
	public static inline function unbind():Void {
		GL.bindVertexArray(null);
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	/**
	 * Releases GPU resources associated with this buffer.
	 */
	public function dispose():Void {
		GL.deleteBuffer(vbo);
		GL.deleteVertexArray(vao);
	}

	/**
	 * Converts a VertexAttributeType into its OpenGL constant.
	 *
	 * @param type Attribute type.
	 * @return OpenGL enum value.
	 */
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

	/**
	 * Configures this buffer as an instanced vertex source.
	 *
	 * Attributes are matched using their names in the shader.
	 *
	 * @param shader Target shader.
	 * @param divisor Instance divisor.
	 *
	 * Common values:
	 * - 0 = per vertex
	 * - 1 = per instance
	 */
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

			GL.vertexAttribPointer(
				loc,
				attr.size,
				toGLType(attr.type),
				attr.normalized,
				layout.stride,
				offset
			);

			GL.vertexAttribDivisor(loc, divisor);

			offset += attr.size * VertexLayout.byteSizeOf(attr.type);
		}
	}

	/**
	 * Removes instanced attribute bindings created by bindInstanced().
	 *
	 * Resets divisors back to zero and disables the attributes.
	 *
	 * @param shader Target shader.
	 */
	public function unbindInstanced(shader:Shader) {
		for (attr in (layout : Array<Dynamic>)) {
			var loc = GL.getAttribLocation(shader.program, attr.name);

			if (loc >= 0) {
				GL.vertexAttribDivisor(loc, 0);
				GL.disableVertexAttribArray(loc);
			}
		}
	}
}