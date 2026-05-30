package quark.math;

@:forward
abstract Mat3(BaseMat3) from BaseMat3 to BaseMat3 {
	public inline function new(m00:Float, m10:Float, m20:Float, m01:Float, m11:Float, m21:Float, m02:Float, m12:Float, m22:Float) {
		var obj:BaseMat3 = new BaseMat3();
        obj.data = [m00, m10, m20, m01, m11, m21, m02, m12, m22];

        this = obj;
	}

	public static inline function identity():Mat3 {
		return new Mat3(1, 0, 0, 0, 1, 0, 0, 0, 1);
	}

	public static inline function zero():Mat3 {
		return new Mat3(0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	public inline function get(row:Int, col:Int):Float {
		return this.data[col * 3 + row];
	}

	public inline function set(row:Int, col:Int, v:Float):Mat3 {
		this.data[col * 3 + row] = v;
		return this;
	}

	@:op(A * B) public inline function multiply(other:Mat3):Mat3 {
		var a = this.data, b = other.data;
		return new Mat3(a[0] * b[0] + a[3] * b[1] + a[6] * b[2], a[1] * b[0] + a[4] * b[1] + a[7] * b[2], a[2] * b[0] + a[5] * b[1] + a[8] * b[2],

			a[0] * b[3] + a[3] * b[4] + a[6] * b[5], a[1] * b[3] + a[4] * b[4] + a[7] * b[5], a[2] * b[3] + a[5] * b[4] + a[8] * b[5],

			a[0] * b[6] + a[3] * b[7] + a[6] * b[8], a[1] * b[6] + a[4] * b[7] + a[7] * b[8], a[2] * b[6] + a[5] * b[7] + a[8] * b[8]);
	}

	@:op(A * B) public inline function transformVec3(v:Vec3):Vec3 {
		var d = this.data;
		return new Vec3(d[0] * v.x + d[3] * v.y + d[6] * v.z, d[1] * v.x + d[4] * v.y + d[7] * v.z, d[2] * v.x + d[5] * v.y + d[8] * v.z);
	}

	public inline function transpose():Mat3 {
		var d = this.data;
		return new Mat3(d[0], d[3], d[6], d[1], d[4], d[7], d[2], d[5], d[8]);
	}

	public inline function toArray():Array<Float>
		return this.data.copy();

	public inline function toString():String {
		var d = this.data;
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
