package quark.math;

import lime.utils.Float32Array;

/**
 * A 4x4 Matrix stored in column-major order.
 * Primarily utilized for standard 3D perspective projection and affine transform operations.
 */
@:forward
abstract Mat4(BaseMat4) from BaseMat4 to BaseMat4 {
	
	/**
	 * Standard initialization constructor taking explicit positional values mapping matrix nodes.
	 */
	public inline function new(m00:Float, m10:Float, m20:Float, m30:Float, m01:Float, m11:Float, m21:Float, m31:Float, m02:Float, m12:Float, m22:Float,
			m32:Float, m03:Float, m13:Float, m23:Float, m33:Float) {
		var obj:BaseMat4 = new BaseMat4();
		obj.data[0] = m00;   obj.data[1] = m10;   obj.data[2] = m20;   obj.data[3] = m30;
		obj.data[4] = m01;   obj.data[5] = m11;   obj.data[6] = m21;   obj.data[7] = m31;
		obj.data[8] = m02;   obj.data[9] = m12;   obj.data[10] = m22;  obj.data[11] = m32;
		obj.data[12] = m03;  obj.data[13] = m13;  obj.data[14] = m23;  obj.data[15] = m33;
		this = obj;
	}

	/** Generates a standard identity matrix mapping basic orientations. **/
	public static inline function identity():Mat4
		return new Mat4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

	/** Generates an empty zeroed structural layout matrix. **/
	public static inline function zero():Mat4
		return new Mat4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	/** Assembles a matrix frame structure mapped column vector inputs. **/
	public static inline function fromCols(c0:Vec4, c1:Vec4, c2:Vec4, c3:Vec4):Mat4
		return new Mat4(c0.x, c0.y, c0.z, c0.w, c1.x, c1.y, c1.z, c1.w, c2.x, c2.y, c2.z, c2.w, c3.x, c3.y, c3.z, c3.w);

	/** Assembles a matrix frame structure mapped row vector inputs. **/
	public static inline function fromRows(r0:Vec4, r1:Vec4, r2:Vec4, r3:Vec4):Mat4
		return new Mat4(r0.x, r1.x, r2.x, r3.x, r0.y, r1.y, r2.y, r3.y, r0.z, r1.z, r2.z, r3.z, r0.w, r1.w, r2.w, r3.w);

	/** Assembles a 4x4 rotation matrix using spatial Quaternion values. **/
	public static inline function fromQuat(q:Quat):Mat4 {
		var xx:Float = q.x * q.x, yy:Float = q.y * q.y, zz:Float = q.z * q.z;
		var xy:Float = q.x * q.y, xz:Float = q.x * q.z, yz:Float = q.y * q.z;
		var wx:Float = q.w * q.x, wy:Float = q.w * q.y, wz:Float = q.w * q.z;
		return new Mat4(
			1 - 2 * (yy + zz), 2 * (xy + wz), 2 * (xz - wy), 0,
			2 * (xy - wz), 1 - 2 * (xx + zz), 2 * (yz + wx), 0,
			2 * (xz + wy), 2 * (yz - wx), 1 - 2 * (xx + yy), 0,
			0, 0, 0, 1
		);
	}

	/** Assembles an affine position 3D translation matrix. **/
	public static inline function translation(v:Vec3):Mat4
		return new Mat4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, v.x, v.y, v.z, 1);

	/** Assembles a scaling matrix using scaling factors along the respective axes. **/
	public static inline function scale(v:Vec3):Mat4
		return new Mat4(v.x, 0, 0, 0, 0, v.y, 0, 0, 0, 0, v.z, 0, 0, 0, 0, 1);

	/** Assembles an X-Axis rotation matrix from an angle in radians. **/
	public static inline function rotationX(angle:Float):Mat4 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		return new Mat4(1, 0, 0, 0, 0, c, s, 0, 0, -s, c, 0, 0, 0, 0, 1);
	}

	/** Assembles a Y-Axis rotation matrix from an angle in radians. **/
	public static inline function rotationY(angle:Float):Mat4 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		return new Mat4(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1);
	}

	/** Assembles a Z-Axis rotation matrix from an angle in radians. **/
	public static inline function rotationZ(angle:Float):Mat4 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		return new Mat4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	/** Assembles a custom axis-angle rotation matrix wrapper. **/
	public static inline function rotationAxisAngle(axis:Vec3, angle:Float):Mat4 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle), t:Float = 1 - c;
		var x:Float = axis.x, y:Float = axis.y, z:Float = axis.z;
		return new Mat4(
			t * x * x + c, t * x * y + s * z, t * x * z - s * y, 0,
			t * x * y - s * z, t * y * y + c, t * y * z + s * x, 0,
			t * x * z + s * y, t * y * z - s * x, t * z * z + c, 0,
			0, 0, 0, 1
		);
	}

	/** Combined transformation matrix assembly for Translation, Rotation (Quaternion), and Scale. **/
	public static function trs(t:Vec3, r:Quat, s:Vec3):Mat4 {
		var x:Float = r.x, y:Float = r.y, z:Float = r.z, w:Float = r.w;
		var x2:Float = x + x, y2:Float = y + y, z2:Float = z + z;
		var xx:Float = x * x2, xy:Float = x * y2, xz:Float = x * z2;
		var yy:Float = y * y2, yz:Float = y * z2, zz:Float = z * z2;
		var wx:Float = w * x2, wy:Float = w * y2, wz:Float = w * z2;
		var sx:Float = s.x, sy:Float = s.y, sz:Float = s.z;
		return new Mat4(
			(1 - (yy + zz)) * sx, (xy + wz) * sx, (xz - wy) * sx, 0,
			(xy - wz) * sy, (1 - (xx + zz)) * sy, (yz + wx) * sy, 0,
			(xz + wy) * sz, (yz - wx) * sz, (1 - (xx + yy)) * sz, 0,
			t.x, t.y, t.z, 1
		);
	}

	/** Computes a perspective projection matrix (standard OpenGL/WebGL convention). **/
	public static inline function perspective(fovY:Float, aspect:Float, near:Float, far:Float):Mat4 {
		var f:Float = 1.0 / Math.tan(fovY * 0.5);
		var rangeInv:Float = 1.0 / (near - far);
		return new Mat4(f / aspect, 0, 0, 0, 0, f, 0, 0, 0, 0, (near + far) * rangeInv, -1, 0, 0, near * far * rangeInv * 2.0, 0);
	}

	/** Computes an orthographic projection matrix. **/
	public static inline function ortho(left:Float, right:Float, bottom:Float, top:Float, near:Float = -1, far:Float = 1):Mat4 {
		var rl:Float = 1.0 / (right - left);
		var tb:Float = 1.0 / (top - bottom);
		var fn:Float = 1.0 / (far - near);
		return new Mat4(2 * rl, 0, 0, 0, 0, 2 * tb, 0, 0, 0, 0, -2 * fn, 0, -(right + left) * rl, -(top + bottom) * tb, -(far + near) * fn, 1);
	}

	/** Computes a frustum projection matrix layout boundary tracking block. **/
	public static inline function frustum(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float):Mat4 {
		var rl:Float = 1.0 / (right - left);
		var tb:Float = 1.0 / (top - bottom);
		var nf:Float = 1.0 / (near - far);
		return new Mat4(2 * near * rl, 0, 0, 0, 0, 2 * near * tb, 0, 0, (right + left) * rl, (top + bottom) * tb, (far + near) * nf, -1, 0, 0, 2 * far * near * nf, 0);
	}

	/** Assembles a LookAt view matrix block configuration. **/
	public static inline function lookAt(eye:Vec3, target:Vec3, up:Vec3):Mat4 {
		var f:Vec3 = (target - eye).normalized;
		var s:Vec3 = f.cross(up).normalized;
		var u:Vec3 = s.cross(f);
		return new Mat4(s.x, u.x, -f.x, 0, s.y, u.y, -f.y, 0, s.z, u.z, -f.z, 0, -s.dot(eye), -u.dot(eye), f.dot(eye), 1);
	}

	/** Gets an entry value at the designated row/column index intersections. **/
	public inline function get(row:Int, col:Int):Float
		return this.data[col * 4 + row];

	/** Modifies a targeted node structure entry. Chains fluidly. **/
	public inline function set(row:Int, col:Int, v:Float):Mat4 {
		this.data[col * 4 + row] = v;
		return cast this;
	}

	/** Extracts a indexed column vector wrapper. **/
	public inline function col(i:Int):Vec4
		return new Vec4(this.data[i * 4], this.data[i * 4 + 1], this.data[i * 4 + 2], this.data[i * 4 + 3]);

	/** Extracts a indexed row vector wrapper. **/
	public inline function row(i:Int):Vec4
		return new Vec4(this.data[i], this.data[i + 4], this.data[i + 8], this.data[i + 12]);

	/** Matrix multiplication matrix multiplication operational handler. **/
	@:op(A * B) public inline function multiply(b:Mat4):Mat4 {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		return new Mat4(
			a[0] * d[0] + a[4] * d[1] + a[8] * d[2] + a[12] * d[3], a[1] * d[0] + a[5] * d[1] + a[9] * d[2] + a[13] * d[3], a[2] * d[0] + a[6] * d[1] + a[10] * d[2] + a[14] * d[3], a[3] * d[0] + a[7] * d[1] + a[11] * d[2] + a[15] * d[3],
			a[0] * d[4] + a[4] * d[5] + a[8] * d[6] + a[12] * d[7], a[1] * d[4] + a[5] * d[5] + a[9] * d[6] + a[13] * d[7], a[2] * d[4] + a[6] * d[5] + a[10] * d[6] + a[14] * d[7], a[3] * d[4] + a[7] * d[5] + a[11] * d[6] + a[15] * d[7],
			a[0] * d[8] + a[4] * d[9] + a[8] * d[10] + a[12] * d[11], a[1] * d[8] + a[5] * d[9] + a[9] * d[10] + a[13] * d[11], a[2] * d[8] + a[6] * d[9] + a[10] * d[10] + a[14] * d[11], a[3] * d[8] + a[7] * d[9] + a[11] * d[10] + a[15] * d[11],
			a[0] * d[12] + a[4] * d[13] + a[8] * d[14] + a[12] * d[15], a[1] * d[12] + a[5] * d[13] + a[9] * d[14] + a[13] * d[15], a[2] * d[12] + a[6] * d[13] + a[10] * d[14] + a[14] * d[15], a[3] * d[12] + a[7] * d[13] + a[11] * d[14] + a[15] * d[15]
		);
	}

	/** Transforms a 4D Vector via matrix product operation. **/
	@:op(A * B) public inline function transformVec4(v:Vec4):Vec4 {
		var d:Float32Array = this.data;
		return new Vec4(
			d[0] * v.x + d[4] * v.y + d[8] * v.z + d[12] * v.w, d[1] * v.x + d[5] * v.y + d[9] * v.z + d[13] * v.w,
			d[2] * v.x + d[6] * v.y + d[10] * v.z + d[14] * v.w, d[3] * v.x + d[7] * v.y + d[11] * v.z + d[15] * v.w
		);
	}

	/** Scales all structural components element-wise uniformly using a scalar constant. **/
	@:op(A * B) public inline function multiplyScalar(s:Float):Mat4 {
		var d:Float32Array = this.data;
		return new Mat4(d[0] * s, d[1] * s, d[2] * s, d[3] * s, d[4] * s, d[5] * s, d[6] * s, d[7] * s, d[8] * s, d[9] * s, d[10] * s, d[11] * s, d[12] * s, d[13] * s, d[14] * s, d[15] * s);
	}

	/** Performs element-wise addition over matrix structures. **/
	@:op(A + B) public inline function add(b:Mat4):Mat4 {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		return new Mat4(
			a[0] + d[0], a[1] + d[1], a[2] + d[2], a[3] + d[3], a[4] + d[4], a[5] + d[5], a[6] + d[6], a[7] + d[7], a[8] + d[8], a[9] + d[9],
			a[10] + d[10], a[11] + d[11], a[12] + d[12], a[13] + d[13], a[14] + d[14], a[15] + d[15]
		);
	}

	/** Performs element-wise matrix subtraction loops. **/
	@:op(A - B) public inline function subtract(b:Mat4):Mat4 {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		return new Mat4(
			a[0] - d[0], a[1] - d[1], a[2] - d[2], a[3] - d[3], a[4] - d[4], a[5] - d[5], a[6] - d[6], a[7] - d[7], a[8] - d[8], a[9] - d[9],
			a[10] - d[10], a[11] - d[11], a[12] - d[12], a[13] - d[13], a[14] - d[14], a[15] - d[15]
		);
	}

	/** Transposes matrix orientation positions across columns and rows. **/
	public inline function transpose():Mat4 {
		var d:Float32Array = this.data;
		return new Mat4(d[0], d[4], d[8], d[12], d[1], d[5], d[9], d[13], d[2], d[6], d[10], d[14], d[3], d[7], d[11], d[15]);
	}

	/** Calculates the determinant value of this 4x4 matrix frame. **/
	public inline function determinant():Float {
		var d:Float32Array = this.data;
		var b00:Float = d[0] * d[5] - d[1] * d[4];
		var b01:Float = d[0] * d[6] - d[2] * d[4];
		var b02:Float = d[0] * d[7] - d[3] * d[4];
		var b03:Float = d[1] * d[6] - d[2] * d[5];
		var b04:Float = d[1] * d[7] - d[3] * d[5];
		var b05:Float = d[2] * d[7] - d[3] * d[6];
		var b06:Float = d[8] * d[13] - d[9] * d[12];
		var b07:Float = d[8] * d[14] - d[10] * d[12];
		var b08:Float = d[8] * d[15] - d[11] * d[12];
		var b09:Float = d[9] * d[14] - d[10] * d[13];
		var b10:Float = d[9] * d[15] - d[11] * d[13];
		var b11:Float = d[10] * d[15] - d[11] * d[14];
		return b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;
	}

	/** Computes the general 4x4 algebraic inverse matrix structure. **/
	public inline function inverse():Mat4 {
		var d:Float32Array = this.data;
		var b00:Float = d[0] * d[5] - d[1] * d[4];
		var b01:Float = d[0] * d[6] - d[2] * d[4];
		var b02:Float = d[0] * d[7] - d[3] * d[4];
		var b03:Float = d[1] * d[6] - d[2] * d[5];
		var b04:Float = d[1] * d[7] - d[3] * d[5];
		var b05:Float = d[2] * d[7] - d[3] * d[6];
		var b06:Float = d[8] * d[13] - d[9] * d[12];
		var b07:Float = d[8] * d[14] - d[10] * d[12];
		var b08:Float = d[8] * d[15] - d[11] * d[12];
		var b09:Float = d[9] * d[14] - d[10] * d[13];
		var b10:Float = d[9] * d[15] - d[11] * d[13];
		var b11:Float = d[10] * d[15] - d[11] * d[14];
		var det:Float = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;
		if (Math.abs(det) < 1e-10)
			return Mat4.identity();
		var inv:Float = 1.0 / det;
		return new Mat4(
			(d[5] * b11 - d[6] * b10 + d[7] * b09) * inv, (-d[1] * b11 + d[2] * b10 - d[3] * b09) * inv, (d[13] * b05 - d[14] * b04 + d[15] * b03) * inv, (-d[9] * b05 + d[10] * b04 - d[11] * b03) * inv, 
			(-d[4] * b11 + d[6] * b08 - d[7] * b07) * inv, (d[0] * b11 - d[2] * b08 + d[3] * b07) * inv, (-d[12] * b05 + d[14] * b02 - d[15] * b01) * inv, (d[8] * b05 - d[10] * b02 + d[11] * b01) * inv,
			(d[4] * b10 - d[5] * b08 + d[7] * b06) * inv, (-d[0] * b10 + d[1] * b08 - d[3] * b06) * inv, (d[12] * b04 - d[13] * b02 + d[15] * b00) * inv, (-d[8] * b04 + d[9] * b02 - d[11] * b00) * inv, 
			(-d[4] * b09 + d[5] * b07 - d[6] * b06) * inv, (d[0] * b09 - d[1] * b07 + d[2] * b06) * inv, (-d[12] * b03 + d[13] * b01 - d[14] * b00) * inv, (d[8] * b03 - d[9] * b01 + d[10] * b00) * inv
		);
	}

	/** Fast-path inverse operation specialized for raw Affine transformations lacking skew profiles. **/
	public inline function affineInverse():Mat4 {
		var d:Float32Array = this.data;
		var t00:Float = d[0], t01:Float = d[4], t02:Float = d[8];
		var t10:Float = d[1], t11:Float = d[5], t12:Float = d[9];
		var t20:Float = d[2], t21:Float = d[6], t22:Float = d[10];
		var tx:Float = -(t00 * d[12] + t10 * d[13] + t20 * d[14]);
		var ty:Float = -(t01 * d[12] + t11 * d[13] + t21 * d[14]);
		var tz:Float = -(t02 * d[12] + t12 * d[13] + t22 * d[14]);
		return new Mat4(t00, t01, t02, 0, t10, t11, t12, 0, t20, t21, t22, 0, tx, ty, tz, 1);
	}

	/** Decomposes structural transforms to extract localized Translation, Rotation (Quaternion) and Scale elements. **/
	public inline function decompose(outTranslation:Vec3, outRotation:Quat, outScale:Vec3):Void {
		var d:Float32Array = this.data;
		var sx:Float = Math.sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
		var sy:Float = Math.sqrt(d[4] * d[4] + d[5] * d[5] + d[6] * d[6]);
		var sz:Float = Math.sqrt(d[8] * d[8] + d[9] * d[9] + d[10] * d[10]);
		if (determinant() < 0)
			sx = -sx;
		outTranslation.x = d[12];
		outTranslation.y = d[13];
		outTranslation.z = d[14];
		outScale.x = sx;
		outScale.y = sy;
		outScale.z = sz;
		var isx:Float = 1 / sx, isy:Float = 1 / sy, isz:Float = 1 / sz;
		var rm:Mat3 = new Mat3(d[0] * isx, d[1] * isx, d[2] * isx, d[4] * isy, d[5] * isy, d[6] * isy, d[8] * isz, d[9] * isz, d[10] * isz);
		outRotation.setFromMat3(rm);
	}

	/** Transforms a 3D coordinate point coordinate by processing perspective dividing configurations. **/
	public inline function transformPoint(v:Vec3):Vec3 {
		var d:Float32Array = this.data;
		var w:Float = d[3] * v.x + d[7] * v.y + d[11] * v.z + d[15];
		w = w == 0 ? 1 : w;
		return new Vec3((d[0] * v.x + d[4] * v.y + d[8] * v.z + d[12]) / w, (d[1] * v.x + d[5] * v.y + d[9] * v.z + d[13]) / w, (d[2] * v.x + d[6] * v.y + d[10] * v.z + d[14]) / w);
	}

	/** Transforms a spatial direction vector sequence (Omits translational properties). **/
	public inline function transformDirection(v:Vec3):Vec3 {
		var d:Float32Array = this.data;
		return new Vec3(d[0] * v.x + d[4] * v.y + d[8] * v.z, d[1] * v.x + d[5] * v.y + d[9] * v.z, d[2] * v.x + d[6] * v.y + d[10] * v.z);
	}

	/** Transforms a normal vector safely utilizing the correct normal matrix inverse transpose pipeline. **/
	public inline function transformNormal(v:Vec3):Vec3 {
		var n:Mat3 = Mat3.normalMatrix(cast this);
		return n * v;
	}

	/** Extracts the translation vector component directly. **/
	public inline function getTranslation():Vec3
		return new Vec3(this.data[12], this.data[13], this.data[14]);

	/** Extracts localized structural scaling factors. **/
	public inline function getScale():Vec3 {
		var d:Float32Array = this.data;
		return new Vec3(Math.sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]), Math.sqrt(d[4] * d[4] + d[5] * d[5] + d[6] * d[6]), Math.sqrt(d[8] * d[8] + d[9] * d[9] + d[10] * d[10]));
	}

	/** Truncates this matrix into a 3x3 instance data block. **/
	public inline function toMat3():Mat3 {
		var d:Float32Array = this.data;
		return new Mat3(d[0], d[1], d[2], d[4], d[5], d[6], d[8], d[9], d[10]);
	}

	/** Strict structure equivalence testing operator. **/
	@:op(A == B) public inline function equals(b:Mat4):Bool {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		for (i in 0...16)
			if (a[i] != d[i])
				return false;
		return true;
	}

	/** Absolute approximate epsilon floating-point bounds variance validation checker. **/
	public inline function approximately(b:Mat4, eps:Float = 1e-6):Bool {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		for (i in 0...16)
			if (Math.abs(a[i] - d[i]) > eps)
				return false;
		return true;
	}

	/** Returns a raw standard Array element representation copy. **/
	public inline function toArray():Array<Float> {
		var arr = [];
		for (i in 0...16) arr.push(this.data[i]);
		return arr;
	}

	/** Copies elements sequentially inside basic linear arrays. **/
	public inline function copyInto(target:Array<Float>, offset:Int = 0):Void {
		var d:Float32Array = this.data;
		for (i in 0...16)
			target[offset + i] = d[i];
	}

	/** String conversion presentation helper layout layout. **/
	public inline function toString():String {
		var d:Float32Array = this.data;
		return 'Mat4(\n' + '  ${d[0]} ${d[4]} ${d[8]}  ${d[12]}\n' + '  ${d[1]} ${d[5]} ${d[9]}  ${d[13]}\n' + '  ${d[2]} ${d[6]} ${d[10]} ${d[14]}\n' + '  ${d[3]} ${d[7]} ${d[11]} ${d[15]}\n)';
	}

	// ── In-place mutating methods ────────────────────────────────────────────

	/**
	 * Sets all sixteen elements of this matrix from individual component values.
	 * @return This matrix after modification.
	 */
	public inline function setComponents(m00:Float, m10:Float, m20:Float, m30:Float, m01:Float, m11:Float, m21:Float, m31:Float, m02:Float, m12:Float,
			m22:Float, m32:Float, m03:Float, m13:Float, m23:Float, m33:Float):Mat4 {
		this.data[0] = m00;  this.data[1] = m10;  this.data[2] = m20;  this.data[3] = m30;
		this.data[4] = m01;  this.data[5] = m11;  this.data[6] = m21;  this.data[7] = m31;
		this.data[8] = m02;  this.data[9] = m12;  this.data[10] = m22; this.data[11] = m32;
		this.data[12] = m03; this.data[13] = m13; this.data[14] = m23; this.data[15] = m33;
		return cast this;
	}

	/**
	 * Copies all elements from matrix `b` into this matrix in place.
	 * @param b The source matrix.
	 * @return This matrix after modification.
	 */
	public inline function copyFromEq(b:Mat4):Mat4 {
		var d:Float32Array = b.data;
		for (i in 0...16) this.data[i] = d[i];
		return cast this;
	}

	/**
	 * Sets this matrix to the identity matrix in place.
	 * @return This matrix after modification.
	 */
	public inline function setIdentityEq():Mat4 {
		var d:Float32Array = this.data;
		d[0] = 1; d[1] = 0; d[2] = 0;  d[3] = 0;
		d[4] = 0; d[5] = 1; d[6] = 0;  d[7] = 0;
		d[8] = 0; d[9] = 0; d[10] = 1; d[11] = 0;
		d[12] = 0; d[13] = 0; d[14] = 0; d[15] = 1;
		return cast this;
	}

	/**
	 * Sets this matrix to the zero matrix in place.
	 * @return This matrix after modification.
	 */
	public inline function setZeroEq():Mat4 {
		for (i in 0...16) this.data[i] = 0;
		return cast this;
	}

	/**
	 * Multiplies this matrix by `b` in place (this = this * b).
	 * @param b The right-hand matrix operand.
	 * @return This matrix after modification.
	 */
	public inline function multiplyEq(b:Mat4):Mat4 {
		copyFromEq((cast this : Mat4) * b);
		return cast this;
	}

	/**
	 * Scales every element of this matrix by `s` in place.
	 * @param s The scalar factor.
	 * @return This matrix after modification.
	 */
	public inline function multiplyScalarEq(s:Float):Mat4 {
		for (i in 0...16) this.data[i] *= s;
		return cast this;
	}

	/**
	 * Adds matrix `b` element-wise to this matrix in place.
	 * @param b The matrix to add.
	 * @return This matrix after modification.
	 */
	public inline function addEq(b:Mat4):Mat4 {
		var d:Float32Array = b.data;
		for (i in 0...16) this.data[i] += d[i];
		return cast this;
	}

	/**
	 * Subtracts matrix `b` element-wise from this matrix in place.
	 * @param b The matrix to subtract.
	 * @return This matrix after modification.
	 */
	public inline function subtractEq(b:Mat4):Mat4 {
		var d:Float32Array = b.data;
		for (i in 0...16) this.data[i] -= d[i];
		return cast this;
	}

	/**
	 * Transposes this matrix in place (swaps rows and columns).
	 * @return This matrix after modification.
	 */
	public inline function transposeEq():Mat4 {
		var d:Float32Array = this.data;
		var t:Float;
		t = d[1];  d[1]  = d[4];  d[4]  = t;
		t = d[2];  d[2]  = d[8];  d[8]  = t;
		t = d[3];  d[3]  = d[12]; d[12] = t;
		t = d[6];  d[6]  = d[9];  d[9]  = t;
		t = d[7];  d[7]  = d[13]; d[13] = t;
		t = d[11]; d[11] = d[14]; d[14] = t;
		return cast this;
	}

	/**
	 * Inverts this matrix in place using the full 4x4 algebraic inverse.
	 * Falls back to identity if the determinant is near zero.
	 * @return This matrix after modification.
	 */
	public inline function inverseEq():Mat4 {
		copyFromEq(inverse());
		return cast this;
	}

	/**
	 * Inverts this matrix in place using the fast affine-inverse path.
	 * Only correct for matrices without shear or non-uniform scale.
	 * @return This matrix after modification.
	 */
	public inline function affineInverseEq():Mat4 {
		copyFromEq(affineInverse());
		return cast this;
	}

	/**
	 * Sets this matrix from a quaternion in place.
	 * @param q The source quaternion.
	 * @return This matrix after modification.
	 */
	public inline function setFromQuatEq(q:Quat):Mat4 {
		copyFromEq(Mat4.fromQuat(q));
		return cast this;
	}

	/**
	 * Sets this matrix to a translation matrix in place.
	 * @param v The translation vector.
	 * @return This matrix after modification.
	 */
	public inline function setTranslationEq(v:Vec3):Mat4 {
		copyFromEq(Mat4.translation(v));
		return cast this;
	}

	/**
	 * Sets this matrix to a scaling matrix in place.
	 * @param v The scale vector.
	 * @return This matrix after modification.
	 */
	public inline function setScaleEq(v:Vec3):Mat4 {
		copyFromEq(Mat4.scale(v));
		return cast this;
	}

	/**
	 * Sets this matrix to an X-axis rotation matrix in place.
	 * @param angle The rotation angle in radians.
	 * @return This matrix after modification.
	 */
	public inline function setRotationXEq(angle:Float):Mat4 {
		copyFromEq(Mat4.rotationX(angle));
		return cast this;
	}

	/**
	 * Sets this matrix to a Y-axis rotation matrix in place.
	 * @param angle The rotation angle in radians.
	 * @return This matrix after modification.
	 */
	public inline function setRotationYEq(angle:Float):Mat4 {
		copyFromEq(Mat4.rotationY(angle));
		return cast this;
	}

	/**
	 * Sets this matrix to a Z-axis rotation matrix in place.
	 * @param angle The rotation angle in radians.
	 * @return This matrix after modification.
	 */
	public inline function setRotationZEq(angle:Float):Mat4 {
		copyFromEq(Mat4.rotationZ(angle));
		return cast this;
	}

	/**
	 * Sets this matrix to a TRS (Translation, Rotation, Scale) matrix in place.
	 * @param t The translation vector.
	 * @param r The rotation quaternion.
	 * @param s The scale vector.
	 * @return This matrix after modification.
	 */
	public inline function setTrsEq(t:Vec3, r:Quat, s:Vec3):Mat4 {
		copyFromEq(Mat4.trs(t, r, s));
		return cast this;
	}

	/**
	 * Sets this matrix to a perspective projection matrix in place.
	 * @param fovY Vertical field-of-view in radians.
	 * @param aspect Aspect ratio (width / height).
	 * @param near Near clip plane distance.
	 * @param far Far clip plane distance.
	 * @return This matrix after modification.
	 */
	public inline function setPerspectiveEq(fovY:Float, aspect:Float, near:Float, far:Float):Mat4 {
		copyFromEq(Mat4.perspective(fovY, aspect, near, far));
		return cast this;
	}

	/**
	 * Sets this matrix to an orthographic projection matrix in place.
	 * @param left Left clip plane.
	 * @param right Right clip plane.
	 * @param bottom Bottom clip plane.
	 * @param top Top clip plane.
	 * @param near Near clip plane (default: -1).
	 * @param far Far clip plane (default: 1).
	 * @return This matrix after modification.
	 */
	public inline function setOrthoEq(left:Float, right:Float, bottom:Float, top:Float, near:Float = -1, far:Float = 1):Mat4 {
		copyFromEq(Mat4.ortho(left, right, bottom, top, near, far));
		return cast this;
	}

	/**
	 * Sets this matrix to a lookAt view matrix in place.
	 * @param eye The camera position.
	 * @param target The point to look at.
	 * @param up The up direction vector.
	 * @return This matrix after modification.
	 */
	public inline function setLookAtEq(eye:Vec3, target:Vec3, up:Vec3):Mat4 {
		copyFromEq(Mat4.lookAt(eye, target, up));
		return cast this;
	}
}

@:structInit
private class BaseMat4 {
	public var data:Float32Array;

	public function new() {
		data = new Float32Array(16);
	}
}