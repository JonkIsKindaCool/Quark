package quark.graphics.vertex;

import quark.utils.IDisposable;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLVertexArrayObject;
import quark.graphics.buffer.IndexBuffer;
import quark.graphics.buffer.VertexBuffer;

/**
 * OpenGL Vertex Array Object.
 *
 * A VertexArray stores vertex attribute configuration,
 * buffer bindings and optional index buffer bindings.
 *
 * It describes how vertex data is interpreted by the GPU.
 */
class VertexArray implements IDisposable{

	/**
	 * Native OpenGL VAO handle.
	 */
	public var _internal(default, null):GLVertexArrayObject;

	/**
	 * Currently attached index buffer.
	 */
	public var indexBuffer(default, null):IndexBuffer;

	/**
	 * Creates a new vertex array.
	 */
	public function new() {
		_internal = GL.createVertexArray();
	}

	/**
	 * Binds this vertex array.
	 */
	public inline function bind():Void {
		GL.bindVertexArray(_internal);
	}

	/**
	 * Unbinds the current vertex array.
	 */
	public static inline function unbind():Void {
		GL.bindVertexArray(null);
	}

	/**
	 * Adds a vertex buffer using the specified layout.
	 *
	 * Attributes are automatically assigned sequential
	 * locations beginning at the provided location.
	 *
	 * @param buffer Source vertex buffer.
	 * @param layout Vertex layout.
	 * @param firstLocation First attribute location.
	 */
	public function addBuffer(
		buffer:VertexBuffer,
		layout:VertexLayout,
		firstLocation:Int = 0
	):Void {

		bind();
		buffer.bind();

		var offset:Int = 0;
		var location:Int = firstLocation;

		for (attribute in layout.attributes) {

			GL.enableVertexAttribArray(location);

			GL.vertexAttribPointer(
				location,
				attribute.size,
				toGLType(attribute.type),
				attribute.normalized,
				layout.stride,
				offset
			);

			offset += attribute.size
				* VertexLayout.byteSizeOf(attribute.type);

			location++;
		}
	}

	/**
	 * Adds an instanced vertex buffer.
	 *
	 * Each attribute receives a divisor of 1.
	 *
	 * @param buffer Instance buffer.
	 * @param layout Instance layout.
	 * @param firstLocation First attribute location.
	 */
	public function addInstancedBuffer(
		buffer:VertexBuffer,
		layout:VertexLayout,
		firstLocation:Int
	):Void {

		bind();
		buffer.bind();

		var offset:Int = 0;
		var location:Int = firstLocation;

		for (attribute in layout.attributes) {

			GL.enableVertexAttribArray(location);

			GL.vertexAttribPointer(
				location,
				attribute.size,
				toGLType(attribute.type),
				attribute.normalized,
				layout.stride,
				offset
			);

			GL.vertexAttribDivisor(
				location,
				1
			);

			offset += attribute.size
				* VertexLayout.byteSizeOf(attribute.type);

			location++;
		}
	}

	/**
	 * Sets the element buffer used by this VAO.
	 *
	 * @param buffer Index buffer.
	 */
	public function setIndexBuffer(
		buffer:IndexBuffer
	):Void {

		indexBuffer = buffer;

		bind();
		buffer.bind();
	}

	/**
	 * Removes all vertex attribute bindings.
	 */
	public function clearAttributes(
		maxAttributes:Int = 16
	):Void {

		bind();

		for (i in 0...maxAttributes) {
			GL.disableVertexAttribArray(i);
		}
	}

	/**
	 * Returns true if an index buffer is attached.
	 */
	public inline function hasIndexBuffer():Bool {
		return indexBuffer != null;
	}

	/**
	 * Deletes the VAO.
	 */
	public function dispose():Void {
		if (_internal != null) {
			GL.deleteVertexArray(_internal);
			_internal = null;
		}
	}

	/**
	 * Converts a VertexAttributeType
	 * into the corresponding OpenGL enum.
	 */
	static function toGLType(
		type:VertexAttributeType
	):Int {

		return switch type {

			case FLOAT:
				GL.FLOAT;

			case HALF_FLOAT:
				GL.HALF_FLOAT;

			case BYTE:
				GL.BYTE;

			case SHORT:
				GL.SHORT;

			case INT:
				GL.INT;

			case UNSIGNED_BYTE:
				GL.UNSIGNED_BYTE;

			case UNSIGNED_SHORT:
				GL.UNSIGNED_SHORT;

			case UNSIGNED_INT:
				GL.UNSIGNED_INT;

			case INT_2_10_10_10_REV:
				GL.INT_2_10_10_10_REV;

			case UNSIGNED_INT_2_10_10_10_REV:
				GL.UNSIGNED_INT_2_10_10_10_REV;

			case UNSIGNED_INT_10F_11F_11F_REV:
				GL.UNSIGNED_INT_10F_11F_11F_REV;
		}
	}
}