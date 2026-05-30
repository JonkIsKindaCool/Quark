package quark.graphics;

import lime.graphics.ImageBuffer;
import lime.utils.UInt8Array;
import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import haxe.extern.EitherType;
import quark.graphics.TextureOptions;
import haxe.io.Bytes;

class Texture {
	public var _internal:GLTexture;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var options(default, null):TextureOptions;

	public static function empty(width:Int, height:Int, ?options:TextureOptions):Texture {
		var img = new Image(null, 0, 0, width, height);
		return new Texture(img, options);
	}

	public function new(data:EitherType<Image, Bytes>, ?options:TextureOptions) {
		this.options = resolveOptions(options);
		this._internal = GL.createTexture();

		GL.bindTexture(GL.TEXTURE_2D, _internal);

		applyOptions();

		var img:Image = null;

		if (data is Image) {
			img = cast data;
		} else {
			img = Image.fromBytes(data);
		}

		this.width = img.width;
		this.height = img.height;
		uploadImage(img);

		if (this.options.generateMipmaps)
			GL.generateMipmap(GL.TEXTURE_2D);

		GL.bindTexture(GL.TEXTURE_2D, null);
	}

	public function upload(image:Image):Void {
		bind();
		this.width = image.width;
		this.height = image.height;
		uploadImage(image);
		if (options.generateMipmaps)
			GL.generateMipmap(GL.TEXTURE_2D);
		unbind();
	}

	public function uploadRegion(image:Image, x:Int, y:Int):Void {
		bind();
		GL.texSubImage2D(GL.TEXTURE_2D, 0, x, y, image.width, image.height, resolveFormat(options.format), GL.UNSIGNED_BYTE, image.data);
		unbind();
	}

	public function bind(slot:Int = 0):Void {
		GL.activeTexture(GL.TEXTURE0 + slot);
		GL.bindTexture(GL.TEXTURE_2D, _internal);
	}

	public function unbind(slot:Int = 0):Void {
		GL.activeTexture(GL.TEXTURE0 + slot);
		GL.bindTexture(GL.TEXTURE_2D, null);
	}

	public function setFilter(min:TextureFilter, mag:TextureFilter):Void {
		bind();
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, resolveFilter(min));
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, resolveFilter(mag));
		unbind();
		options.minFilter = min;
		options.magFilter = mag;
	}

	public function setWrap(x:TextureWrap, y:TextureWrap):Void {
		bind();
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, resolveWrap(x));
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, resolveWrap(y));
		unbind();
		options.wrapX = x;
		options.wrapY = y;
	}

	public function destroy():Void {
		GL.deleteTexture(_internal);
		_internal = null;
	}

	function uploadImage(img:Image):Void {
		GL.texImage2D(GL.TEXTURE_2D, 0, resolveFormat(options.format), img.width, img.height, 0, resolveFormat(options.format), GL.UNSIGNED_BYTE, img.data);
	}

	function applyOptions():Void {
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, resolveFilter(options.minFilter));
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, resolveFilter(options.magFilter));
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, resolveWrap(options.wrapX));
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, resolveWrap(options.wrapY));
	}

	function resolveOptions(?options:TextureOptions):TextureOptions {
		if (options == null)
			options = {};
		if (options.minFilter == null)
			options.minFilter = LINEAR;
		if (options.magFilter == null)
			options.magFilter = LINEAR;
		if (options.wrapX == null)
			options.wrapX = CLAMP_TO_EDGE;
		if (options.wrapY == null)
			options.wrapY = CLAMP_TO_EDGE;
		if (options.format == null)
			options.format = RGBA;
		if (options.generateMipmaps == null)
			options.generateMipmaps = false;
		if (options.anisotropy == null)
			options.anisotropy = 1;
		return options;
	}

	function resolveFilter(filter:TextureFilter):Int {
		return switch filter {
			case NEAREST: GL.NEAREST;
			case LINEAR: GL.LINEAR;
			case NEAREST_MIPMAP_NEAREST: GL.NEAREST_MIPMAP_NEAREST;
			case NEAREST_MIPMAP_LINEAR: GL.NEAREST_MIPMAP_LINEAR;
			case LINEAR_MIPMAP_NEAREST: GL.LINEAR_MIPMAP_NEAREST;
			case LINEAR_MIPMAP_LINEAR: GL.LINEAR_MIPMAP_LINEAR;
		}
	}

	function resolveWrap(wrap:TextureWrap):Int {
		return switch wrap {
			case CLAMP_TO_EDGE: GL.CLAMP_TO_EDGE;
			case REPEAT: GL.REPEAT;
			case MIRRORED_REPEAT: GL.MIRRORED_REPEAT;
		}
	}

	function resolveFormat(format:TextureFormat):Int {
		return switch format {
			case RGBA: GL.RGBA;
			case RGB: GL.RGB;
			case RED: GL.RED;
			case RG: GL.RG;
			case DEPTH: GL.DEPTH_COMPONENT;
			case DEPTH_STENCIL: GL.DEPTH_STENCIL;
		}
	}
}
