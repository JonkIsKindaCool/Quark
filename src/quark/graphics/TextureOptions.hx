package quark.graphics;

enum TextureFilter {
    NEAREST;     
    LINEAR;   
    NEAREST_MIPMAP_NEAREST; 
    NEAREST_MIPMAP_LINEAR; 
    LINEAR_MIPMAP_NEAREST; 
    LINEAR_MIPMAP_LINEAR; 
}

enum TextureWrap {
    CLAMP_TO_EDGE;  
    REPEAT;     
    MIRRORED_REPEAT; 
}

enum TextureFormat {
    RGBA;    
    RGB;           
    RED;          
    RG;        
    DEPTH;       
    DEPTH_STENCIL;  
}

enum TextureType {
    TEXTURE_2D;
    TEXTURE_CUBE;    
}

typedef TextureOptions = {
    ?minFilter:TextureFilter, 
    ?magFilter:TextureFilter, 

    ?wrapX:TextureWrap,
    ?wrapY:TextureWrap,

    ?format:TextureFormat,
    ?type:TextureType,

    ?generateMipmaps:Bool,

    ?anisotropy:Int,
}

class TextureDefaults {
    public static final SPRITE:TextureOptions = {
        minFilter:      LINEAR,
        magFilter:      LINEAR,
        wrapX:          CLAMP_TO_EDGE,
        wrapY:          CLAMP_TO_EDGE,
        format:         RGBA,
        type:           TEXTURE_2D,
        generateMipmaps: false,
        anisotropy:     1
    }

    public static final PIXEL:TextureOptions = {
        minFilter:      NEAREST,
        magFilter:      NEAREST,
        wrapX:          CLAMP_TO_EDGE,
        wrapY:          CLAMP_TO_EDGE,
        format:         RGBA,
        type:           TEXTURE_2D,
        generateMipmaps: false,
        anisotropy:     1
    }

    public static final TILED:TextureOptions = {
        minFilter:      LINEAR_MIPMAP_LINEAR,
        magFilter:      LINEAR,
        wrapX:          REPEAT,
        wrapY:          REPEAT,
        format:         RGBA,
        type:           TEXTURE_2D,
        generateMipmaps: true,
        anisotropy:     4
    }

    public static final RENDER_TARGET:TextureOptions = {
        minFilter:      LINEAR,
        magFilter:      LINEAR,
        wrapX:          CLAMP_TO_EDGE,
        wrapY:          CLAMP_TO_EDGE,
        format:         RGBA,
        type:           TEXTURE_2D,
        generateMipmaps: false,
        anisotropy:     1
    }

    public static final SHADOW_MAP:TextureOptions = {
        minFilter:      NEAREST,
        magFilter:      NEAREST,
        wrapX:          CLAMP_TO_EDGE,
        wrapY:          CLAMP_TO_EDGE,
        format:         DEPTH,
        type:           TEXTURE_2D,
        generateMipmaps: false,
        anisotropy:     1
    }

    public static final SINGLE_CHANNEL:TextureOptions = {
        minFilter:      LINEAR,
        magFilter:      LINEAR,
        wrapX:          CLAMP_TO_EDGE,
        wrapY:          CLAMP_TO_EDGE,
        format:         RED,
        type:           TEXTURE_2D,
        generateMipmaps: false,
        anisotropy:     1
    }
}