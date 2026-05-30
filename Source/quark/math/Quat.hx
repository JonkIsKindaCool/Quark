package quark.math;

@:forward
abstract Quat(BaseQuat) from BaseQuat to BaseQuat {
	public inline function new(x:Float, y:Float, z:Float, w:Float) {
		this = {
			x: x,
			y: y,
			z: z,
			w: w
		};
	}

	public static inline function identity():Quat
		return new Quat(0, 0, 0, 1);

	public static inline function fromAxisAngle(axis:Vec3, angle:Float):Quat {
		var half = angle * 0.5;
		var s = Math.sin(half);
		return new Quat(axis.x * s, axis.y * s, axis.z * s, Math.cos(half));
	}

	public var magnitude(get, never):Float;
	public var normalized(get, never):Quat;

	inline function get_magnitude():Float
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);

	inline function get_normalized():Quat {
		var len = magnitude;
		if (len == 0)
			return identity();
		return new Quat(this.x / len, this.y / len, this.z / len, this.w / len);
	}

	@:op(A * B) public inline function multiply(other:Quat):Quat {
		return new Quat(this.w * other.x
			+ this.x * other.w
			+ this.y * other.z
			- this.z * other.y,
			this.w * other.y
			- this.x * other.z
			+ this.y * other.w
			+ this.z * other.x,
			this.w * other.z
			+ this.x * other.y
			- this.y * other.x
			+ this.z * other.w,
			this.w * other.w
			- this.x * other.x
			- this.y * other.y
			- this.z * other.z);
	}

	@:op(A * B) public inline function transformVec3(v:Vec3):Vec3 {
		var ix = this.w * v.x + this.y * v.z - this.z * v.y;
		var iy = this.w * v.y + this.z * v.x - this.x * v.z;
		var iz = this.w * v.z + this.x * v.y - this.y * v.x;
		var iw = -this.x * v.x - this.y * v.y - this.z * v.z;
		return new Vec3(ix * this.w
			+ iw * -this.x + iy * -this.z - iz * -this.y, iy * this.w
			+ iw * -this.y + iz * -this.x - ix * -this.z,
			iz * this.w
			+ iw * -this.z + ix * -this.y - iy * -this.x);
	}

	public inline function conjugate():Quat
		return new Quat(-this.x, -this.y, -this.z, this.w);

	public inline function inverse():Quat
		return conjugate().normalized;

	public inline function toMat3():Mat3 {
		var xx = this.x * this.x, yy = this.y * this.y, zz = this.z * this.z;
		var xy = this.x * this.y, xz = this.x * this.z, yz = this.y * this.z;
		var wx = this.w * this.x, wy = this.w * this.y, wz = this.w * this.z;
		return new Mat3(1
			- 2 * (yy + zz), 2 * (xy + wz), 2 * (xz - wy), 2 * (xy - wz), 1
			- 2 * (xx + zz), 2 * (yz + wx), 2 * (xz + wy), 2 * (yz - wx),
			1
			- 2 * (xx + yy));
	}

	public inline function lerp(to:Quat, t:Float):Quat {
		return new Quat(this.x + (to.x - this.x) * t, this.y + (to.y - this.y) * t, this.z + (to.z - this.z) * t, this.w + (to.w - this.w) * t).normalized;
	}

	public inline function toString():String
		return 'Quat(${this.x}, ${this.y}, ${this.z}, ${this.w})';
}

@:structInit
private class BaseQuat {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;
}
