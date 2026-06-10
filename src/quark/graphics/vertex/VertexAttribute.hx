package quark.graphics.vertex;

/**
 * Describes a single vertex attribute within a vertex layout.
 *
 * A vertex attribute defines how a specific piece of vertex data
 * is interpreted by the GPU and mapped to a GLShader input.
 *
 * Examples include:
 * - Position (vec2, vec3, vec4)
 * - Texture coordinates (vec2)
 * - Colors (vec4)
 * - Normals (vec3)
 * - Tangents (vec3 or vec4)
 */
typedef VertexAttribute = {

	/**
	 * Attribute name as declared in the GLShader.
	 *
	 * Example:
	 * ```glsl
	 * layout(location = 0) in vec3 aPosition;
	 * ```
	 *
	 * The corresponding attribute name would be:
	 * `"aPosition"`
	 */
	name:String,

	/**
	 * Number of components contained in the attribute.
	 *
	 * Common values:
	 * - 1 → float
	 * - 2 → vec2
	 * - 3 → vec3
	 * - 4 → vec4
	 */
	size:Int,

	/**
	 * Whether integer values should be normalized
	 * when converted to floating-point values.
	 *
	 * For example, unsigned bytes can be automatically
	 * converted from the range 0-255 into 0.0-1.0.
	 */
	normalized:Bool,

	/**
	 * Data type used by the attribute.
	 */
	type:VertexAttributeType
}