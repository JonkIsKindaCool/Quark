package quark.graphics;

import quark.graphics.VertexAttributeType;

/**
 * Describes the structure of a vertex.
 *
 * A VertexLayout defines the order, size and type of attributes
 * stored in a vertex buffer and how they map to shader inputs.
 *
 * The layout stride is automatically calculated from all attributes.
 */
abstract VertexLayout(Array<VertexAttribute>) from Array<VertexAttribute> to Array<VertexAttribute> {

	/**
	 * 2D position only.
	 *
	 * Attributes:
	 * - position (vec2)
	 */
	public static final POS2:VertexLayout = [
		{ name: "position", size: 2, type: FLOAT, normalized: false }
	];

	/**
	 * 3D position only.
	 *
	 * Attributes:
	 * - position (vec3)
	 */
	public static final POS3:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false }
	];

	/**
	 * 2D position and texture coordinates.
	 *
	 * Attributes:
	 * - position (vec2)
	 * - uv (vec2)
	 */
	public static final POS2_UV2:VertexLayout = [
		{ name: "position", size: 2, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false }
	];

	/**
	 * 3D position and texture coordinates.
	 *
	 * Attributes:
	 * - position (vec3)
	 * - uv (vec2)
	 */
	public static final POS3_UV2:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false }
	];

	/**
	 * 2D position and color.
	 *
	 * Attributes:
	 * - position (vec2)
	 * - color (vec4)
	 */
	public static final POS2_COL4:VertexLayout = [
		{ name: "position", size: 2, type: FLOAT, normalized: false },
		{ name: "color", size: 4, type: FLOAT, normalized: true }
	];

	/**
	 * 3D position and color.
	 *
	 * Attributes:
	 * - position (vec3)
	 * - color (vec4)
	 */
	public static final POS3_COL4:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false },
		{ name: "color", size: 4, type: FLOAT, normalized: true }
	];

	/**
	 * 2D position, texture coordinates and color.
	 *
	 * Attributes:
	 * - position (vec2)
	 * - uv (vec2)
	 * - color (vec4)
	 */
	public static final POS2_UV2_COL4:VertexLayout = [
		{ name: "position", size: 2, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false },
		{ name: "color", size: 4, type: FLOAT, normalized: true }
	];

	/**
	 * 3D position, texture coordinates and color.
	 *
	 * Attributes:
	 * - position (vec3)
	 * - uv (vec2)
	 * - color (vec4)
	 */
	public static final POS3_UV2_COL4:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false },
		{ name: "color", size: 4, type: FLOAT, normalized: true }
	];

	/**
	 * Standard static mesh layout.
	 *
	 * Attributes:
	 * - position (vec3)
	 * - uv (vec2)
	 * - normal (vec3)
	 */
	public static final POS3_UV2_NORMAL3:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false },
		{ name: "normal", size: 3, type: FLOAT, normalized: false }
	];

	/**
	 * Static mesh layout with vertex colors.
	 *
	 * Attributes:
	 * - position (vec3)
	 * - uv (vec2)
	 * - normal (vec3)
	 * - color (vec4)
	 */
	public static final POS3_UV2_NORMAL3_COL4:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false },
		{ name: "normal", size: 3, type: FLOAT, normalized: false },
		{ name: "color", size: 4, type: FLOAT, normalized: true }
	];

	/**
	 * Mesh layout with tangent information.
	 *
	 * Useful for normal mapping.
	 *
	 * Attributes:
	 * - position (vec3)
	 * - uv (vec2)
	 * - normal (vec3)
	 * - tangent (vec3)
	 */
	public static final POS3_UV2_NORMAL3_TANGENT3:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false },
		{ name: "normal", size: 3, type: FLOAT, normalized: false },
		{ name: "tangent", size: 3, type: FLOAT, normalized: false }
	];

	/**
	 * Skeletal animation layout.
	 *
	 * Attributes:
	 * - position (vec3)
	 * - uv (vec2)
	 * - normal (vec3)
	 * - bone_indices (uvec4)
	 * - bone_weights (vec4)
	 */
	public static final POS3_UV2_NORMAL3_BONES:VertexLayout = [
		{ name: "position", size: 3, type: FLOAT, normalized: false },
		{ name: "uv", size: 2, type: FLOAT, normalized: false },
		{ name: "normal", size: 3, type: FLOAT, normalized: false },
		{ name: "bone_indices", size: 4, type: UNSIGNED_SHORT, normalized: false },
		{ name: "bone_weights", size: 4, type: FLOAT, normalized: false }
	];

	/**
	 * Creates a custom vertex layout.
	 *
	 * @param attributes Vertex attributes.
	 */
	public inline function new(attributes:Array<VertexAttribute>) {
		this = attributes;
	}

	/**
	 * List of attributes contained in the layout.
	 */
	public var attributes(get, never):Array<VertexAttribute>;

	inline function get_attributes()
		return this;

	/**
	 * Size of a single vertex in bytes.
	 */
	public var stride(get, never):Int;

	function get_stride():Int {
		var s:Int = 0;

		for (attr in this)
			s += attr.size * byteSizeOf(attr.type);

		return s;
	}

	/**
	 * Returns the byte offset of an attribute within a vertex.
	 *
	 * @param attributeName Attribute name.
	 * @return Offset in bytes or -1 if not found.
	 */
	public function offsetOf(attributeName:String):Int {
		var offset:Int = 0;

		for (attr in this) {
			if (attr.name == attributeName)
				return offset;

			offset += attr.size * byteSizeOf(attr.type);
		}

		return -1;
	}

	/**
	 * Returns the size in bytes of a vertex attribute type.
	 *
	 * @param type Attribute type.
	 * @return Size in bytes.
	 */
	public static function byteSizeOf(type:VertexAttributeType):Int {
		return switch type {
			case FLOAT: 4;
			case HALF_FLOAT: 2;

			case BYTE | UNSIGNED_BYTE: 1;
			case SHORT | UNSIGNED_SHORT: 2;
			case INT | UNSIGNED_INT: 4;

			case INT_2_10_10_10_REV: 4;
			case UNSIGNED_INT_2_10_10_10_REV: 4;
			case UNSIGNED_INT_10F_11F_11F_REV: 4;
		}
	}
}