package quark.math;

@:forward
abstract Mat3(BaseMat3) from BaseMat3 to BaseMat3 {
	public inline function new(m00:Float, m10:Float, m20:Float, m01:Float, m11:Float, m21:Float, m02:Float, m12:Float, m22:Float) {
		var obj:BaseMat3 = new BaseMat3();
		obj.data = [m00, m10, m20, m01, m11, m21, m02, m12, m22];
		this = obj;
	}

	public static inline function identity():Mat3
		return new Mat3(1, 0, 0, 0, 1, 0, 0, 0, 1);

	public static inline function zero():Mat3
		return new Mat3(0, 0, 0, 0, 0, 0, 0, 0, 0);

	public static inline function fromCols(c0:Vec3, c1:Vec3, c2:Vec3):Mat3
		return new Mat3(c0.x, c0.y, c0.z, c1.x, c1.y, c1.z, c2.x, c2.y, c2.z);

	public static inline function fromRows(r0:Vec3, r1:Vec3, r2:Vec3):Mat3
		return new Mat3(r0.x, r1.x, r2.x, r0.y, r1.y, r2.y, r0.z, r1.z, r2.z);

	public static inline function fromMat4(m:Mat4):Mat3 {
		var d:Array<Float> = m.data;
		return new Mat3(d[0], d[1], d[2], d[4], d[5], d[6], d[8], d[9], d[10]);
	}

	public static inline function fromQuat(q:Quat):Mat3 {
		var xx:Float = q.x * q.x, yy:Float = q.y * q.y, zz:Float = q.z * q.z;
		var xy:Float = q.x * q.y, xz:Float = q.x * q.z, yz:Float = q.y * q.z;
		var wx:Float = q.w * q.x, wy:Float = q.w * q.y, wz:Float = q.w * q.z;
		return new Mat3(1
			- 2 * (yy + zz), 2 * (xy + wz), 2 * (xz - wy), 2 * (xy - wz), 1
			- 2 * (xx + zz), 2 * (yz + wx), 2 * (xz + wy), 2 * (yz - wx),
			1
			- 2 * (xx + yy));
	}

	public static inline function normalMatrix(model:Mat4):Mat3
		return Mat3.fromMat4(model).inverse().transpose();

	public static inline function translation2D(x:Float, y:Float):Mat3
		return new Mat3(1, 0, 0, 0, 1, 0, x, y, 1);

	public static inline function scale2D(x:Float, y:Float):Mat3
		return new Mat3(x, 0, 0, 0, y, 0, 0, 0, 1);

	public static inline function rotation2D(angle:Float):Mat3 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		return new Mat3(c, s, 0, -s, c, 0, 0, 0, 1);
	}

	public static inline function trs2D(tx:Float, ty:Float, angle:Float, sx:Float, sy:Float):Mat3 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		return new Mat3(c * sx, s * sx, 0, -s * sy, c * sy, 0, tx, ty, 1);
	}

	public inline function get(row:Int, col:Int):Float
		return this.data[col * 3 + row];

	public inline function set(row:Int, col:Int, v:Float):Mat3 {
		this.data[col * 3 + row] = v;
		return cast this;
	}

	public inline function col(i:Int):Vec3
		return new Vec3(this.data[i * 3], this.data[i * 3 + 1], this.data[i * 3 + 2]);

	public inline function row(i:Int):Vec3
		return new Vec3(this.data[i], this.data[i + 3], this.data[i + 6]);

	@:op(A * B) public inline function multiply(b:Mat3):Mat3 {
		var a:Array<Float> = this.data, d:Array<Float> = b.data;
		return new Mat3(a[0] * d[0] + a[3] * d[1] + a[6] * d[2], a[1] * d[0] + a[4] * d[1] + a[7] * d[2], a[2] * d[0] + a[5] * d[1] + a[8] * d[2],

			a[0] * d[3] + a[3] * d[4] + a[6] * d[5], a[1] * d[3] + a[4] * d[4] + a[7] * d[5], a[2] * d[3] + a[5] * d[4] + a[8] * d[5],

			a[0] * d[6] + a[3] * d[7] + a[6] * d[8], a[1] * d[6] + a[4] * d[7] + a[7] * d[8], a[2] * d[6] + a[5] * d[7] + a[8] * d[8]);
	}

	@:op(A * B) public inline function transformVec3(v:Vec3):Vec3 {
		var d:Array<Float> = this.data;
		return new Vec3(d[0] * v.x + d[3] * v.y + d[6] * v.z, d[1] * v.x + d[4] * v.y + d[7] * v.z, d[2] * v.x + d[5] * v.y + d[8] * v.z);
	}

	@:op(A * B) public inline function multiplyScalar(s:Float):Mat3 {
		var d:Array<Float> = this.data;
		return new Mat3(d[0] * s, d[1] * s, d[2] * s, d[3] * s, d[4] * s, d[5] * s, d[6] * s, d[7] * s, d[8] * s);
	}

	@:op(A + B) public inline function add(b:Mat3):Mat3 {
		var a:Array<Float> = this.data, d:Array<Float> = b.data;
		return new Mat3(a[0] + d[0], a[1] + d[1], a[2] + d[2], a[3] + d[3], a[4] + d[4], a[5] + d[5], a[6] + d[6], a[7] + d[7], a[8] + d[8]);
	}

	@:op(A - B) public inline function subtract(b:Mat3):Mat3 {
		var a:Array<Float> = this.data, d:Array<Float> = b.data;
		return new Mat3(a[0] - d[0], a[1] - d[1], a[2] - d[2], a[3] - d[3], a[4] - d[4], a[5] - d[5], a[6] - d[6], a[7] - d[7], a[8] - d[8]);
	}

	public inline function transpose():Mat3 {
		var d:Array<Float> = this.data;
		return new Mat3(d[0], d[3], d[6], d[1], d[4], d[7], d[2], d[5], d[8]);
	}

	public inline function determinant():Float {
		var d:Array<Float> = this.data;
		return d[0] * (d[4] * d[8] - d[7] * d[5]) - d[3] * (d[1] * d[8] - d[7] * d[2]) + d[6] * (d[1] * d[5] - d[4] * d[2]);
	}

	public inline function adjugate():Mat3 {
		var d:Array<Float> = this.data;
		return new Mat3((d[4] * d[8] - d[5] * d[7]),
			-(d[1] * d[8] - d[2] * d[7]), (d[1] * d[5] - d[2] * d[4]),
			-(d[3] * d[8] - d[5] * d[6]),
			(d[0] * d[8] - d[2] * d[6]),
			-(d[0] * d[5] - d[2] * d[3]), (d[3] * d[7] - d[4] * d[6]),
			-(d[0] * d[7] - d[1] * d[6]), (d[0] * d[4] - d[1] * d[3]));
	}

	public inline function inverse():Mat3 {
		var det:Float = determinant();

		if (Math.abs(det) < 1e-10)
			return Mat3.identity();
		
		return adjugate().multiplyScalar(1.0 / det);
	}

	public inline function transformPoint(v:Vec2):Vec2 {
		var d:Array<Float> = this.data;

		return new Vec2(d[0] * v.x + d[3] * v.y + d[6], d[1] * v.x + d[4] * v.y + d[7]);
	}

	public inline function transformDirection(v:Vec2):Vec2 {
		var d:Array<Float> = this.data;

		return new Vec2(d[0] * v.x + d[3] * v.y, d[1] * v.x + d[4] * v.y);
	}

	public inline function getTranslation2D():Vec2
		return new Vec2(this.data[6], this.data[7]);

	@:op(A == B) public inline function equals(b:Mat3):Bool {
		var a:Array<Float> = this.data, d:Array<Float> = b.data;

		for (i in 0...9)
			if (a[i] != d[i])
				return false;
		return true;
	}

	public inline function approximately(b:Mat3, eps:Float = 1e-6):Bool {
		var a:Array<Float> = this.data, d:Array<Float> = b.data;

		for (i in 0...9)
			if (Math.abs(a[i] - d[i]) > eps)
				return false;
		return true;
	}

	public inline function toArray():Array<Float>
		return this.data.copy();

	public inline function copyInto(target:Array<Float>, offset:Int = 0):Void {
		var d:Array<Float> = this.data;
		for (i in 0...9)
			target[offset + i] = d[i];
	}

	public inline function toString():String {
		var d:Array<Float> = this.data;
		return 'Mat3(\n  ${d[0]} ${d[3]} ${d[6]}\n  ${d[1]} ${d[4]} ${d[7]}\n  ${d[2]} ${d[5]} ${d[8]}\n)';
	}
}

@:structInit
private class BaseMat3 {
	public var data:Array<Float>;

	public function new() {
		data = [];
	}
}
