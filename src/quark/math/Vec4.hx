package quark.math;

/**
 * Represents a four-dimensional vector (X, Y, Z, W).
 * Often used for homogeneous coordinates or color representations (RGBA).
 */
@:forward
abstract Vec4(BaseVec4) from BaseVec4 to BaseVec4 {
	/**
	 * Creates a new 4D Vector.
	 * @param x The X coordinate.
	 * @param y The Y coordinate.
	 * @param z The Z coordinate.
	 * @param w The W coordinate.
	 */
	public inline function new(x:Float, y:Float, z:Float, w:Float) {
		this = {
			x: x,
			y: y,
			z: z,
			w: w
		};
	}

	/** Returns a vector with components (0, 0, 0, 0). */
	public static inline function zero():Vec4
		return new Vec4(0, 0, 0, 0);

	/** Returns a vector with components (1, 1, 1, 1). */
	public static inline function one():Vec4
		return new Vec4(1, 1, 1, 1);

	/** Returns a unit vector pointing along the positive X-axis (1, 0, 0, 0). */
	public static inline function unitX():Vec4
		return new Vec4(1, 0, 0, 0);

	/** Returns a unit vector pointing along the positive Y-axis (0, 1, 0, 0). */
	public static inline function unitY():Vec4
		return new Vec4(0, 1, 0, 0);

	/** Returns a unit vector pointing along the positive Z-axis (0, 0, 1, 0). */
	public static inline function unitZ():Vec4
		return new Vec4(0, 0, 1, 0);

	/** Returns a unit vector pointing along the positive W-axis (0, 0, 0, 1). */
	public static inline function unitW():Vec4
		return new Vec4(0, 0, 0, 1);

	/** The magnitude (length) of the vector. */
	public var magnitude(get, never):Float;

	/** The squared magnitude of the vector. */
	public var magnitudeSq(get, never):Float;

	/** Returns a normalized copy of this vector (unit length). Returns zero vector if length is 0. */
	public var normalized(get, never):Vec4;

	inline function get_magnitude():Float
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);

	inline function get_magnitudeSq():Float
		return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;

	inline function get_normalized():Vec4 {
		var len = magnitude;
		return len == 0 ? zero() : (this : Vec4) / len;
	}

	/** Adds two vectors component-wise. */
	@:op(A + B) public inline function add(other:Vec4):Vec4
		return new Vec4(this.x + other.x, this.y + other.y, this.z + other.z, this.w + other.w);

	/** Subtracts `other` vector from this vector component-wise. */
	@:op(A - B) public inline function sub(other:Vec4):Vec4
		return new Vec4(this.x - other.x, this.y - other.y, this.z - other.z, this.w - other.w);

	/** Negates all components of the vector. */
	@:op(-A) public inline function neg():Vec4
		return new Vec4(-this.x, -this.y, -this.z, -this.w);

	/** Multiplies the vector by a scalar value. */
	@:op(A * B) public inline function mulScalar(k:Float):Vec4
		return new Vec4(this.x * k, this.y * k, this.z * k, this.w * k);

	/** Divides the vector by a scalar value. */
	@:op(A / B) public inline function divScalar(k:Float):Vec4
		return new Vec4(this.x / k, this.y / k, this.z / k, this.w / k);

	/** Compares two vectors for exact component equality. */
	@:op(A == B) public inline function equals(other:Vec4):Bool
		return this.x == other.x && this.y == other.y && this.z == other.z && this.w == other.w;

	/** Compares two vectors for inequality. */
	@:op(A != B) public inline function notEquals(other:Vec4):Bool
		return !equals(other);

	/** Calculates the dot product between this vector and `other`. */
	public inline function dot(other:Vec4):Float
		return this.x * other.x + this.y * other.y + this.z * other.z + this.w * other.w;

	/** Drops the W component and returns a Vec3 copy. */
	public inline function toVec3():Vec3
		return new Vec3(this.x, this.y, this.z);

	/** Returns a string representation of this vector. */
	public inline function toString():String
		return 'Vec4(${this.x}, ${this.y}, ${this.z}, ${this.w})';
}

@:structInit
private class BaseVec4 {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;
}
