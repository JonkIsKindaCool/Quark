package quark.math;

@:forward
abstract Mat4(BaseMat4) from BaseMat4 to BaseMat4 {
	public inline function new(m00:Float, m10:Float, m20:Float, m30:Float, m01:Float, m11:Float, m21:Float, m31:Float, m02:Float, m12:Float, m22:Float,
			m32:Float, m03:Float, m13:Float, m23:Float, m33:Float) {
		var obj:BaseMat4 = new BaseMat4();
		obj.data = [
			m00, m10, m20, m30,
			m01, m11, m21, m31,
			m02, m12, m22, m32,
			m03, m13, m23, m33
		];

		this = obj;
	}

	public static inline function identity():Mat4 {
		return new Mat4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	public static inline function zero():Mat4 {
		return new Mat4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	public inline function get(row:Int, col:Int):Float {
		return this.data[col * 4 + row];
	}

	public inline function set(row:Int, col:Int, v:Float):Mat4 {
		this.data[col * 4 + row] = v;
		return this;
	}

	@:op(A * B) public inline function multiply(other:Mat4):Mat4 {
		var a:Array<Float> = this.data, b = other.data;

		return new Mat4(a[0] * b[0] + a[4] * b[1] + a[8] * b[2] + a[12] * b[3], a[1] * b[0] + a[5] * b[1] + a[9] * b[2] + a[13] * b[3],
			a[2] * b[0] + a[6] * b[1] + a[10] * b[2] + a[14] * b[3], a[3] * b[0] + a[7] * b[1] + a[11] * b[2] + a[15] * b[3],

			a[0] * b[4] + a[4] * b[5] + a[8] * b[6] + a[12] * b[7], a[1] * b[4] + a[5] * b[5] + a[9] * b[6] + a[13] * b[7],
			a[2] * b[4] + a[6] * b[5] + a[10] * b[6] + a[14] * b[7], a[3] * b[4] + a[7] * b[5] + a[11] * b[6] + a[15] * b[7],

			a[0] * b[8] + a[4] * b[9] + a[8] * b[10] + a[12] * b[11], a[1] * b[8] + a[5] * b[9] + a[9] * b[10] + a[13] * b[11],
			a[2] * b[8] + a[6] * b[9] + a[10] * b[10] + a[14] * b[11], a[3] * b[8] + a[7] * b[9] + a[11] * b[10] + a[15] * b[11],

			a[0] * b[12] + a[4] * b[13] + a[8] * b[14] + a[12] * b[15], a[1] * b[12] + a[5] * b[13] + a[9] * b[14] + a[13] * b[15],
			a[2] * b[12] + a[6] * b[13] + a[10] * b[14] + a[14] * b[15], a[3] * b[12] + a[7] * b[13] + a[11] * b[14] + a[15] * b[15]);
	}

	@:op(A * B) public inline function transformVec4(v:Vec4):Vec4 {
		var d:Array<Float> = this.data;

		return new Vec4(d[0] * v.x + d[4] * v.y + d[8] * v.z + d[12] * v.w, d[1] * v.x + d[5] * v.y + d[9] * v.z + d[13] * v.w,
			d[2] * v.x + d[6] * v.y + d[10] * v.z + d[14] * v.w, d[3] * v.x + d[7] * v.y + d[11] * v.z + d[15] * v.w);
	}

	public inline function transpose():Mat4 {
		var d:Array<Float> = this.data;

		return new Mat4(d[0], d[4], d[8], d[12], d[1], d[5], d[9], d[13], d[2], d[6], d[10], d[14], d[3], d[7], d[11], d[15]);
	}

	public static inline function translation(v:Vec3):Mat4 {
		return new Mat4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, v.x, v.y, v.z, 1);
	}

	public static inline function scale(v:Vec3):Mat4 {
		return new Mat4(v.x, 0, 0, 0, 0, v.y, 0, 0, 0, 0, v.z, 0, 0, 0, 0, 1);
	}

	public static inline function rotationX(angle:Float):Mat4 {
		var c:Float = Math.cos(angle), s = Math.sin(angle);

		return new Mat4(1, 0, 0, 0, 0, c, s, 0, 0, -s, c, 0, 0, 0, 0, 1);
	}

	public static inline function rotationY(angle:Float):Mat4 {
		var c:Float = Math.cos(angle), s = Math.sin(angle);

		return new Mat4(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1);
	}

	public static inline function rotationZ(angle:Float):Mat4 {
		var c:Float = Math.cos(angle), s = Math.sin(angle);

		return new Mat4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	public static inline function perspective(fovY:Float, aspect:Float, near:Float, far:Float):Mat4 {
		var f:Float = 1.0 / Math.tan(fovY * 0.5);
		var rangeInv:Float = 1.0 / (near - far);

		return new Mat4(f / aspect, 0, 0, 0, 0, f, 0, 0, 0, 0, (near + far) * rangeInv, -1, 0, 0, near * far * rangeInv * 2, 0);
	}

	public static inline function lookAt(eye:Vec3, target:Vec3, up:Vec3):Mat4 {
		var f:Vec3 = (target - eye).normalized;
		var s:Vec3 = f.cross(up).normalized;
		var u:Vec3 = s.cross(f);

		return new Mat4(s.x, u.x, -f.x, 0, s.y, u.y, -f.y, 0, s.z, u.z, -f.z, 0, -s.dot(eye), -u.dot(eye), f.dot(eye), 1);
	}

	public inline function toArray():Array<Float>
		return this.data.copy();

	public inline function toString():String {
		var d = this.data;
		return
			'Mat4(\n  ${d[0]} ${d[4]} ${d[8]} ${d[12]}\n  ${d[1]} ${d[5]} ${d[9]} ${d[13]}\n  ${d[2]} ${d[6]} ${d[10]} ${d[14]}\n  ${d[3]} ${d[7]} ${d[11]} ${d[15]}\n)';
	}

	public static inline function ortho(left:Float, right:Float, bottom:Float, top:Float, near:Float = -1, far:Float = 1):Mat4 {
		var rl:Float = 1.0 / (right - left);
		var tb:Float = 1.0 / (top - bottom);
		var fn:Float = 1.0 / (far - near);
		return new Mat4(2 * rl, 0, 0, 0, 0, 2 * tb, 0, 0, 0, 0, -2 * fn, 0, -(right + left) * rl, -(top + bottom) * tb, -(far + near) * fn, 1);
	}

	public static function trs(translation:Vec3, rotation:Quat, scale:Vec3):Mat4 {
		var x:Float = rotation.x, y = rotation.y, z = rotation.z, w = rotation.w;
		var x2:Float = x + x, y2 = y + y, z2 = z + z;
		var xx:Float = x * x2, xy = x * y2, xz = x * z2;
		var yy:Float = y * y2, yz = y * z2, zz = z * z2;
		var wx:Float = w * x2, wy = w * y2, wz = w * z2;
		var sx:Float = scale.x, sy = scale.y, sz = scale.z;
		
		return new Mat4((1 - (yy + zz)) * sx, (xy + wz) * sx, (xz - wy) * sx, 0, (xy - wz) * sy, (1 - (xx + zz)) * sy, (yz + wx) * sy, 0, (xz + wy) * sz,
			(yz - wx) * sz, (1 - (xx + yy)) * sz, 0, translation.x, translation.y, translation.z, 1);
	}

	public static function inverseTRS(translation:Vec3, rotation:Quat, scale:Vec3):Mat4 {
		return trs(translation, rotation, scale).affineInverse();
	}

	public inline function affineInverse():Mat4 {
		var d = this.data;

		var t00:Float = d[0], t01 = d[4], t02 = d[8];
		var t10:Float = d[1], t11 = d[5], t12 = d[9];
		var t20:Float = d[2], t21 = d[6], t22 = d[10];

		var tx:Float = -(t00 * d[12] + t10 * d[13] + t20 * d[14]);
		var ty:Float = -(t01 * d[12] + t11 * d[13] + t21 * d[14]);
		var tz:Float = -(t02 * d[12] + t12 * d[13] + t22 * d[14]);

		return new Mat4(t00, t01, t02, 0, t10, t11, t12, 0, t20, t21, t22, 0, tx, ty, tz, 1);
	}

	public inline function getTranslation():Vec3
		return new Vec3(this.data[12], this.data[13], this.data[14]);

	public inline function getScaleVec():Vec3 {
		var d = this.data;
		return new Vec3(Math.sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]), Math.sqrt(d[4] * d[4] + d[5] * d[5] + d[6] * d[6]),
			Math.sqrt(d[8] * d[8] + d[9] * d[9] + d[10] * d[10]));
	}

	public inline function transformPoint(v:Vec3):Vec3 {
		var d = this.data;
		var w = d[3] * v.x + d[7] * v.y + d[11] * v.z + d[15];
		w = w == 0 ? 1 : w;
		return new Vec3((d[0] * v.x + d[4] * v.y + d[8] * v.z + d[12]) / w, (d[1] * v.x + d[5] * v.y + d[9] * v.z + d[13]) / w,
			(d[2] * v.x + d[6] * v.y + d[10] * v.z + d[14]) / w);
	}

	public inline function transformDirection(v:Vec3):Vec3 {
		var d = this.data;
		return new Vec3(d[0] * v.x + d[4] * v.y + d[8] * v.z, d[1] * v.x + d[5] * v.y + d[9] * v.z, d[2] * v.x + d[6] * v.y + d[10] * v.z);
	}

	public inline function toMat3():Mat3 {
		var d = this.data;
		return new Mat3(d[0], d[1], d[2], d[4], d[5], d[6], d[8], d[9], d[10]);
	}
}

@:structInit
private class BaseMat4 {
	public var data:Array<Float>;

	public function new() {
		data = [];
	}
}
