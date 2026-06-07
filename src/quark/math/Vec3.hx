package quark.math;

/**
 * Represents a three-dimensional vector (X, Y, Z).
 */
@:forward
abstract Vec3(BaseVec3) from BaseVec3 to BaseVec3 {
	/**
	 * Creates a new 3D Vector.
	 * @param x The X coordinate.
	 * @param y The Y coordinate.
	 * @param z The Z coordinate.
	 */
	public inline function new(x:Float, y:Float, z:Float) {
		this = {x: x, y: y, z: z};
	}

	/** Returns a vector with components (0, 0, 0). */
	public static inline function zero():Vec3
		return new Vec3(0, 0, 0);

	/** Returns a vector with components (1, 1, 1). */
	public static inline function one():Vec3
		return new Vec3(1, 1, 1);

	/** Returns a unit vector pointing along the positive X-axis (1, 0, 0). */
	public static inline function unitX():Vec3
		return new Vec3(1, 0, 0);

	/** Returns a unit vector pointing along the positive Y-axis (0, 1, 0). */
	public static inline function unitY():Vec3
		return new Vec3(0, 1, 0);

	/** Returns a unit vector pointing along the positive Z-axis (0, 0, 1). */
	public static inline function unitZ():Vec3
		return new Vec3(0, 0, 1);

	/** The magnitude (length) of the vector. */
	public var magnitude(get, never):Float;

	/** The squared magnitude of the vector. Useful for high-performance length comparisons. */
	public var magnitudeSq(get, never):Float;

	/** Returns a normalized copy of this vector (unit length). Returns zero vector if length is 0. */
	public var normalized(get, never):Vec3;

	inline function get_magnitude():Float
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);

	inline function get_magnitudeSq():Float
		return this.x * this.x + this.y * this.y + this.z * this.z;

	inline function get_normalized():Vec3 {
		var len = magnitude;
		return len == 0 ? zero() : (this : Vec3) / len;
	}

	/** Adds two vectors component-wise. */
	@:op(A + B) public inline function add(other:Vec3):Vec3
		return new Vec3(this.x + other.x, this.y + other.y, this.z + other.z);

	/** Subtracts `other` vector from this vector component-wise. */
	@:op(A - B) public inline function sub(other:Vec3):Vec3
		return new Vec3(this.x - other.x, this.y - other.y, this.z - other.z);

	/** Negates all components of the vector. */
	@:op(-A) public inline function neg():Vec3
		return new Vec3(-this.x, -this.y, -this.z);

	/** Multiplies the vector by a scalar value. */
	@:op(A * B) public inline function mulScalar(k:Float):Vec3
		return new Vec3(this.x * k, this.y * k, this.z * k);

	/** Divides the vector by a scalar value. */
	@:op(A / B) public inline function divScalar(k:Float):Vec3
		return new Vec3(this.x / k, this.y / k, this.z / k);

	/** Compares two vectors for exact component equality. */
	@:op(A == B) public inline function equals(other:Vec3):Bool
		return this.x == other.x && this.y == other.y && this.z == other.z;

	/** Compares two vectors for inequality. */
	@:op(A != B) public inline function notEquals(other:Vec3):Bool
		return !equals(other);

	/** Calculates the dot product between this vector and `other`. */
	public inline function dot(other:Vec3):Float
		return this.x * other.x + this.y * other.y + this.z * other.z;

	/** Calculates the cross product between this vector and `other`. */
	public inline function cross(other:Vec3):Vec3 {
		return new Vec3(this.y * other.z - this.z * other.y, this.z * other.x - this.x * other.z, this.x * other.y - this.y * other.x);
	}

	/** Computes the Euclidean distance to `other` vector. */
	public inline function distanceTo(other:Vec3):Float
		return Math.sqrt(distanceSqTo(other));

	/** Computes the squared distance to `other` vector. */
	public inline function distanceSqTo(other:Vec3):Float {
		var dx:Float = this.x - other.x;
		var dy:Float = this.y - other.y;
		var dz:Float = this.z - other.z;
		return dx * dx + dy * dy + dz * dz;
	}

	/** Returns the angle between this vector and another in radians. */
	public inline function angleBetween(other:Vec3):Float {
		return Math.acos(dot(other) / (magnitude * other.magnitude));
	}

	/** Projects this vector onto the `other` vector. */
	public inline function projectOnto(other:Vec3):Vec3
		return other * (dot(other) / other.magnitudeSq);

	/** Rejects this vector onto `other` (returns perpendicular component). */
	public inline function rejectOnto(other:Vec3):Vec3
		return (this : Vec3) - projectOnto(other);

	/** Reflects this vector off a surface defined by the given normal vector. */
	public inline function reflect(normal:Vec3):Vec3
		return (this : Vec3) - normal * (2 * dot(normal));

	/** Linearly interpolates between this vector and `to` by factor `t`. */
	public inline function lerp(to:Vec3, t:Float):Vec3
		return (this : Vec3) + (to - this) * t;

	/** Clamps components individually between `min` and `max` vectors. */
	public inline function clamp(min:Vec3, max:Vec3):Vec3 {
		return new Vec3(Math.min(max.x, Math.max(min.x, this.x)), Math.min(max.y, Math.max(min.y, this.y)), Math.min(max.z, Math.max(min.z, this.z)));
	}

	/** Limits the length of the vector to `maxLen`. */
	public inline function clampMagnitude(maxLen:Float):Vec3 {
		var len:Float = magnitude;
		return len > maxLen ? normalized * maxLen : this;
	}

	/** Returns a vector with absolute values of components. */
	public inline function abs():Vec3
		return new Vec3(Math.abs(this.x), Math.abs(this.y), Math.abs(this.z));

	/** Floors all components of the vector. */
	public inline function floor():Vec3
		return new Vec3(Math.floor(this.x), Math.floor(this.y), Math.floor(this.z));

	/** Ceils all components of the vector. */
	public inline function ceil():Vec3
		return new Vec3(Math.ceil(this.x), Math.ceil(this.y), Math.ceil(this.z));

	/** Rounds all components to the nearest integer. */
	public inline function round():Vec3
		return new Vec3(Math.round(this.x), Math.round(this.y), Math.round(this.z));

	/** Returns a vector containing the minimum component values between this and `other`. */
	public inline function minComponent(other:Vec3):Vec3 {
		return new Vec3(Math.min(this.x, other.x), Math.min(this.y, other.y), Math.min(this.z, other.z));
	}

	/** Returns a vector containing the maximum component values between this and `other`. */
	public inline function maxComponent(other:Vec3):Vec3 {
		return new Vec3(Math.max(this.x, other.x), Math.max(this.y, other.y), Math.max(this.z, other.z));
	}

	/** Returns a string representation of this vector. */
	public inline function toString():String
		return 'Vec3(${this.x}, ${this.y}, ${this.z})';

	/** Transforms this vector as a 3D coordinate point using a 4x4 matrix, including perspective divide. */
	public inline function transformMat4(m:Mat4):Vec3 {
		var d = m.data;
		var w:Float = d[3] * this.x + d[7] * this.y + d[11] * this.z + d[15];
		w = w == 0 ? 1 : w;
		return new Vec3((d[0] * this.x + d[4] * this.y + d[8] * this.z + d[12]) / w, (d[1] * this.x + d[5] * this.y + d[9] * this.z + d[13]) / w,
			(d[2] * this.x + d[6] * this.y + d[10] * this.z + d[14]) / w);
	}

	/** Transforms this vector as a direction using a 4x4 matrix (ignores translation components). */
	public inline function transformMat4Direction(m:Mat4):Vec3 {
		var d = m.data;
		return new Vec3(d[0] * this.x + d[4] * this.y + d[8] * this.z, d[1] * this.x + d[5] * this.y + d[9] * this.z,
			d[2] * this.x + d[6] * this.y + d[10] * this.z);
	}

	/** Transforms this vector using a 3x3 transformation matrix. */
	public inline function transformMat3(m:Mat3):Vec3 {
		var d = m.data;
		return new Vec3(d[0] * this.x + d[3] * this.y + d[6] * this.z, d[1] * this.x + d[4] * this.y + d[7] * this.z,
			d[2] * this.x + d[5] * this.y + d[8] * this.z);
	}

	/** Moves this vector towards a target vector based on a maximum delta step. */
	public inline function moveToward(target:Vec3, maxDelta:Float):Vec3 {
		var d:Vec3 = target - (this : Vec3);
		var len:Float = d.magnitude;
		return len <= maxDelta ? target : (this : Vec3) + d / len * maxDelta;
	}

	/** Spherical linearly interpolates between vector `a` and vector `b`. */
	public static function slerp(a:Vec3, b:Vec3, t:Float):Vec3 {
		var dot:Float = MathUtils.clamp(a.normalized.dot(b.normalized), -1.0, 1.0);
		var angle:Float = Math.acos(dot);
		if (Math.abs(angle) < 1e-6)
			return a.lerp(b, t);
		var sinA:Float = Math.sin((1 - t) * angle);
		var sinB:Float = Math.sin(t * angle);
		var sinTotal:Float = Math.sin(angle);
		return a * (sinA / sinTotal) + b * (sinB / sinTotal);
	}

	/** Decomposes the vector into components parallel and perpendicular to the given normal. */
	public inline function decompose(normal:Vec3):{parallel:Vec3, perpendicular:Vec3} {
		var para:Vec3 = normal * dot(normal);
		return {parallel: para, perpendicular: (this : Vec3) - para};
	}

	/** Converts this vector to a Vec4 by providing the W component (default: 1). */
	public inline function toVec4(w:Float = 1):Vec4
		return new Vec4(this.x, this.y, this.z, w);

	/** Drops the Z component and converts this vector to a Vec2. */
	public inline function toVec2():Vec2
		return new Vec2(this.x, this.y);

	// ── In-place mutating methods ────────────────────────────────────────────

	/**
	 * Sets all three components of this vector.
	 * @param x The new X component.
	 * @param y The new Y component.
	 * @param z The new Z component.
	 * @return This vector after modification.
	 */
	public inline function setXYZ(x:Float, y:Float, z:Float):Vec3 {
		this.x = x;
		this.y = y;
		this.z = z;
		return cast this;
	}

	/**
	 * Adds `other` to this vector in place.
	 * @param other The vector to add.
	 * @return This vector after modification.
	 */
	public inline function addEq(other:Vec3):Vec3 {
		this.x += other.x;
		this.y += other.y;
		this.z += other.z;
		return cast this;
	}

	/**
	 * Subtracts `other` from this vector in place.
	 * @param other The vector to subtract.
	 * @return This vector after modification.
	 */
	public inline function subEq(other:Vec3):Vec3 {
		this.x -= other.x;
		this.y -= other.y;
		this.z -= other.z;
		return cast this;
	}

	/**
	 * Multiplies this vector by a scalar in place.
	 * @param k The scalar factor.
	 * @return This vector after modification.
	 */
	public inline function mulScalarEq(k:Float):Vec3 {
		this.x *= k;
		this.y *= k;
		this.z *= k;
		return cast this;
	}

	/**
	 * Divides this vector by a scalar in place.
	 * @param k The scalar divisor.
	 * @return This vector after modification.
	 */
	public inline function divScalarEq(k:Float):Vec3 {
		this.x /= k;
		this.y /= k;
		this.z /= k;
		return cast this;
	}

	/**
	 * Negates all components of this vector in place.
	 * @return This vector after modification.
	 */
	public inline function negEq():Vec3 {
		this.x = -this.x;
		this.y = -this.y;
		this.z = -this.z;
		return cast this;
	}

	/**
	 * Normalizes this vector to unit length in place.
	 * If the length is zero the vector remains unchanged.
	 * @return This vector after modification.
	 */
	public inline function normalizeEq():Vec3 {
		var len:Float = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
		if (len != 0) {
			this.x /= len;
			this.y /= len;
			this.z /= len;
		}
		return cast this;
	}

	/**
	 * Linearly interpolates this vector toward `to` by factor `t` in place.
	 * @param to The target vector.
	 * @param t The interpolation factor (0–1).
	 * @return This vector after modification.
	 */
	public inline function lerpEq(to:Vec3, t:Float):Vec3 {
		this.x += (to.x - this.x) * t;
		this.y += (to.y - this.y) * t;
		this.z += (to.z - this.z) * t;
		return cast this;
	}

	/**
	 * Sets this vector to the cross product of itself with `other` in place.
	 * @param other The right-hand operand.
	 * @return This vector after modification.
	 */
	public inline function crossEq(other:Vec3):Vec3 {
		var nx:Float = this.y * other.z - this.z * other.y;
		var ny:Float = this.z * other.x - this.x * other.z;
		this.z = this.x * other.y - this.y * other.x;
		this.x = nx;
		this.y = ny;
		return cast this;
	}

	/**
	 * Clamps each component between the corresponding components of `min` and `max` in place.
	 * @param min The minimum bound vector.
	 * @param max The maximum bound vector.
	 * @return This vector after modification.
	 */
	public inline function clampEq(min:Vec3, max:Vec3):Vec3 {
		this.x = Math.min(max.x, Math.max(min.x, this.x));
		this.y = Math.min(max.y, Math.max(min.y, this.y));
		this.z = Math.min(max.z, Math.max(min.z, this.z));
		return cast this;
	}

	/**
	 * Limits the length of this vector to `maxLen` in place.
	 * @param maxLen The maximum allowed length.
	 * @return This vector after modification.
	 */
	public inline function clampMagnitudeEq(maxLen:Float):Vec3 {
		var len:Float = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
		if (len > maxLen) {
			var s:Float = maxLen / len;
			this.x *= s;
			this.y *= s;
			this.z *= s;
		}
		return cast this;
	}

	/**
	 * Applies Math.abs to each component in place.
	 * @return This vector after modification.
	 */
	public inline function absEq():Vec3 {
		this.x = Math.abs(this.x);
		this.y = Math.abs(this.y);
		this.z = Math.abs(this.z);
		return cast this;
	}

	/**
	 * Floors each component in place.
	 * @return This vector after modification.
	 */
	public inline function floorEq():Vec3 {
		this.x = Math.floor(this.x);
		this.y = Math.floor(this.y);
		this.z = Math.floor(this.z);
		return cast this;
	}

	/**
	 * Ceils each component in place.
	 * @return This vector after modification.
	 */
	public inline function ceilEq():Vec3 {
		this.x = Math.ceil(this.x);
		this.y = Math.ceil(this.y);
		this.z = Math.ceil(this.z);
		return cast this;
	}

	/**
	 * Rounds each component to the nearest integer in place.
	 * @return This vector after modification.
	 */
	public inline function roundEq():Vec3 {
		this.x = Math.round(this.x);
		this.y = Math.round(this.y);
		this.z = Math.round(this.z);
		return cast this;
	}

	/**
	 * Keeps only the minimum component values between this and `other` in place.
	 * @param other The vector to compare against.
	 * @return This vector after modification.
	 */
	public inline function minComponentEq(other:Vec3):Vec3 {
		this.x = Math.min(this.x, other.x);
		this.y = Math.min(this.y, other.y);
		this.z = Math.min(this.z, other.z);
		return cast this;
	}

	/**
	 * Keeps only the maximum component values between this and `other` in place.
	 * @param other The vector to compare against.
	 * @return This vector after modification.
	 */
	public inline function maxComponentEq(other:Vec3):Vec3 {
		this.x = Math.max(this.x, other.x);
		this.y = Math.max(this.y, other.y);
		this.z = Math.max(this.z, other.z);
		return cast this;
	}

	/**
	 * Reflects this vector off a surface defined by `normal` in place.
	 * @param normal The surface normal (should be normalized).
	 * @return This vector after modification.
	 */
	public inline function reflectEq(normal:Vec3):Vec3 {
		var d:Float = 2 * (this.x * normal.x + this.y * normal.y + this.z * normal.z);
		this.x -= normal.x * d;
		this.y -= normal.y * d;
		this.z -= normal.z * d;
		return cast this;
	}

	/**
	 * Projects this vector onto `other` in place.
	 * @param other The vector to project onto.
	 * @return This vector after modification.
	 */
	public inline function projectOntoEq(other:Vec3):Vec3 {
		var s:Float = (this.x * other.x + this.y * other.y + this.z * other.z)
			/ (other.x * other.x + other.y * other.y + other.z * other.z);
		this.x = other.x * s;
		this.y = other.y * s;
		this.z = other.z * s;
		return cast this;
	}

	/**
	 * Moves this vector toward `target` by at most `maxDelta` in place.
	 * @param target The destination vector.
	 * @param maxDelta The maximum movement distance.
	 * @return This vector after modification.
	 */
	public inline function moveTowardEq(target:Vec3, maxDelta:Float):Vec3 {
		var dx:Float = target.x - this.x;
		var dy:Float = target.y - this.y;
		var dz:Float = target.z - this.z;
		var len:Float = Math.sqrt(dx * dx + dy * dy + dz * dz);
		if (len <= maxDelta) {
			this.x = target.x;
			this.y = target.y;
			this.z = target.z;
		} else {
			var s:Float = maxDelta / len;
			this.x += dx * s;
			this.y += dy * s;
			this.z += dz * s;
		}
		return cast this;
	}

	/**
	 * Transforms this vector as a 3D point using a 4x4 matrix in place (includes perspective divide).
	 * @param m The transformation matrix.
	 * @return This vector after modification.
	 */
	public inline function transformMat4Eq(m:Mat4):Vec3 {
		var d = m.data;
		var w:Float = d[3] * this.x + d[7] * this.y + d[11] * this.z + d[15];
		w = w == 0 ? 1 : w;
		var nx:Float = (d[0] * this.x + d[4] * this.y + d[8] * this.z + d[12]) / w;
		var ny:Float = (d[1] * this.x + d[5] * this.y + d[9] * this.z + d[13]) / w;
		this.z = (d[2] * this.x + d[6] * this.y + d[10] * this.z + d[14]) / w;
		this.x = nx;
		this.y = ny;
		return cast this;
	}

	/**
	 * Transforms this vector as a direction using a 4x4 matrix in place (ignores translation).
	 * @param m The transformation matrix.
	 * @return This vector after modification.
	 */
	public inline function transformMat4DirectionEq(m:Mat4):Vec3 {
		var d = m.data;
		var nx:Float = d[0] * this.x + d[4] * this.y + d[8] * this.z;
		var ny:Float = d[1] * this.x + d[5] * this.y + d[9] * this.z;
		this.z = d[2] * this.x + d[6] * this.y + d[10] * this.z;
		this.x = nx;
		this.y = ny;
		return cast this;
	}

	/**
	 * Transforms this vector using a 3x3 matrix in place.
	 * @param m The transformation matrix.
	 * @return This vector after modification.
	 */
	public inline function transformMat3Eq(m:Mat3):Vec3 {
		var d = m.data;
		var nx:Float = d[0] * this.x + d[3] * this.y + d[6] * this.z;
		var ny:Float = d[1] * this.x + d[4] * this.y + d[7] * this.z;
		this.z = d[2] * this.x + d[5] * this.y + d[8] * this.z;
		this.x = nx;
		this.y = ny;
		return cast this;
	}
}

@:structInit
private class BaseVec3 {
	public var x:Float;
	public var y:Float;
	public var z:Float;
}
