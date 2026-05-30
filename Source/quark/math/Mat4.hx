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
}

@:structInit
private class BaseMat4 {
	public var data:Array<Float>;

	public function new() {
		data = [];
	}
}
