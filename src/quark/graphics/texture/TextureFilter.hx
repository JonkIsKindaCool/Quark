package quark.graphics.texture;

/**
 * Texture filtering modes.
 */
enum TextureFilter {
	NEAREST;
	LINEAR;
	NEAREST_MIPMAP_NEAREST;
	NEAREST_MIPMAP_LINEAR;
	LINEAR_MIPMAP_NEAREST;
	LINEAR_MIPMAP_LINEAR;
}