package quark.math;

@:forward
abstract Vec4(BaseVec4) from BaseVec4 to BaseVec4 {
	public inline function new(x:Float, y:Float, z:Float, w:Float) {
		this = {
			x: x,
			y: y,
			z: z,
			w: w
		};
	}

	public static inline function zero():Vec4
		return new Vec4(0, 0, 0, 0);

	public static inline function one():Vec4
		return new Vec4(1, 1, 1, 1);

	public static inline function unitX():Vec4
		return new Vec4(1, 0, 0, 0);

	public static inline function unitY():Vec4
		return new Vec4(0, 1, 0, 0);

	public static inline function unitZ():Vec4
		return new Vec4(0, 0, 1, 0);

	public static inline function unitW():Vec4
		return new Vec4(0, 0, 0, 1);

	public var magnitude(get, never):Float;
	public var magnitudeSq(get, never):Float;
	public var normalized(get, never):Vec4;

	inline function get_magnitude():Float
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);

	inline function get_magnitudeSq():Float
		return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;

	inline function get_normalized():Vec4 {
		var len = magnitude;
		return len == 0 ? zero() : (this : Vec4) / len;
	}

	@:op(A + B) public inline function add(other:Vec4):Vec4
		return new Vec4(this.x + other.x, this.y + other.y, this.z + other.z, this.w + other.w);

	@:op(A - B) public inline function sub(other:Vec4):Vec4
		return new Vec4(this.x - other.x, this.y - other.y, this.z - other.z, this.w - other.w);

	@:op(-A) public inline function neg():Vec4
		return new Vec4(-this.x, -this.y, -this.z, -this.w);

	@:op(A * B) public inline function mulScalar(k:Float):Vec4
		return new Vec4(this.x * k, this.y * k, this.z * k, this.w * k);

	@:op(A / B) public inline function divScalar(k:Float):Vec4
		return new Vec4(this.x / k, this.y / k, this.z / k, this.w / k);

	@:op(A == B) public inline function equals(other:Vec4):Bool
		return this.x == other.x && this.y == other.y && this.z == other.z && this.w == other.w;

	@:op(A != B) public inline function notEquals(other:Vec4):Bool
		return !equals(other);

	public inline function dot(other:Vec4):Float
		return this.x * other.x + this.y * other.y + this.z * other.z + this.w * other.w;

	public inline function toVec3():Vec3
		return new Vec3(this.x, this.y, this.z);

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
