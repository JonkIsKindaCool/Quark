package quark.math;

class MathUtils {
	public static inline function lerp(a:Float, b:Float, t:Float):Float
		return a + (b - a) * t;

	public static inline function clamp(value:Float, min:Float, max:Float):Float {
		return value < min ? min : (value > max ? max : value);
	}

	public static inline function smoothstep(edge0:Float, edge1:Float, x:Float):Float {
		var t:Float = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);

		return t * t * (3.0 - 2.0 * t);
	}

	public static inline function wrap(value:Float, min:Float, max:Float):Float {
		var range:Float = max - min;

		if (range == 0)
			return min;

		var v:Float = (value - min) % range;

		if (v < 0)
			v += range;

		return min + v;
	}

	public static inline function degreesToRad(deg:Float):Float
		return deg * Math.PI / 180.0;

	public static inline function radToDegrees(rad:Float):Float
		return rad * 180.0 / Math.PI;

	public static inline function sign(value:Float):Int
		return value > 0 ? 1 : (value < 0 ? -1 : 0);

	public static inline function approxEqual(a:Float, b:Float, epsilon:Float = 1e-6):Bool {
		return Math.abs(a - b) < epsilon;
	}

	public static inline function smootherstep(edge0:Float, edge1:Float, x:Float):Float {
		var t:Float = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);

		return t * t * t * (t * (t * 6 - 15) + 10);
	}

	public static inline function pingPong(t:Float, length:Float):Float {
		var L:Float = length * 2;
		var v:Float = t % L;
		if (v < 0)
			v += L;
		return v < length ? v : L - v;
	}

	public static inline function remap(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float {
		return outMin + (value - inMin) / (inMax - inMin) * (outMax - outMin);
	}

	public static inline function expDecay(a:Float, b:Float, decay:Float, dt:Float):Float {
		return b + (a - b) * Math.exp(-decay * dt);
	}

	public static inline function nextPowerOfTwo(v:Int):Int {
		var n:Int = v - 1;

		n |= n >> 1;
		n |= n >> 2;
		n |= n >> 4;
		n |= n >> 8;
		n |= n >> 16;

		return n + 1;
	}

	public static inline function isPowerOfTwo(v:Int):Bool
		return v > 0 && (v & (v - 1)) == 0;

	public static inline function wave(t:Float, frequency:Float = 1.0):Float
		return (Math.sin(t * frequency * Math.PI * 2) + 1) * 0.5;

	public static inline function toDeg(rad:Float):Float
		return rad * 180.0 / Math.PI;

	public static inline function toRad(deg:Float):Float
		return deg * Math.PI / 180.0;

	public static inline function perpendicular(v:Vec3):Vec3 {
		var ax:Float = Math.abs(v.x);
		var ay:Float = Math.abs(v.y);
		var az:Float = Math.abs(v.z);
		
		if (ax <= ay && ax <= az)
			return new Vec3(0, -v.z, v.y).normalized;
		else if (ay <= az)
			return new Vec3(-v.z, 0, v.x).normalized;
		else
			return new Vec3(-v.y, v.x, 0).normalized;
	}
}
