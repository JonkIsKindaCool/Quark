package quark.graphics.buffer;

import quark.utils.IDisposable;
import quark.app.App;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;

/**
 * OpenGL Uniform Buffer Object.
 *
 * Requires OpenGL 3.1+ or WebGL 2.
 */
class UniformBuffer implements IDisposable{
	/**
	 * Native OpenGL handle.
	 */
	public var handle(default, null):GLBuffer;

	/**
	 * Buffer size in bytes.
	 */
	public var size(default, null):Int;

	/**
	 * Binding point.
	 */
	public var binding(default, null):Int;

	/**
	 * Creates a new uniform buffer.
	 *
	 * @param data Initial data.
	 * @param binding Binding index.
	 * @param usage Buffer usage hint.
	 */
	public function new(data:ArrayBufferView, binding:Int, usage:BufferUsage = BufferUsage.DYNAMIC_DRAW) {
		this.binding = binding;
		this.size = data.byteLength;

		handle = GL.createBuffer();

		bind();

		GL.bufferData(GL.UNIFORM_BUFFER, data, switch (usage) {
			case STATIC_DRAW: GL.STATIC_DRAW;
			case DYNAMIC_DRAW: GL.DYNAMIC_DRAW;
			case STREAM_DRAW: GL.STREAM_DRAW;
		});

		GL.bindBufferBase(GL.UNIFORM_BUFFER, binding, handle);

		unbind();
	}

	/**
	 * Binds this uniform buffer.
	 */
	public inline function bind():Void {
		GL.bindBuffer(GL.UNIFORM_BUFFER, handle);
	}

	/**
	 * Unbinds the current uniform buffer.
	 */
	public static inline function unbind():Void {
		GL.bindBuffer(GL.UNIFORM_BUFFER, null);
	}

	/**
	 * Uploads an entirely new block of data.
	 */
	public function setData(data:ArrayBufferView, usage:BufferUsage = BufferUsage.DYNAMIC_DRAW):Void {
		size = data.byteLength;

		bind();

		GL.bufferData(GL.UNIFORM_BUFFER, data, switch (usage) {
			case STATIC_DRAW: GL.STATIC_DRAW;
			case DYNAMIC_DRAW: GL.DYNAMIC_DRAW;
			case STREAM_DRAW: GL.STREAM_DRAW;
		});
	}

	/**
	 * Updates part of the buffer.
	 *
	 * @param byteOffset Offset in bytes.
	 * @param data Data to upload.
	 */
	public function setSubData(byteOffset:Int, data:ArrayBufferView):Void {
		bind();

		GL.bufferSubData(GL.UNIFORM_BUFFER, byteOffset, data);
	}

	/**
	 * Rebinds the buffer to a new binding point.
	 */
	public function bindBase(binding:Int):Void {
		this.binding = binding;

		GL.bindBufferBase(GL.UNIFORM_BUFFER, binding, handle);
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
