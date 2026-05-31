package quark.graphics.buffer;

import quark.utils.IDisposable;
import lime.utils.ArrayBufferView;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;

/**
 * Represents an OpenGL element/index buffer.
 *
 * Index buffers store vertex indices used by draw calls such as
 * `glDrawElements`, allowing vertices to be reused efficiently.
 */
class IndexBuffer implements IDisposable{

	/**
	 * Native OpenGL buffer handle.
	 */
	public var ebo(default, null):GLBuffer;

	/**
	 * Number of indices currently stored in the buffer.
	 */
	public var count(default, null):Int;

	/**
	 * Creates a new index buffer and uploads its data to the GPU.
	 *
	 * @param indices Index data to upload.
	 * @param indexByteSize Size of a single index in bytes.
	 *        Common values:
	 *        - 2 for UInt16 indices
	 *        - 4 for UInt32 indices
	 * @param dyn Whether the buffer will be updated frequently.
	 */
	public function new(indices:ArrayBufferView, indexByteSize:Int = 4, dyn:Bool = false) {
		ebo = GL.createBuffer();

		bind();

		GL.bufferData(
			GL.ELEMENT_ARRAY_BUFFER,
			indices,
			dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW
		);

		count = Std.int(indices.byteLength / indexByteSize);
	}

	/**
	 * Replaces the entire contents of the buffer.
	 *
	 * This may reallocate GPU memory depending on the driver.
	 *
	 * @param indices New index data.
	 * @param indexByteSize Size of a single index in bytes.
	 * @param dyn Whether the buffer should be optimized for frequent updates.
	 */
	public function setData(indices:ArrayBufferView, indexByteSize:Int = 4, dyn:Bool = true):Void {
		bind();

		GL.bufferData(
			GL.ELEMENT_ARRAY_BUFFER,
			indices,
			dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW
		);

		count = Std.int(indices.byteLength / indexByteSize);
	}

	/**
	 * Updates a portion of the buffer.
	 *
	 * Offset is specified in bytes.
	 *
	 * @param offset Byte offset into the buffer.
	 * @param data Data to upload.
	 */
	public function setSubData(offset:Int, data:ArrayBufferView):Void {
		bind();

		GL.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, offset, data);
	}

	/**
	 * Updates a portion of the buffer using an index offset.
	 *
	 * Assumes 32-bit indices (4 bytes each).
	 *
	 * @param indexOffset Index offset within the buffer.
	 * @param data Data to upload.
	 */
	public inline function setSubDataIndices(indexOffset:Int, data:ArrayBufferView):Void {
		setSubData(indexOffset * 4, data);
	}

	/**
	 * Binds this buffer as the active element array buffer.
	 */
	public inline function bind():Void {
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ebo);
	}

	/**
	 * Unbinds the currently active element array buffer.
	 */
	public static inline function unbind():Void {
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	/**
	 * Releases the GPU resources associated with this buffer.
	 *
	 * The buffer should not be used after disposal.
	 */
	public function dispose():Void {
		GL.deleteBuffer(ebo);
	}
}