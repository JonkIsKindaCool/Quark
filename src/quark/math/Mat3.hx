package quark.math;

import lime.utils.Float32Array;

/**
 * A 3x3 Matrix stored in column-major order.
 * Optimized for low-allocation operations utilizing a `Float32Array`.
 */
@:forward
abstract Mat3(BaseMat3) from BaseMat3 to BaseMat3 {
	
	/**
	 * Constructs a new 3x3 matrix from individual component values.
	 * Values map matching mathematical notations ($m_{\text{row,col}}$).
	 */
	public inline function new(m00:Float, m10:Float, m20:Float, m01:Float, m11:Float, m21:Float, m02:Float, m12:Float, m22:Float) {
		var obj:BaseMat3 = new BaseMat3();
		obj.data[0] = m00; obj.data[1] = m10; obj.data[2] = m20;
		obj.data[3] = m01; obj.data[4] = m11; obj.data[5] = m21;
		obj.data[6] = m02; obj.data[7] = m12; obj.data[8] = m22;
		this = obj;
	}

	/**
	 * Generates a new 3x3 identity matrix.
	 */
	public static inline function identity():Mat3
		return new Mat3(1, 0, 0, 0, 1, 0, 0, 0, 1);

	/**
	 * Generates a new 3x3 zero matrix.
	 */
	public static inline function zero():Mat3
		return new Mat3(0, 0, 0, 0, 0, 0, 0, 0, 0);

	/**
	 * Creates a matrix where columns are populated directly from 3D vectors.
	 */
	public static inline function fromCols(c0:Vec3, c1:Vec3, c2:Vec3):Mat3
		return new Mat3(c0.x, c0.y, c0.z, c1.x, c1.y, c1.z, c2.x, c2.y, c2.z);

	/**
	 * Creates a matrix where rows are populated directly from 3D vectors.
	 */
	public static inline function fromRows(r0:Vec3, r1:Vec3, r2:Vec3):Mat3
		return new Mat3(r0.x, r1.x, r2.x, r0.y, r1.y, r2.y, r0.z, r1.z, r2.z);

	/**
	 * Extracts the upper-left 3x3 submatrix from a 4x4 matrix.
	 */
	public static inline function fromMat4(m:Mat4):Mat3 {
		var d:Float32Array = m.data;
		return new Mat3(d[0], d[1], d[2], d[4], d[5], d[6], d[8], d[9], d[10]);
	}

	/**
	 * Generates a 3x3 pure rotation matrix from a Quaternion.
	 */
	public static inline function fromQuat(q:Quat):Mat3 {
		var xx:Float = q.x * q.x, yy:Float = q.y * q.y, zz:Float = q.z * q.z;
		var xy:Float = q.x * q.y, xz:Float = q.x * q.z, yz:Float = q.y * q.z;
		var wx:Float = q.w * q.x, wy:Float = q.w * q.y, wz:Float = q.w * q.z;
		return new Mat3(
			1 - 2 * (yy + zz), 2 * (xy + wz), 2 * (xz - wy), 
			2 * (xy - wz), 1 - 2 * (xx + zz), 2 * (yz + wx), 
			2 * (xz + wy), 2 * (yz - wx), 1 - 2 * (xx + yy)
		);
	}

	/**
	 * Computes the specialized 3x3 normal matrix ($\mathbf{M}^{-1\top}$) from a 4x4 Model matrix.
	 */
	public static inline function normalMatrix(model:Mat4):Mat3
		return Mat3.fromMat4(model).inverse().transpose();

	/**
	 * Creates an affine 2D translation matrix.
	 */
	public static inline function translation2D(x:Float, y:Float):Mat3
		return new Mat3(1, 0, 0, 0, 1, 0, x, y, 1);

	/**
	 * Creates an affine 2D scaling matrix.
	 */
	public static inline function scale2D(x:Float, y:Float):Mat3
		return new Mat3(x, 0, 0, 0, y, 0, 0, 0, 1);

	/**
	 * Creates an affine 2D rotation matrix from an angle in radians.
	 */
	public static inline function rotation2D(angle:Float):Mat3 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		return new Mat3(c, s, 0, -s, c, 0, 0, 0, 1);
	}

	/**
	 * Creates a combined 2D Translation, Rotation, and Scale matrix.
	 */
	public static inline function trs2D(tx:Float, ty:Float, angle:Float, sx:Float, sy:Float):Mat3 {
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		return new Mat3(c * sx, s * sx, 0, -s * sy, c * sy, 0, tx, ty, 1);
	}

	/**
	 * Retrieves an entry at a specified row and column indices.
	 */
	public inline function get(row:Int, col:Int):Float
		return this.data[col * 3 + row];

	/**
	 * Modifies an entry value at the given row and column. Chains fluidly.
	 */
	public inline function set(row:Int, col:Int, v:Float):Mat3 {
		this.data[col * 3 + row] = v;
		return cast this;
	}

	/** Extracts a specified column as a 3D Vector. **/
	public inline function col(i:Int):Vec3
		return new Vec3(this.data[i * 3], this.data[i * 3 + 1], this.data[i * 3 + 2]);

	/** Extracts a specified row as a 3D Vector. **/
	public inline function row(i:Int):Vec3
		return new Vec3(this.data[i], this.data[i + 3], this.data[i + 6]);

	/**
	 * Matrix-matrix multiplication operator overload.
	 */
	@:op(A * B) public inline function multiply(b:Mat3):Mat3 {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		return new Mat3(
			a[0] * d[0] + a[3] * d[1] + a[6] * d[2], a[1] * d[0] + a[4] * d[1] + a[7] * d[2], a[2] * d[0] + a[5] * d[1] + a[8] * d[2],
			a[0] * d[3] + a[3] * d[4] + a[6] * d[5], a[1] * d[3] + a[4] * d[4] + a[7] * d[5], a[2] * d[3] + a[5] * d[4] + a[8] * d[5],
			a[0] * d[6] + a[3] * d[7] + a[6] * d[8], a[1] * d[6] + a[4] * d[7] + a[7] * d[8], a[2] * d[6] + a[5] * d[7] + a[8] * d[8]
		);
	}

	/**
	 * Transforms a `Vec3` by multiplying it with this matrix.
	 */
	@:op(A * B) public inline function transformVec3(v:Vec3):Vec3 {
		var d:Float32Array = this.data;
		return new Vec3(d[0] * v.x + d[3] * v.y + d[6] * v.z, d[1] * v.x + d[4] * v.y + d[7] * v.z, d[2] * v.x + d[5] * v.y + d[8] * v.z);
	}

	/**
	 * Scales every component element uniformly by a scalar factor.
	 */
	@:op(A * B) public inline function multiplyScalar(s:Float):Mat3 {
		var d:Float32Array = this.data;
		return new Mat3(d[0] * s, d[1] * s, d[2] * s, d[3] * s, d[4] * s, d[5] * s, d[6] * s, d[7] * s, d[8] * s);
	}

	/**
	 * Element-wise matrix addition operator overload.
	 */
	@:op(A + B) public inline function add(b:Mat3):Mat3 {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		return new Mat3(a[0] + d[0], a[1] + d[1], a[2] + d[2], a[3] + d[3], a[4] + d[4], a[5] + d[5], a[6] + d[6], a[7] + d[7], a[8] + d[8]);
	}

	/**
	 * Element-wise matrix subtraction operator overload.
	 */
	@:op(A - B) public inline function subtract(b:Mat3):Mat3 {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		return new Mat3(a[0] - d[0], a[1] - d[1], a[2] - d[2], a[3] - d[3], a[4] - d[4], a[5] - d[5], a[6] - d[6], a[7] - d[7], a[8] - d[8]);
	}

	/**
	 * Returns a transposed copy of this matrix (swapping rows for columns).
	 */
	public inline function transpose():Mat3 {
		var d:Float32Array = this.data;
		return new Mat3(d[0], d[3], d[6], d[1], d[4], d[7], d[2], d[5], d[8]);
	}

	/**
	 * Computes the scalar determinant of this 3x3 matrix.
	 */
	public inline function determinant():Float {
		var d:Float32Array = this.data;
		return d[0] * (d[4] * d[8] - d[7] * d[5]) - d[3] * (d[1] * d[8] - d[7] * d[2]) + d[6] * (d[1] * d[5] - d[4] * d[2]);
	}

	/**
	 * Calculates the adjugate matrix.
	 */
	public inline function adjugate():Mat3 {
		var d:Float32Array = this.data;
		return new Mat3(
			(d[4] * d[8] - d[5] * d[7]), -(d[1] * d[8] - d[2] * d[7]), (d[1] * d[5] - d[2] * d[4]),
			-(d[3] * d[8] - d[5] * d[6]), (d[0] * d[8] - d[2] * d[6]), -(d[0] * d[5] - d[2] * d[3]), 
			(d[3] * d[7] - d[4] * d[6]), -(d[0] * d[7] - d[1] * d[6]), (d[0] * d[4] - d[1] * d[3])
		);
	}

	/**
	 * Returns the matrix inverse. If the determinant falls below evaluation limits, identity is fallback.
	 */
	public inline function inverse():Mat3 {
		var det:Float = determinant();
		if (Math.abs(det) < 1e-10)
			return Mat3.identity();
		return adjugate().multiplyScalar(1.0 / det);
	}

	/**
	 * Transforms an affine 2D coordinate point (incorporates implicit matrix translations).
	 */
	public inline function transformPoint(v:Vec2):Vec2 {
		var d:Float32Array = this.data;
		return new Vec2(d[0] * v.x + d[3] * v.y + d[6], d[1] * v.x + d[4] * v.y + d[7]);
	}

	/**
	 * Transforms an affine 2D direction vector (ignores explicit translation columns).
	 */
	public inline function transformDirection(v:Vec2):Vec2 {
		var d:Float32Array = this.data;
		return new Vec2(d[0] * v.x + d[3] * v.y, d[1] * v.x + d[4] * v.y);
	}

	/** Extracts the 2D offset values from the translation row segment. **/
	public inline function getTranslation2D():Vec2
		return new Vec2(this.data[6], this.data[7]);

	/** Strict equivalence equality check operator overload. **/
	@:op(A == B) public inline function equals(b:Mat3):Bool {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		for (i in 0...9)
			if (a[i] != d[i])
				return false;
		return true;
	}

	/** Equality comparison within a strict absolute floating-point range margin. **/
	public inline function approximately(b:Mat3, eps:Float = 1e-6):Bool {
		var a:Float32Array = this.data, d:Float32Array = b.data;
		for (i in 0...9)
			if (Math.abs(a[i] - d[i]) > eps)
				return false;
		return true;
	}

	/** Returns a raw standard Array element representation copy. **/
	public inline function toArray():Array<Float> {
		var arr = [];
		for (i in 0...9) arr.push(this.data[i]);
		return arr;
	}

	/** Copies matrix buffer sequence values internally inside target offset sequences. **/
	public inline function copyInto(target:Array<Float>, offset:Int = 0):Void {
		var d:Float32Array = this.data;
		for (i in 0...9)
			target[offset + i] = d[i];
	}

	/** String conversion layout presentation helper. **/
	public inline function toString():String {
		var d:Float32Array = this.data;
		return 'Mat3(\n  ${d[0]} ${d[3]} ${d[6]}\n  ${d[1]} ${d[4]} ${d[7]}\n  ${d[2]} ${d[5]} ${d[8]}\n)';
	}

	/**
	 * Sets all nine elements of this matrix from individual component values.
	 * Parameters follow mathematical notation (row, col).
	 * @return This matrix after modification.
	 */
	public inline function setComponents(m00:Float, m10:Float, m20:Float, m01:Float, m11:Float, m21:Float, m02:Float, m12:Float, m22:Float):Mat3 {
		this.data[0] = m00; this.data[1] = m10; this.data[2] = m20;
		this.data[3] = m01; this.data[4] = m11; this.data[5] = m21;
		this.data[6] = m02; this.data[7] = m12; this.data[8] = m22;
		return cast this;
	}

	/**
	 * Copies all elements from matrix `b` into this matrix in place.
	 * @param b The source matrix.
	 * @return This matrix after modification.
	 */
	public inline function copyFromEq(b:Mat3):Mat3 {
		var d:Float32Array = b.data;
		for (i in 0...9) this.data[i] = d[i];
		return cast this;
	}

	/**
	 * Sets this matrix to the identity matrix in place.
	 * @return This matrix after modification.
	 */
	public inline function setIdentityEq():Mat3 {
		this.data[0] = 1; this.data[1] = 0; this.data[2] = 0;
		this.data[3] = 0; this.data[4] = 1; this.data[5] = 0;
		this.data[6] = 0; this.data[7] = 0; this.data[8] = 1;
		return cast this;
	}

	/**
	 * Sets this matrix to the zero matrix in place.
	 * @return This matrix after modification.
	 */
	public inline function setZeroEq():Mat3 {
		for (i in 0...9) this.data[i] = 0;
		return cast this;
	}

	/**
	 * Multiplies this matrix by `b` in place (this = this * b).
	 * @param b The right-hand matrix operand.
	 * @return This matrix after modification.
	 */
	public inline function multiplyEq(b:Mat3):Mat3 {
		var a:Float32Array = this.data;
		var d:Float32Array = b.data;
		var r0:Float = a[0] * d[0] + a[3] * d[1] + a[6] * d[2];
		var r1:Float = a[1] * d[0] + a[4] * d[1] + a[7] * d[2];
		var r2:Float = a[2] * d[0] + a[5] * d[1] + a[8] * d[2];
		var r3:Float = a[0] * d[3] + a[3] * d[4] + a[6] * d[5];
		var r4:Float = a[1] * d[3] + a[4] * d[4] + a[7] * d[5];
		var r5:Float = a[2] * d[3] + a[5] * d[4] + a[8] * d[5];
		var r6:Float = a[0] * d[6] + a[3] * d[7] + a[6] * d[8];
		var r7:Float = a[1] * d[6] + a[4] * d[7] + a[7] * d[8];
		var r8:Float = a[2] * d[6] + a[5] * d[7] + a[8] * d[8];
		a[0] = r0; a[1] = r1; a[2] = r2;
		a[3] = r3; a[4] = r4; a[5] = r5;
		a[6] = r6; a[7] = r7; a[8] = r8;
		return cast this;
	}

	/**
	 * Scales every element of this matrix by `s` in place.
	 * @param s The scalar factor.
	 * @return This matrix after modification.
	 */
	public inline function multiplyScalarEq(s:Float):Mat3 {
		for (i in 0...9) this.data[i] *= s;
		return cast this;
	}

	/**
	 * Adds matrix `b` element-wise to this matrix in place.
	 * @param b The matrix to add.
	 * @return This matrix after modification.
	 */
	public inline function addEq(b:Mat3):Mat3 {
		var d:Float32Array = b.data;
		for (i in 0...9) this.data[i] += d[i];
		return cast this;
	}

	/**
	 * Subtracts matrix `b` element-wise from this matrix in place.
	 * @param b The matrix to subtract.
	 * @return This matrix after modification.
	 */
	public inline function subtractEq(b:Mat3):Mat3 {
		var d:Float32Array = b.data;
		for (i in 0...9) this.data[i] -= d[i];
		return cast this;
	}

	/**
	 * Transposes this matrix in place (swaps rows and columns).
	 * @return This matrix after modification.
	 */
	public inline function transposeEq():Mat3 {
		var d:Float32Array = this.data;
		var t:Float;
		t = d[1]; d[1] = d[3]; d[3] = t;
		t = d[2]; d[2] = d[6]; d[6] = t;
		t = d[5]; d[5] = d[7]; d[7] = t;
		return cast this;
	}

	/**
	 * Inverts this matrix in place.
	 * Falls back to identity if the determinant is near zero.
	 * @return This matrix after modification.
	 */
	public inline function inverseEq():Mat3 {
		var result:Mat3 = inverse();
		copyFromEq(result);
		return cast this;
	}

	/**
	 * Sets this matrix from a quaternion in place.
	 * @param q The source quaternion.
	 * @return This matrix after modification.
	 */
	public inline function setFromQuatEq(q:Quat):Mat3 {
		copyFromEq(Mat3.fromQuat(q));
		return cast this;
	}

	/**
	 * Sets this matrix from the upper-left 3x3 block of a 4x4 matrix in place.
	 * @param m The source Mat4 matrix.
	 * @return This matrix after modification.
	 */
	public inline function setFromMat4Eq(m:Mat4):Mat3 {
		copyFromEq(Mat3.fromMat4(m));
		return cast this;
	}
}

@:structInit
private class BaseMat3 {
	public var data:Float32Array;

	public function new() {
		data = new Float32Array(9);
	}
}