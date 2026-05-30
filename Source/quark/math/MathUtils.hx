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
}
