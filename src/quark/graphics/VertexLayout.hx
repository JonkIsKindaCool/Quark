package quark.graphics;

import quark.graphics.VertexAttributeType;

abstract VertexLayout(Array<VertexAttribute>) from Array<VertexAttribute> to Array<VertexAttribute> {
    public static final POS2:VertexLayout = [
        { name: "position", size: 2, type: FLOAT, normalized: false }
    ];

    public static final POS3:VertexLayout = [
        { name: "position", size: 3, type: FLOAT, normalized: false }
    ];

    public static final POS2_UV2:VertexLayout = [
        { name: "position", size: 2, type: FLOAT, normalized: false },
        { name: "uv",       size: 2, type: FLOAT, normalized: false }
    ];

    public static final POS3_UV2:VertexLayout = [
        { name: "position", size: 3, type: FLOAT, normalized: false },
        { name: "uv",       size: 2, type: FLOAT, normalized: false }
    ];

    public static final POS2_COL4:VertexLayout = [
        { name: "position", size: 2, type: FLOAT,         normalized: false },
        { name: "color",    size: 4, type: UNSIGNED_BYTE, normalized: true  }
    ];

    public static final POS3_COL4:VertexLayout = [
        { name: "position", size: 3, type: FLOAT,         normalized: false },
        { name: "color",    size: 4, type: UNSIGNED_BYTE, normalized: true  }
    ];

    public static final POS2_UV2_COL4:VertexLayout = [
        { name: "position", size: 2, type: FLOAT,         normalized: false },
        { name: "uv",       size: 2, type: FLOAT,         normalized: false },
        { name: "color",    size: 4, type: UNSIGNED_BYTE, normalized: true  }
    ];

    public static final POS3_UV2_COL4:VertexLayout = [
        { name: "position", size: 3, type: FLOAT,         normalized: false },
        { name: "uv",       size: 2, type: FLOAT,         normalized: false },
        { name: "color",    size: 4, type: UNSIGNED_BYTE, normalized: true  }
    ];

    public static final POS3_UV2_NORMAL3:VertexLayout = [
        { name: "position", size: 3, type: FLOAT, normalized: false },
        { name: "uv",       size: 2, type: FLOAT, normalized: false },
        { name: "normal",   size: 3, type: FLOAT, normalized: false }
    ];

    public static final POS3_UV2_NORMAL3_COL4:VertexLayout = [
        { name: "position", size: 3, type: FLOAT,         normalized: false },
        { name: "uv",       size: 2, type: FLOAT,         normalized: false },
        { name: "normal",   size: 3, type: FLOAT,         normalized: false },
        { name: "color",    size: 4, type: UNSIGNED_BYTE, normalized: true  }
    ];

    public static final POS3_UV2_NORMAL3_TANGENT3:VertexLayout = [
        { name: "position", size: 3, type: FLOAT, normalized: false },
        { name: "uv",       size: 2, type: FLOAT, normalized: false },
        { name: "normal",   size: 3, type: FLOAT, normalized: false },
        { name: "tangent",  size: 3, type: FLOAT, normalized: false }
    ];

    public static final POS3_UV2_NORMAL3_BONES:VertexLayout = [
        { name: "position",     size: 3, type: FLOAT,          normalized: false },
        { name: "uv",           size: 2, type: FLOAT,          normalized: false },
        { name: "normal",       size: 3, type: FLOAT,          normalized: false },
        { name: "bone_indices", size: 4, type: UNSIGNED_SHORT, normalized: false },
        { name: "bone_weights", size: 4, type: FLOAT,          normalized: false }
    ];

    public inline function new(attributes:Array<VertexAttribute>) {
        this = attributes;
    }

    public var attributes(get, never):Array<VertexAttribute>;

    inline function get_attributes() return this;

    public var stride(get, never):Int;

    function get_stride():Int {
        var s:Int = 0;

        for (attr in this)
            s += attr.size * byteSizeOf(attr.type);
        
        return s;
    }

    public function offsetOf(attributeName:String):Int {
        var offset:Int = 0;

        for (attr in this) {
            if (attr.name == attributeName) return offset;
            offset += attr.size * byteSizeOf(attr.type);
        }

        return -1;
    }

    public static function byteSizeOf(type:VertexAttributeType):Int {
        return switch type {
            case FLOAT:                         4;
            case HALF_FLOAT:                    2;
            case BYTE | UNSIGNED_BYTE:          1;
            case SHORT | UNSIGNED_SHORT:        2;
            case INT | UNSIGNED_INT:            4;
            case INT_2_10_10_10_REV:            4;
            case UNSIGNED_INT_2_10_10_10_REV:   4;
            case UNSIGNED_INT_10F_11F_11F_REV:  4;
        }
    }
}