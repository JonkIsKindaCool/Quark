package quark.math;

/**
 * Represents a two-dimensional vector (X, Y).
 */
@:forward
abstract Vec2(BaseVec2) from BaseVec2 to BaseVec2 {
	/**
	 * Creates a new 2D Vector.
	 * @param x The X coordinate.
	 * @param y The Y coordinate.
	 */
	public inline function new(x:Float, y:Float) {
		this = {x: x, y: y};
	}

	/** Returns a vector with components (0, 0). */
	public static inline function zero():Vec2
		return new Vec2(0, 0);

	/** Returns a vector with components (1, 1). */
	public static inline function one():Vec2
		return new Vec2(1, 1);

	/** Returns a unit vector pointing along the positive X-axis (1, 0). */
	public static inline function unitX():Vec2
		return new Vec2(1, 0);

	/** Returns a unit vector pointing along the positive Y-axis (0, 1). */
	public static inline function unitY():Vec2
		return new Vec2(0, 1);

	/**
	 * Creates a vector from polar coordinates.
	 * @param angle The angle in radians.
	 * @param radius The magnitude of the vector (default: 1).
	 */
	public static inline function fromPolar(angle:Float, radius:Float = 1):Vec2 {
		return new Vec2(radius * Math.cos(angle), radius * Math.sin(angle));
	}

	/** The magnitude (length) of the vector. */
	public var magnitude(get, never):Float;

	/** The squared magnitude of the vector. Prefer this over `magnitude` for performance when comparing lengths. */
	public var magnitudeSq(get, never):Float;

	/** Returns a normalized copy of this vector (unit length). Returns zero vector if length is 0. */
	public var normalized(get, never):Vec2;

	/** The angle of this vector in radians relative to the positive X axis. */
	public var angle(get, never):Float;

	/** Returns a perpendicular vector rotated 90 degrees counter-clockwise (-y, x). */
	public var perp(get, never):Vec2;

	/** Returns a perpendicular vector rotated 90 degrees clockwise (y, -x). */
	public var perpHor(get, never):Vec2;

	inline function get_magnitude():Float
		return Math.sqrt(this.x * this.x + this.y * this.y);

	inline function get_magnitudeSq():Float
		return this.x * this.x + this.y * this.y;

	inline function get_normalized():Vec2 {
		var len = magnitude;
		return len == 0 ? zero() : (this : Vec2) / len;
	}

	inline function get_angle():Float
		return Math.atan2(this.y, this.x);

	inline function get_perp():Vec2
		return new Vec2(-this.y, this.x);

	inline function get_perpHor():Vec2
		return new Vec2(this.y, -this.x);

	/** Adds two vectors component-wise. */
	@:op(A + B) public inline function add(other:Vec2):Vec2 {
		return new Vec2(this.x + other.x, this.y + other.y);
	}

	/** Subtracts `other` vector from this vector component-wise. */
	@:op(A - B) public inline function sub(other:Vec2):Vec2 {
		return new Vec2(this.x - other.x, this.y - other.y);
	}

	/** Negates both components of the vector. */
	@:op(-A) public inline function neg():Vec2 {
		return new Vec2(-this.x, -this.y);
	}

	/** Multiplies the vector by a scalar value. */
	@:op(A * B) public inline function mulScalar(k:Float):Vec2 {
		return new Vec2(this.x * k, this.y * k);
	}

	/** Divides the vector by a scalar value. */
	@:op(A / B) public inline function divScalar(k:Float):Vec2 {
		return new Vec2(this.x / k, this.y / k);
	}

	/** Compares two vectors for exact equality. */
	@:op(A == B) public inline function equals(other:Vec2):Bool {
		return this.x == other.x && this.y == other.y;
	}

	/** Compares two vectors for inequality. */
	@:op(A != B) public inline function notEquals(other:Vec2):Bool {
		return !equals(other);
	}

	/** Calculates the dot product between this vector and `other`. */
	public inline function dot(other:Vec2):Float {
		return this.x * other.x + this.y * other.y;
	}

	/** Calculates the 2D cross product analog (Z-component of 3D cross product). */
	public inline function cross(other:Vec2):Float {
		return this.x * other.y - this.y * other.x;
	}

	/** Computes the Euclidean distance to `other` vector. */
	public inline function distanceTo(other:Vec2):Float {
		return Math.sqrt(distanceSqTo(other));
	}

	/** Computes the squared distance to `other` vector (faster than distanceTo). */
	public inline function distanceSqTo(other:Vec2):Float {
		var dx:Float = this.x - other.x;
		var dy:Float = this.y - other.y;
		return dx * dx + dy * dy;
	}

	/** Returns the angle between this vector and another in radians. */
	public inline function angleBetween(other:Vec2):Float {
		return Math.acos(dot(other) / (magnitude * other.magnitude));
	}

	/** Projects this vector onto the `other` vector. */
	public inline function projectOnto(other:Vec2):Vec2 {
		var t:Float = dot(other) / other.magnitudeSq;
		return other * t;
	}

	/** Rejects this vector onto `other` (returns the perpendicular component of projection). */
	public inline function rejectOnto(other:Vec2):Vec2 {
		return (this : Vec2) - projectOnto(other);
	}

	/** Reflects this vector off a surface defined by the given normal vector. */
	public inline function reflect(normal:Vec2):Vec2 {
		return (this : Vec2) - normal * (2 * dot(normal));
	}

	/** Linearly interpolates between this vector and `to` by factor `t`. */
	public inline function lerp(to:Vec2, t:Float):Vec2 {
		return (this : Vec2) + (to - (this : Vec2)) * t;
	}

	/** Rotates the vector by `angle` in radians. */
	public inline function rotate(angle:Float):Vec2 {
		var cos:Float = Math.cos(angle);
		var sin:Float = Math.sin(angle);
		return new Vec2(this.x * cos - this.y * sin, this.x * sin + this.y * cos);
	}

	/** Clamps components individually between `min` and `max` vectors. */
	public inline function clamp(min:Vec2, max:Vec2):Vec2 {
		return new Vec2(Math.min(max.x, Math.max(min.x, this.x)), Math.min(max.y, Math.max(min.y, this.y)));
	}

	/** Limits the length of the vector to `maxLen`. */
	public inline function clampMagnitude(maxLen:Float):Vec2 {
		var len:Float = magnitude;
		return len > maxLen ? normalized * maxLen : this;
	}

	/** Returns a vector with absolute values of original components. */
	public inline function abs():Vec2 {
		return new Vec2(Math.abs(this.x), Math.abs(this.y));
	}

	/** Floors the X and Y components. */
	public inline function floor():Vec2 {
		return new Vec2(Math.floor(this.x), Math.floor(this.y));
	}

	/** Ceils the X and Y components. */
	public inline function ceil():Vec2 {
		return new Vec2(Math.ceil(this.x), Math.ceil(this.y));
	}

	/** Rounds the X and Y components to the nearest integer. */
	public inline function round():Vec2 {
		return new Vec2(Math.round(this.x), Math.round(this.y));
	}

	/** Returns a vector containing the minimum component values between this and `other`. */
	public inline function minComponent(other:Vec2):Vec2 {
		return new Vec2(Math.min(this.x, other.x), Math.min(this.y, other.y));
	}

	/** Returns a vector containing the maximum component values between this and `other`. */
	public inline function maxComponent(other:Vec2):Vec2 {
		return new Vec2(Math.max(this.x, other.x), Math.max(this.y, other.y));
	}

	/** Returns the vector pointing from this vector to `other`. */
	public inline function between(other:Vec2):Vec2 {
		return other.sub(this);
	}

	/** Converts this vector to polar coordinates structure `{r: Float, angle: Float}`. */
	public inline function toPolar():{r:Float, angle:Float} {
		return {r: magnitude, angle: (this : Vec2).angle};
	}

	/** Transforms this point vector using a 3x3 Matrix (handles translation). */
	public inline function transformMat3(m:Mat3):Vec2 {
		var d = m.data;
		return new Vec2(d[0] * this.x + d[3] * this.y + d[6], d[1] * this.x + d[4] * this.y + d[7]);
	}

	/** Transforms this directional vector using a 3x3 Matrix (ignores translation). */
	public inline function transformMat3Direction(m:Mat3):Vec2 {
		var d = m.data;
		return new Vec2(d[0] * this.x + d[3] * this.y, d[1] * this.x + d[4] * this.y);
	}

	/** Snaps the vector coordinates to a grid of size `gridSize`. */
	public inline function snapToGrid(gridSize:Float):Vec2 {
		return new Vec2(Math.round(this.x / gridSize) * gridSize, Math.round(this.y / gridSize) * gridSize);
	}

	/** Moves this vector towards a target vector without overshoot based on a maximum delta step. */
	public inline function moveToward(target:Vec2, maxDelta:Float):Vec2 {
		var d:Vec2 = target - (this : Vec2);
		var len:Float = d.magnitude;
		return len <= maxDelta ? target : (this : Vec2) + d / len * maxDelta;
	}

	/** Spherical linearly interpolates between vector `a` and vector `b`. */
	public static function slerp(a:Vec2, b:Vec2, t:Float):Vec2 {
		var angle:Float = a.angleBetween(b);
		if (Math.abs(angle) < 1e-6)
			return a.lerp(b, t);
		var sinA:Float = Math.sin((1 - t) * angle);
		var sinB:Float = Math.sin(t * angle);
		var sinTotal:Float = Math.sin(angle);
		return a * (sinA / sinTotal) + b * (sinB / sinTotal);
	}

	/** Converts this vector into a Vec3 by providing a Z component. */
	public inline function toVec3(z:Float = 0):Vec3
		return new Vec3(this.x, this.y, z);

	/** Checks if this point lies inside a circle defined by center and radius. */
	public inline function isInCircle(center:Vec2, radius:Float):Bool
		return distanceSqTo(center) <= radius * radius;

	/** Returns a string representation of this vector. */
	public inline function toString():String {
		return 'Vec2(${this.x}, ${this.y})';
	}
}

@:structInit
private class BaseVec2 {
	public var x:Float;
	public var y:Float;
}
