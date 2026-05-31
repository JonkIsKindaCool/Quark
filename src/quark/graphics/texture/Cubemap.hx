package quark.graphics.texture;

import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;

/**
 * OpenGL cubemap texture.
 *
 * Face order:
 *
 * +X Right
 * -X Left
 * +Y Top
 * -Y Bottom
 * +Z Front
 * -Z Back
 */
class Cubemap {
	public var _internal(default, null):GLTexture;

	public var size(default, null):Int;

	public function new(
		right:Image,
		left:Image,
		top:Image,
		bottom:Image,
		front:Image,
		back:Image
	) {
		_internal = GL.createTexture();

		bind();

		uploadFace(GL.TEXTURE_CUBE_MAP_POSITIVE_X, right);
		uploadFace(GL.TEXTURE_CUBE_MAP_NEGATIVE_X, left);

		uploadFace(GL.TEXTURE_CUBE_MAP_POSITIVE_Y, top);
		uploadFace(GL.TEXTURE_CUBE_MAP_NEGATIVE_Y, bottom);

		uploadFace(GL.TEXTURE_CUBE_MAP_POSITIVE_Z, front);
		uploadFace(GL.TEXTURE_CUBE_MAP_NEGATIVE_Z, back);

		GL.texParameteri(
			GL.TEXTURE_CUBE_MAP,
			GL.TEXTURE_MIN_FILTER,
			GL.LINEAR
		);

		GL.texParameteri(
			GL.TEXTURE_CUBE_MAP,
			GL.TEXTURE_MAG_FILTER,
			GL.LINEAR
		);

		GL.texParameteri(
			GL.TEXTURE_CUBE_MAP,
			GL.TEXTURE_WRAP_S,
			GL.CLAMP_TO_EDGE
		);

		GL.texParameteri(
			GL.TEXTURE_CUBE_MAP,
			GL.TEXTURE_WRAP_T,
			GL.CLAMP_TO_EDGE
		);

		GL.texParameteri(
			GL.TEXTURE_CUBE_MAP,
			GL.TEXTURE_WRAP_R,
			GL.CLAMP_TO_EDGE
		);

		size = right.width;

		unbind();
	}

	inline function uploadFace(
		target:Int,
		image:Image
	):Void {
		GL.texImage2D(
			target,
			0,
			GL.RGBA,
			image.width,
			image.height,
			0,
			GL.RGBA,
			GL.UNSIGNED_BYTE,
			image.data
		);
	}

	public inline function bind(slot:Int = 0):Void {
		GL.activeTexture(GL.TEXTURE0 + slot);
		GL.bindTexture(
			GL.TEXTURE_CUBE_MAP,
			_internal
		);
	}

	public inline function unbind(slot:Int = 0):Void {
		GL.activeTexture(GL.TEXTURE0 + slot);
		GL.bindTexture(
			GL.TEXTURE_CUBE_MAP,
			null
		);
	}

	public function destroy():Void {
		if (_internal != null) {
			GL.deleteTexture(_internal);
			_internal = null;
		}
	}
}