package quark.math;

@:forward
abstract Vec3(BaseVec3) from BaseVec3 to BaseVec3 {
	public inline function new(x:Float, y:Float, z:Float) {
		this = {x: x, y: y, z: z};
	}

	public static inline function zero():Vec3
		return new Vec3(0, 0, 0);

	public static inline function one():Vec3
		return new Vec3(1, 1, 1);

	public static inline function unitX():Vec3
		return new Vec3(1, 0, 0);

	public static inline function unitY():Vec3
		return new Vec3(0, 1, 0);

	public static inline function unitZ():Vec3
		return new Vec3(0, 0, 1);

	public var magnitude(get, never):Float;
	public var magnitudeSq(get, never):Float;
	public var normalized(get, never):Vec3;

	inline function get_magnitude():Float
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);

	inline function get_magnitudeSq():Float
		return this.x * this.x + this.y * this.y + this.z * this.z;

	inline function get_normalized():Vec3 {
		var len = magnitude;
		return len == 0 ? zero() : (this : Vec3) / len;
	}

	@:op(A + B) public inline function add(other:Vec3):Vec3
		return new Vec3(this.x + other.x, this.y + other.y, this.z + other.z);

	@:op(A - B) public inline function sub(other:Vec3):Vec3
		return new Vec3(this.x - other.x, this.y - other.y, this.z - other.z);

	@:op(-A) public inline function neg():Vec3
		return new Vec3(-this.x, -this.y, -this.z);

	@:op(A * B) public inline function mulScalar(k:Float):Vec3
		return new Vec3(this.x * k, this.y * k, this.z * k);

	@:op(A / B) public inline function divScalar(k:Float):Vec3
		return new Vec3(this.x / k, this.y / k, this.z / k);

	@:op(A == B) public inline function equals(other:Vec3):Bool
		return this.x == other.x && this.y == other.y && this.z == other.z;

	@:op(A != B) public inline function notEquals(other:Vec3):Bool
		return !equals(other);

	public inline function dot(other:Vec3):Float
		return this.x * other.x + this.y * other.y + this.z * other.z;

	public inline function cross(other:Vec3):Vec3 {
		return new Vec3(this.y * other.z - this.z * other.y, this.z * other.x - this.x * other.z, this.x * other.y - this.y * other.x);
	}

	public inline function distanceTo(other:Vec3):Float
		return Math.sqrt(distanceSqTo(other));

	public inline function distanceSqTo(other:Vec3):Float {
		var dx:Float = this.x - other.x;
		var dy:Float = this.y - other.y;
		var dz:Float = this.z - other.z;

		return dx * dx + dy * dy + dz * dz;
	}

	public inline function angleBetween(other:Vec3):Float {
		return Math.acos(dot(other) / (magnitude * other.magnitude));
	}

	public inline function projectOnto(other:Vec3):Vec3
		return other * (dot(other) / other.magnitudeSq);

	public inline function rejectOnto(other:Vec3):Vec3
		return (this : Vec3) - projectOnto(other);

	public inline function reflect(normal:Vec3):Vec3
		return (this : Vec3) - normal * (2 * dot(normal));

	public inline function lerp(to:Vec3, t:Float):Vec3
		return (this : Vec3) + (to - this) * t;

	public inline function clamp(min:Vec3, max:Vec3):Vec3 {
		return new Vec3(Math.min(max.x, Math.max(min.x, this.x)), Math.min(max.y, Math.max(min.y, this.y)), Math.min(max.z, Math.max(min.z, this.z)));
	}

	public inline function clampMagnitude(maxLen:Float):Vec3 {
		var len:Float = magnitude;

		return len > maxLen ? normalized * maxLen : this;
	}

	public inline function abs():Vec3
		return new Vec3(Math.abs(this.x), Math.abs(this.y), Math.abs(this.z));

	public inline function floor():Vec3
		return new Vec3(Math.floor(this.x), Math.floor(this.y), Math.floor(this.z));

	public inline function ceil():Vec3
		return new Vec3(Math.ceil(this.x), Math.ceil(this.y), Math.ceil(this.z));

	public inline function round():Vec3
		return new Vec3(Math.round(this.x), Math.round(this.y), Math.round(this.z));

	public inline function minComponent(other:Vec3):Vec3 {
		return new Vec3(Math.min(this.x, other.x), Math.min(this.y, other.y), Math.min(this.z, other.z));
	}

	public inline function maxComponent(other:Vec3):Vec3 {
		return new Vec3(Math.max(this.x, other.x), Math.max(this.y, other.y), Math.max(this.z, other.z));
	}

	public inline function toString():String
		return 'Vec3(${this.x}, ${this.y}, ${this.z})';
}

@:structInit
private class BaseVec3 {
	public var x:Float;
	public var y:Float;
	public var z:Float;
}
