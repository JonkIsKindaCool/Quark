package quark.graphics.texture;

typedef TextureOptions = {
	?minFilter:TextureFilter,
	?magFilter:TextureFilter,

	?wrapX:TextureWrap,
	?wrapY:TextureWrap,

	?format:TextureFormat,

	?type:TextureType,

	?generateMipmaps:Bool,

	?anisotropy:Int
}