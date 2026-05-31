package quark.graphics.framebuffer;

import quark.utils.IDisposable;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLRenderbuffer;

/**
 * OpenGL renderbuffer.
 *
 * Renderbuffers are optimized GPU storage objects intended
 * for framebuffer attachments such as depth, stencil, or
 * depth-stencil buffers.
 */
class RenderBuffer implements IDisposable{
	/**
	 * Native OpenGL renderbuffer handle.
	 */
	public var handle(default, null):GLRenderbuffer;

	/**
	 * Internal storage format.
	 */
	public var format(default, null):Int;

	/**
	 * Width in pixels.
	 */
	public var width(default, null):Int;

	/**
	 * Height in pixels.
	 */
	public var height(default, null):Int;

	/**
	 * Creates a new renderbuffer.
	 *
	 * @param width Width in pixels.
	 * @param height Height in pixels.
	 * @param format Internal format.
	 */
	public function new(width:Int, height:Int, ?format:Int) {
		this.width = width;
		this.height = height;
		this.format = format ?? GL.DEPTH24_STENCIL8;

		handle = GL.createRenderbuffer();

		bind();

		GL.renderbufferStorage(
			GL.RENDERBUFFER,
			this.format,
			width,
			height
		);

		unbind();
	}

	/**
	 * Binds the renderbuffer.
	 */
	public inline function bind():Void {
		GL.bindRenderbuffer(GL.RENDERBUFFER, handle);
	}

	/**
	 * Unbinds the current renderbuffer.
	 */
	public static inline function unbind():Void {
		GL.bindRenderbuffer(GL.RENDERBUFFER, null);
	}

	/**
	 * Recreates the storage with a new size.
	 */
	public function resize(width:Int, height:Int):Void {
		this.width = width;
		this.height = height;

		bind();

		GL.renderbufferStorage(
			GL.RENDERBUFFER,
			format,
			width,
			height
		);
	}

	/**
	 * Deletes the renderbuffer.
	 */
	public function dispose():Void {
		if (handle != null) {
			GL.deleteRenderbuffer(handle);
			handle = null;
		}
	}
}