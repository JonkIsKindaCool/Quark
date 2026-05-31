package quark.graphics;

/**
 * Texture filtering modes.
 *
 * Filtering controls how texels are sampled when a texture
 * is displayed larger or smaller than its original resolution.
 */
enum TextureFilter {

	/**
	 * Nearest-neighbor sampling.
	 *
	 * Produces sharp pixel edges and is commonly used
	 * for pixel art.
	 */
	NEAREST;

	/**
	 * Linear interpolation sampling.
	 *
	 * Produces smoother results by blending neighboring texels.
	 */
	LINEAR;

	/**
	 * Uses the nearest mipmap level and nearest texel.
	 */
	NEAREST_MIPMAP_NEAREST;

	/**
	 * Blends between mipmap levels while using nearest texel sampling.
	 */
	NEAREST_MIPMAP_LINEAR;

	/**
	 * Uses linear filtering within the nearest mipmap level.
	 */
	LINEAR_MIPMAP_NEAREST;

	/**
	 * Uses linear filtering and smoothly blends between mipmap levels.
	 *
	 * Often provides the highest visual quality.
	 */
	LINEAR_MIPMAP_LINEAR;
}

/**
 * Texture coordinate wrapping modes.
 *
 * Wrapping determines how texture coordinates outside
 * the 0-1 range are handled.
 */
enum TextureWrap {

	/**
	 * Clamps coordinates to the texture edges.
	 */
	CLAMP_TO_EDGE;

	/**
	 * Repeats the texture infinitely.
	 */
	REPEAT;

	/**
	 * Repeats the texture while mirroring every repetition.
	 */
	MIRRORED_REPEAT;
}

/**
 * Texture pixel formats.
 *
 * Determines how texture data is stored internally.
 */
enum TextureFormat {

	/**
	 * Red, green, blue and alpha channels.
	 */
	RGBA;

	/**
	 * Red, green and blue channels.
	 */
	RGB;

	/**
	 * Single red channel.
	 */
	RED;

	/**
	 * Red and green channels.
	 */
	RG;

	/**
	 * Depth texture format.
	 */
	DEPTH;

	/**
	 * Combined depth and stencil format.
	 */
	DEPTH_STENCIL;
}

/**
 * Supported texture types.
 */
enum TextureType {

	/**
	 * Standard 2D texture.
	 */
	TEXTURE_2D;

	/**
	 * Cube map texture.
	 *
	 * Typically used for skyboxes, reflections
	 * and environment mapping.
	 */
	TEXTURE_CUBE;
}

/**
 * Describes texture creation and sampling options.
 */
typedef TextureOptions = {

	/**
	 * Minification filter.
	 *
	 * Used when the texture is rendered smaller
	 * than its original size.
	 */
	?minFilter:TextureFilter,

	/**
	 * Magnification filter.
	 *
	 * Used when the texture is rendered larger
	 * than its original size.
	 */
	?magFilter:TextureFilter,

	/**
	 * Horizontal wrapping mode.
	 */
	?wrapX:TextureWrap,

	/**
	 * Vertical wrapping mode.
	 */
	?wrapY:TextureWrap,

	/**
	 * Internal texture format.
	 */
	?format:TextureFormat,

	/**
	 * Texture type.
	 */
	?type:TextureType,

	/**
	 * Whether mipmaps should be generated automatically.
	 */
	?generateMipmaps:Bool,

	/**
	 * Preferred anisotropic filtering level.
	 *
	 * Requires extension support.
	 */
	?anisotropy:Int,
}

/**
 * Collection of predefined texture configurations.
 *
 * These presets cover the most common texture use cases.
 */
class TextureDefaults {

	/**
	 * Default settings for regular sprites and UI textures.
	 */
	public static final SPRITE:TextureOptions = {
		minFilter: LINEAR,
		magFilter: LINEAR,
		wrapX: CLAMP_TO_EDGE,
		wrapY: CLAMP_TO_EDGE,
		format: RGBA,
		type: TEXTURE_2D,
		generateMipmaps: false,
		anisotropy: 1
	}

	/**
	 * Optimized settings for pixel-art textures.
	 *
	 * Preserves sharp edges without filtering.
	 */
	public static final PIXEL:TextureOptions = {
		minFilter: NEAREST,
		magFilter: NEAREST,
		wrapX: CLAMP_TO_EDGE,
		wrapY: CLAMP_TO_EDGE,
		format: RGBA,
		type: TEXTURE_2D,
		generateMipmaps: false,
		anisotropy: 1
	}

	/**
	 * Settings for repeating tiled textures.
	 *
	 * Includes mipmaps and anisotropic filtering.
	 */
	public static final TILED:TextureOptions = {
		minFilter: LINEAR_MIPMAP_LINEAR,
		magFilter: LINEAR,
		wrapX: REPEAT,
		wrapY: REPEAT,
		format: RGBA,
		type: TEXTURE_2D,
		generateMipmaps: true,
		anisotropy: 4
	}

	/**
	 * Settings for framebuffer color attachments
	 * and render targets.
	 */
	public static final RENDER_TARGET:TextureOptions = {
		minFilter: LINEAR,
		magFilter: LINEAR,
		wrapX: CLAMP_TO_EDGE,
		wrapY: CLAMP_TO_EDGE,
		format: RGBA,
		type: TEXTURE_2D,
		generateMipmaps: false,
		anisotropy: 1
	}

	/**
	 * Settings for shadow maps.
	 *
	 * Uses a depth texture with nearest filtering.
	 */
	public static final SHADOW_MAP:TextureOptions = {
		minFilter: NEAREST,
		magFilter: NEAREST,
		wrapX: CLAMP_TO_EDGE,
		wrapY: CLAMP_TO_EDGE,
		format: DEPTH,
		type: TEXTURE_2D,
		generateMipmaps: false,
		anisotropy: 1
	}

	/**
	 * Settings for single-channel textures.
	 *
	 * Commonly used for masks, lookup tables,
	 * font atlases and grayscale data.
	 */
	public static final SINGLE_CHANNEL:TextureOptions = {
		minFilter: LINEAR,
		magFilter: LINEAR,
		wrapX: CLAMP_TO_EDGE,
		wrapY: CLAMP_TO_EDGE,
		format: RED,
		type: TEXTURE_2D,
		generateMipmaps: false,
		anisotropy: 1
	}
}