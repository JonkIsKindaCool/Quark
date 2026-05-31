package quark.graphics.vertex;

/**
 * Supported vertex attribute data types.
 *
 * These types determine how vertex data is stored in memory
 * and interpreted by the GPU when configuring vertex attributes.
 */
enum VertexAttributeType {

	/**
	 * 32-bit floating-point value.
	 *
	 * Most commonly used for positions, texture coordinates,
	 * normals and other vertex data.
	 */
	FLOAT;

	/**
	 * 16-bit floating-point value.
	 *
	 * Uses less memory than FLOAT while sacrificing precision.
	 */
	HALF_FLOAT;

	/**
	 * Signed 8-bit integer.
	 *
	 * Range: -128 to 127.
	 */
	BYTE;

	/**
	 * Signed 16-bit integer.
	 *
	 * Range: -32768 to 32767.
	 */
	SHORT;

	/**
	 * Signed 32-bit integer.
	 *
	 * Range: -2147483648 to 2147483647.
	 */
	INT;

	/**
	 * Unsigned 8-bit integer.
	 *
	 * Range: 0 to 255.
	 */
	UNSIGNED_BYTE;

	/**
	 * Unsigned 16-bit integer.
	 *
	 * Range: 0 to 65535.
	 */
	UNSIGNED_SHORT;

	/**
	 * Unsigned 32-bit integer.
	 *
	 * Range: 0 to 4294967295.
	 */
	UNSIGNED_INT;

	/**
	 * Packed signed 2:10:10:10 format.
	 *
	 * Stores four components inside a single 32-bit integer.
	 * Frequently used for compressed normals, tangents
	 * and orientation data.
	 */
	INT_2_10_10_10_REV;

	/**
	 * Packed unsigned 2:10:10:10 format.
	 *
	 * Stores four unsigned components inside a single
	 * 32-bit integer.
	 */
	UNSIGNED_INT_2_10_10_10_REV;

	/**
	 * Packed floating-point 10:11:11 format.
	 *
	 * Stores three floating-point values in a single
	 * 32-bit integer and is commonly used for HDR data
	 * and compressed vector storage.
	 */
	UNSIGNED_INT_10F_11F_11F_REV;
}