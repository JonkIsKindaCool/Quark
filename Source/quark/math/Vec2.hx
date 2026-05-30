package quark.math;

@:forward
abstract Vec2(BaseVec2) from BaseVec2 to BaseVec2 {
	public inline function new(x:Float, y:Float) {
		this = {x: x, y: y};
	}

	public static inline function zero():Vec2
		return new Vec2(0, 0);

	public static inline function one():Vec2
		return new Vec2(1, 1);

	public static inline function unitX():Vec2
		return new Vec2(1, 0);

	public static inline function unitY():Vec2
		return new Vec2(0, 1);

	public static inline function fromPolar(angle:Float, radius:Float = 1):Vec2 {
		return new Vec2(radius * Math.cos(angle), radius * Math.sin(angle));
	}

	public var magnitude(get, never):Float;
	public var magnitudeSq(get, never):Float;
	public var normalized(get, never):Vec2;
	public var angle(get, never):Float;
	public var perp(get, never):Vec2;
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

	@:op(A + B) public inline function add(other:Vec2):Vec2 {
		return new Vec2(this.x + other.x, this.y + other.y);
	}

	@:op(A - B) public inline function sub(other:Vec2):Vec2 {
		return new Vec2(this.x - other.x, this.y - other.y);
	}

	@:op(-A) public inline function neg():Vec2 {
		return new Vec2(-this.x, -this.y);
	}

	@:op(A * B) public inline function mulScalar(k:Float):Vec2 {
		return new Vec2(this.x * k, this.y * k);
	}

	@:op(A / B) public inline function divScalar(k:Float):Vec2 {
		return new Vec2(this.x / k, this.y / k);
	}

	@:op(A == B) public inline function equals(other:Vec2):Bool {
		return this.x == other.x && this.y == other.y;
	}

	@:op(A != B) public inline function notEquals(other:Vec2):Bool {
		return !equals(other);
	}

	public inline function dot(other:Vec2):Float {
		return this.x * other.x + this.y * other.y;
	}

	public inline function cross(other:Vec2):Float {
		return this.x * other.y - this.y * other.x;
	}

	public inline function distanceTo(other:Vec2):Float {
		return Math.sqrt(distanceSqTo(other));
	}

	public inline function distanceSqTo(other:Vec2):Float {
		var dx:Float = this.x - other.x;
		var dy:Float = this.y - other.y;

		return dx * dx + dy * dy;
	}

	public inline function angleBetween(other:Vec2):Float {
		return Math.acos(dot(other) / (magnitude * other.magnitude));
	}

	public inline function projectOnto(other:Vec2):Vec2 {
		var t:Float = dot(other) / other.magnitudeSq;

		return other * t;
	}

	public inline function rejectOnto(other:Vec2):Vec2 {
		return (this : Vec2) - projectOnto(other);
	}

	public inline function reflect(normal:Vec2):Vec2 {
		return (this : Vec2) - normal * (2 * dot(normal));
	}

	public inline function lerp(to:Vec2, t:Float):Vec2 {
		return (this : Vec2) + (to - (this : Vec2)) * t;
	}

	public inline function rotate(angle:Float):Vec2 {
		var cos:Float = Math.cos(angle);
		var sin:Float = Math.sin(angle);
		return new Vec2(this.x * cos - this.y * sin, this.x * sin + this.y * cos);
	}

	public inline function clamp(min:Vec2, max:Vec2):Vec2 {
		return new Vec2(Math.min(max.x, Math.max(min.x, this.x)), Math.min(max.y, Math.max(min.y, this.y)));
	}

	public inline function clampMagnitude(maxLen:Float):Vec2 {
		var len:Float = magnitude;

		return len > maxLen ? normalized * maxLen : this;
	}

	public inline function abs():Vec2 {
		return new Vec2(Math.abs(this.x), Math.abs(this.y));
	}

	public inline function floor():Vec2 {
		return new Vec2(Math.floor(this.x), Math.floor(this.y));
	}

	public inline function ceil():Vec2 {
		return new Vec2(Math.ceil(this.x), Math.ceil(this.y));
	}

	public inline function round():Vec2 {
		return new Vec2(Math.round(this.x), Math.round(this.y));
	}

	public inline function minComponent(other:Vec2):Vec2 {
		return new Vec2(Math.min(this.x, other.x), Math.min(this.y, other.y));
	}

	public inline function maxComponent(other:Vec2):Vec2 {
		return new Vec2(Math.max(this.x, other.x), Math.max(this.y, other.y));
	}

	public inline function between(other:Vec2):Vec2 {
		return other.sub(this);
	}

	public inline function toPolar():{r:Float, angle:Float} {
		return {r: magnitude, angle: (this : Vec2).angle};
	}

	public inline function toString():String {
		return 'Vec2(${this.x}, ${this.y})';
	}
}

@:structInit
private class BaseVec2 {
	public var x:Float;
	public var y:Float;
}
