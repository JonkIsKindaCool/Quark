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

	/**
	 * Sets all four components of this vector.
	 * @param x The new X component.
	 * @param y The new Y component.
	 * @param z The new Z component.
	 * @param w The new W component.
	 * @return This vector after modification.
	 */
	public inline function setXYZW(x:Float, y:Float, z:Float, w:Float):Vec4 {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		return cast this;
	}

	/**
	 * Adds `other` to this vector in place.
	 * @param other The vector to add.
	 * @return This vector after modification.
	 */
	public inline function addEq(other:Vec4):Vec4 {
		this.x += other.x;
		this.y += other.y;
		this.z += other.z;
		this.w += other.w;
		return cast this;
	}

	/**
	 * Subtracts `other` from this vector in place.
	 * @param other The vector to subtract.
	 * @return This vector after modification.
	 */
	public inline function subEq(other:Vec4):Vec4 {
		this.x -= other.x;
		this.y -= other.y;
		this.z -= other.z;
		this.w -= other.w;
		return cast this;
	}

	/**
	 * Multiplies this vector by a scalar in place.
	 * @param k The scalar factor.
	 * @return This vector after modification.
	 */
	public inline function mulScalarEq(k:Float):Vec4 {
		this.x *= k;
		this.y *= k;
		this.z *= k;
		this.w *= k;
		return cast this;
	}

	/**
	 * Divides this vector by a scalar in place.
	 * @param k The scalar divisor.
	 * @return This vector after modification.
	 */
	public inline function divScalarEq(k:Float):Vec4 {
		this.x /= k;
		this.y /= k;
		this.z /= k;
		this.w /= k;
		return cast this;
	}

	/**
	 * Negates all components of this vector in place.
	 * @return This vector after modification.
	 */
	public inline function negEq():Vec4 {
		this.x = -this.x;
		this.y = -this.y;
		this.z = -this.z;
		this.w = -this.w;
		return cast this;
	}

	/**
	 * Normalizes this vector to unit length in place.
	 * If the length is zero the vector remains unchanged.
	 * @return This vector after modification.
	 */
	public inline function normalizeEq():Vec4 {
		var len:Float = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
		if (len != 0) {
			this.x /= len;
			this.y /= len;
			this.z /= len;
			this.w /= len;
		}
		return cast this;
	}

	/**
	 * Linearly interpolates this vector toward `to` by factor `t` in place.
	 * @param to The target vector.
	 * @param t The interpolation factor (0–1).
	 * @return This vector after modification.
	 */
	public inline function lerpEq(to:Vec4, t:Float):Vec4 {
		this.x += (to.x - this.x) * t;
		this.y += (to.y - this.y) * t;
		this.z += (to.z - this.z) * t;
		this.w += (to.w - this.w) * t;
		return cast this;
	}

	/**
	 * Applies Math.abs to each component in place.
	 * @return This vector after modification.
	 */
	public inline function absEq():Vec4 {
		this.x = Math.abs(this.x);
		this.y = Math.abs(this.y);
		this.z = Math.abs(this.z);
		this.w = Math.abs(this.w);
		return cast this;
	}

	/**
	 * Keeps only the minimum component values between this and `other` in place.
	 * @param other The vector to compare against.
	 * @return This vector after modification.
	 */
	public inline function minComponentEq(other:Vec4):Vec4 {
		this.x = Math.min(this.x, other.x);
		this.y = Math.min(this.y, other.y);
		this.z = Math.min(this.z, other.z);
		this.w = Math.min(this.w, other.w);
		return cast this;
	}

	/**
	 * Keeps only the maximum component values between this and `other` in place.
	 * @param other The vector to compare against.
	 * @return This vector after modification.
	 */
	public inline function maxComponentEq(other:Vec4):Vec4 {
		this.x = Math.max(this.x, other.x);
		this.y = Math.max(this.y, other.y);
		this.z = Math.max(this.z, other.z);
		this.w = Math.max(this.w, other.w);
		return cast this;
	}
}

@:structInit
private class BaseVec4 {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;
}
