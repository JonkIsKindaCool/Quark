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

	public static function fromEuler(x:Float, y:Float, z:Float):Quat {
		var cx = Math.cos(x * 0.5), sx = Math.sin(x * 0.5);
		var cy = Math.cos(y * 0.5), sy = Math.sin(y * 0.5);
		var cz = Math.cos(z * 0.5), sz = Math.sin(z * 0.5);
		return new Quat(sx * cy * cz + cx * sy * sz, cx * sy * cz - sx * cy * sz, cx * cy * sz + sx * sy * cz, cx * cy * cz - sx * sy * sz);
	}

	@:to
	public inline function toMat4():Mat4 {
		var xx:Float = this.x * this.x, yy = this.y * this.y, zz = this.z * this.z;
		var xy:Float = this.x * this.y, xz = this.x * this.z, yz = this.y * this.z;
		var wx:Float = this.w * this.x, wy = this.w * this.y, wz = this.w * this.z;

		return new Mat4(1
			- 2 * (yy + zz), 2 * (xy + wz), 2 * (xz - wy), 0, 2 * (xy - wz), 1
			- 2 * (xx + zz), 2 * (yz + wx), 0, 2 * (xz + wy), 2 * (yz - wx),
			1
			- 2 * (xx + yy), 0, 0, 0, 0, 1);
	}

	public inline function toEuler():Vec3 {
		var sinX :Float= 2 * (this.w * this.x + this.y * this.z);
		var cosX :Float= 1 - 2 * (this.x * this.x + this.y * this.y);

		var sinY :Float= 2 * (this.w * this.y - this.z * this.x);

		var sinZ :Float= 2 * (this.w * this.z + this.x * this.y);
		var cosZ :Float= 1 - 2 * (this.y * this.y + this.z * this.z);

		return new Vec3(Math.atan2(sinX, cosX), Math.abs(sinY) >= 1 ? Math.PI / 2 * MathUtils.sign(sinY) : Math.asin(sinY), Math.atan2(sinZ, cosZ));
	}

	public static function slerp(a:Quat, b:Quat, t:Float):Quat {
		var dot:Float = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;

		var bx:Float = b.x, by = b.y, bz = b.z, bw = b.w;
		if (dot < 0) {
			dot = -dot;
			bx = -bx;
			by = -by;
			bz = -bz;
			bw = -bw;
		}

		if (dot > 0.9995)
			return a.lerp(new Quat(bx, by, bz, bw), t);

		var angle:Float = Math.acos(dot);
		var sinA:Float = Math.sin((1 - t) * angle);
		var sinB:Float = Math.sin(t * angle);
		var sinTotal:Float = Math.sin(angle);

		return new Quat((a.x * sinA + bx * sinB) / sinTotal, (a.y * sinA + by * sinB) / sinTotal, (a.z * sinA + bz * sinB) / sinTotal,
			(a.w * sinA + bw * sinB) / sinTotal);
	}

	public inline function dot(other:Quat):Float
		return this.x * other.x + this.y * other.y + this.z * other.z + this.w * other.w;

	public static inline function angleBetween(a:Quat, b:Quat):Float {
		var d = MathUtils.clamp(Math.abs(a.dot(b)), -1, 1);
		return Math.acos(2 * d * d - 1);
	}

	public static function rotateToward(from:Quat, to:Quat, maxAngle:Float):Quat {
		var angle = angleBetween(from, to);
		if (angle < 1e-6)
			return to;
		return slerp(from, to, Math.min(1, maxAngle / angle));
	}
}

@:structInit
private class BaseQuat {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;
}
