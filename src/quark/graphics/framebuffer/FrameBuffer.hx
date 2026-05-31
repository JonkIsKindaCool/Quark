package quark.graphics.framebuffer;

import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLFramebuffer;
import quark.graphics.Texture;

/**
 * OpenGL framebuffer.
 *
 * A framebuffer allows rendering into textures or
 * renderbuffers instead of the default backbuffer.
 */
class Framebuffer {
	/**
	 * Native OpenGL framebuffer handle.
	 */
	public var handle(default, null):GLFramebuffer;

	/**
	 * Creates a new framebuffer.
	 */
	public function new() {
		handle = GL.createFramebuffer();
	}

	/**
	 * Binds the framebuffer.
	 */
	public inline function bind():Void {
		GL.bindFramebuffer(GL.FRAMEBUFFER, handle);
	}

	/**
	 * Unbinds the current framebuffer.
	 */
	public static inline function unbind():Void {
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
	}

	/**
	 * Attaches a texture to a framebuffer attachment.
	 *
	 * @param texture Texture to attach.
	 * @param attachment Attachment point.
	 */
	public function attachTexture(texture:Texture, ?attachment:Int):Void {
		bind();

		GL.framebufferTexture2D(GL.FRAMEBUFFER, attachment ?? GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture._internal, 0);
	}

	/**
	 * Attaches a renderbuffer to a framebuffer attachment.
	 *
	 * @param renderbuffer Renderbuffer to attach.
	 * @param attachment Attachment point.
	 */
	public function attachRenderbuffer(renderbuffer:RenderBuffer, attachment:Int):Void {
		bind();

		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, attachment ?? GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, renderbuffer.handle);
	}

	/**
	 * Returns true if the framebuffer is complete.
	 */
	public function isComplete():Bool {
		bind();

		return GL.checkFramebufferStatus(GL.FRAMEBUFFER) == GL.FRAMEBUFFER_COMPLETE;
	}

	/**
	 * Deletes the framebuffer.
	 */
	public function dispose():Void {
		if (handle != null) {
			GL.deleteFramebuffer(handle);
			handle = null;
		}
	}
}
