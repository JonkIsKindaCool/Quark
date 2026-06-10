package quark.graphics.buffer;

import lime.utils.Float32Array;
import quark.utils.IDisposable;
import quark.app.App;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;

/**
 * GPU vertex buffer.
 *
 * Stores vertex data inside an OpenGL VBO.
 */
class VertexBuffer implements IDisposable {
	/**
	 * Native OpenGL handle.
	 */
	public var handle(default, null):GLBuffer;

	/**
	 * Buffer size in bytes.
	 */
	public var size(default, null):Int;

	/**
	 * Usage hint.
	 */
	public var usage(default, null):BufferUsage;

	/**
	 * Creates a new vertex buffer.
	 *
	 * @param data Initial vertex data.
	 * @param usage Buffer usage hint.
	 */
	public function new(data:ArrayBufferView, usage:BufferUsage = BufferUsage.STATIC_DRAW) {
		this.usage = usage;
		this.size = data.byteLength;

		handle = GL.createBuffer();

		bind();
		GL.bufferData(GL.ARRAY_BUFFER, data, switch (usage) {
			case STATIC_DRAW: GL.STATIC_DRAW;
			case DYNAMIC_DRAW: GL.DYNAMIC_DRAW;
			case STREAM_DRAW: GL.STREAM_DRAW;
		});
		unbind();
	}

	/**
	 * Binds the buffer.
	 */
	public inline function bind():Void {
		GL.bindBuffer(GL.ARRAY_BUFFER, handle);
	}

	/**
	 * Unbinds the current vertex buffer.
	 */
	public static inline function unbind():Void {
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	/**
	 * Replaces the entire contents of the buffer.
	 */
	public function setData(data:ArrayBufferView):Void {
		size = data.byteLength;

		bind();
		GL.bufferData(GL.ARRAY_BUFFER, data, switch (usage) {
			case STATIC_DRAW: GL.STATIC_DRAW;
			case DYNAMIC_DRAW: GL.DYNAMIC_DRAW;
			case STREAM_DRAW: GL.STREAM_DRAW;
		});
	}

	/**
	 * Updates a portion of the buffer.
	 *
	 * @param byteOffset Offset in bytes.
	 * @param data Data to upload.
	 */
	public function setSubData(byteOffset:Int, data:ArrayBufferView, ?length:Int):Void {
		bind();
		if (length != null && length > 0) {
			GL.bufferSubData(GL.ARRAY_BUFFER, byteOffset, data, 0, length * 4);
		} else {
			GL.bufferSubData(GL.ARRAY_BUFFER, byteOffset, data);
		}
	}

	/**
	 * Deletes the underlying OpenGL buffer.
	 */
	public function dispose():Void {
		if (handle != null) {
			GL.deleteBuffer(handle);
			handle = null;
		}
	}
}
