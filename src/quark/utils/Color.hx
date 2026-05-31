package quark.utils;

/**
 * Represents a color stored as a 32-bit RGBA integer.
 *
 * Format:
 * RGBA (0xRRGGBBAA)
 *
 * Provides utilities for color creation, conversion,
 * interpolation and manipulation.
 */
abstract Color(Int) from Int to Int {
	/** White (#FFFFFFFF). */
	public static inline final WHITE:Color = 0xFFFFFFFF;

	/** Black (#000000FF). */
	public static inline final BLACK:Color = 0x000000FF;

	/** Fully transparent black (#00000000). */
	public static inline final TRANSPARENT:Color = 0x00000000;

	/** Red (#FF0000FF). */
	public static inline final RED:Color = 0xFF0000FF;

	/** Green (#00FF00FF). */
	public static inline final GREEN:Color = 0x00FF00FF;

	/** Blue (#0000FFFF). */
	public static inline final BLUE:Color = 0x0000FFFF;

	/** Yellow (#FFFF00FF). */
	public static inline final YELLOW:Color = 0xFFFF00FF;

	/** Cyan (#00FFFFFF). */
	public static inline final CYAN:Color = 0x00FFFFFF;

	/** Magenta (#FF00FFFF). */
	public static inline final MAGENTA:Color = 0xFF00FFFF;

	/** Orange (#FF8000FF). */
	public static inline final ORANGE:Color = 0xFF8000FF;

	/** Purple (#8000FFFF). */
	public static inline final PURPLE:Color = 0x8000FFFF;

	/** Pink (#FF80FFFF). */
	public static inline final PINK:Color = 0xFF80FFFF;

	/** Brown (#8B4513FF). */
	public static inline final BROWN:Color = 0x8B4513FF;

	/** Gray (#808080FF). */
	public static inline final GRAY:Color = 0x808080FF;

	/** Light gray (#C0C0C0FF). */
	public static inline final LIGHT_GRAY:Color = 0xC0C0C0FF;

	/** Dark gray (#404040FF). */
	public static inline final DARK_GRAY:Color = 0x404040FF;

	/**
	 * Creates a color from integer RGBA components.
	 *
	 * @param r Red channel (0-255).
	 * @param g Green channel (0-255).
	 * @param b Blue channel (0-255).
	 * @param a Alpha channel (0-255).
	 * @return Resulting color.
	 */
	public static inline function fromRGBA(r:Int, g:Int, b:Int, a:Int = 255):Color {
		return ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | ((b & 0xFF) << 8) | (a & 0xFF);
	}

	/**
	 * Creates a color from normalized float components.
	 *
	 * @param r Red channel (0.0-1.0).
	 * @param g Green channel (0.0-1.0).
	 * @param b Blue channel (0.0-1.0).
	 * @param a Alpha channel (0.0-1.0).
	 * @return Resulting color.
	 */
	public static inline function fromFloats(r:Float, g:Float, b:Float, a:Float = 1.0):Color {
		return fromRGBA(Std.int(r * 255), Std.int(g * 255), Std.int(b * 255), Std.int(a * 255));
	}

	/**
	 * Creates a color from a hexadecimal string.
	 *
	 * Supported formats:
	 * - #RRGGBB
	 * - #RRGGBBAA
	 * - RRGGBB
	 * - RRGGBBAA
	 *
	 * @param hex Hexadecimal color string.
	 * @return Parsed color.
	 */
	public static function fromHex(hex:String):Color {
		var s:String = hex.charAt(0) == "#" ? hex.substr(1) : hex;

		if (s.length == 6)
			s += "FF";

		return Std.parseInt("0x" + s);
	}

	/**
	 * Creates a color from HSV values.
	 *
	 * @param h Hue in degrees.
	 * @param s Saturation (0.0-1.0).
	 * @param v Value (0.0-1.0).
	 * @param a Alpha (0.0-1.0).
	 * @return Resulting color.
	 */
	public static function fromHSV(h:Float, s:Float, v:Float, a:Float = 1.0):Color {
		if (s == 0)
			return fromFloats(v, v, v, a);

		var i:Float = Math.floor(h / 60) % 6;
		var f:Float = (h / 60) - Math.floor(h / 60);
		var p:Float = v * (1 - s);
		var q:Float = v * (1 - f * s);
		var t:Float = v * (1 - (1 - f) * s);

		var r:Float, g:Float, b:Float;
		switch i {
			case 0:
				r = v;
				g = t;
				b = p;
			case 1:
				r = q;
				g = v;
				b = p;
			case 2:
				r = p;
				g = v;
				b = t;
			case 3:
				r = p;
				g = q;
				b = v;
			case 4:
				r = t;
				g = p;
				b = v;
			case 5:
				r = v;
				g = p;
				b = q;
			default:
				r = 0;
				g = 0;
				b = 0;
		}

		return fromFloats(r, g, b, a);
	}

	/**
	 * Creates a color from HSL values.
	 *
	 * @param h Hue in degrees.
	 * @param s Saturation (0.0-1.0).
	 * @param l Lightness (0.0-1.0).
	 * @param a Alpha (0.0-1.0).
	 * @return Resulting color.
	 */
	public static function fromHSL(h:Float, s:Float, l:Float, a:Float = 1.0):Color {
		if (s == 0)
			return fromFloats(l, l, l, a);

		var q:Float = l < 0.5 ? l * (1 + s) : l + s - l * s;
		var p:Float = 2 * l - q;
		var hk:Float = h / 360;

		inline function hue(t:Float):Float {
			if (t < 0)
				t += 1;
			if (t > 1)
				t -= 1;
			if (t < 1 / 6)
				return p + (q - p) * 6 * t;
			if (t < 1 / 2)
				return q;
			if (t < 2 / 3)
				return p + (q - p) * (2 / 3 - t) * 6;
			return p;
		}

		return fromFloats(hue(hk + 1 / 3), hue(hk), hue(hk - 1 / 3), a);
	}

	/** Red channel (0-255). */
	public var r(get, set):Int;

	/** Green channel (0-255). */
	public var g(get, set):Int;

	/** Blue channel (0-255). */
	public var b(get, set):Int;

	/** Alpha channel (0-255). */
	public var a(get, set):Int;

	/** Red channel (0.0-1.0). */
	public var rf(get, set):Float;

	/** Green channel (0.0-1.0). */
	public var gf(get, set):Float;

	/** Blue channel (0.0-1.0). */
	public var bf(get, set):Float;

	/** Alpha channel (0.0-1.0). */
	public var af(get, set):Float;

	inline function get_r()
		return (this >> 24) & 0xFF;

	inline function get_g()
		return (this >> 16) & 0xFF;

	inline function get_b()
		return (this >> 8) & 0xFF;

	inline function get_a()
		return this & 0xFF;

	inline function set_r(v:Int) {
		this = fromRGBA(v, g, b, a);
		return v;
	}

	inline function set_g(v:Int) {
		this = fromRGBA(r, v, b, a);
		return v;
	}

	inline function set_b(v:Int) {
		this = fromRGBA(r, g, v, a);
		return v;
	}

	inline function set_a(v:Int) {
		this = fromRGBA(r, g, b, v);
		return v;
	}

	inline function get_rf()
		return r / 255.0;

	inline function get_gf()
		return g / 255.0;

	inline function get_bf()
		return b / 255.0;

	inline function get_af()
		return a / 255.0;

	inline function set_rf(v:Float) {
		set_r(Std.int(v * 255));
		return v;
	}

	inline function set_gf(v:Float) {
		set_g(Std.int(v * 255));
		return v;
	}

	inline function set_bf(v:Float) {
		set_b(Std.int(v * 255));
		return v;
	}

	inline function set_af(v:Float) {
		set_a(Std.int(v * 255));
		return v;
	}

	/**
	 * Linearly interpolates between two colors.
	 *
	 * @param a Start color.
	 * @param b End color.
	 * @param t Interpolation factor (0.0-1.0).
	 * @return Interpolated color.
	 */
	public static function lerp(a:Color, b:Color, t:Float):Color {
		t = t < 0 ? 0 : t > 1 ? 1 : t;

		return fromRGBA(Std.int(a.r + (b.r - a.r) * t), Std.int(a.g + (b.g - a.g) * t), Std.int(a.b + (b.b - a.b) * t), Std.int(a.a + (b.a - a.a) * t));
	}

	/**
	 * Multiplies two colors component-wise.
	 *
	 * @param a First color.
	 * @param b Second color.
	 * @return Multiplied color.
	 */
	@:op(A * B)
	public static function multiply(a:Color, b:Color):Color {
		return fromFloats(a.rf * b.rf, a.gf * b.gf, a.bf * b.bf, a.af * b.af);
	}

	/**
	 * Scales a color by a scalar value.
	 *
	 * @param c Source color.
	 * @param s Scale factor.
	 * @return Scaled color.
	 */
	@:op(A * B)
	public static function scale(c:Color, s:Float):Color {
		return fromFloats(c.rf * s, c.gf * s, c.bf * s, c.af);
	}

	/**
	 * Returns a copy of the color with a new alpha value.
	 *
	 * @param newAlpha Alpha value (0-255).
	 * @return Modified color.
	 */
	public inline function withAlpha(newAlpha:Int):Color {
		return fromRGBA(r, g, b, newAlpha);
	}

	/**
	 * Returns a copy of the color with a new normalized alpha value.
	 *
	 * @param newAlpha Alpha value (0.0-1.0).
	 * @return Modified color.
	 */
	public inline function withAlphaF(newAlpha:Float):Color {
		return fromRGBA(r, g, b, Std.int(newAlpha * 255));
	}

	/**
	 * Darkens the color.
	 *
	 * @param amount Darkening factor (0.0-1.0).
	 * @return Darkened color.
	 */
	public inline function darken(amount:Float):Color {
		return fromFloats(rf * (1 - amount), gf * (1 - amount), bf * (1 - amount), af);
	}

	/**
	 * Lightens the color.
	 *
	 * @param amount Lightening factor (0.0-1.0).
	 * @return Lightened color.
	 */
	public inline function lighten(amount:Float):Color {
		return fromFloats(rf + (1 - rf) * amount, gf + (1 - gf) * amount, bf + (1 - bf) * amount, af);
	}

	/**
	 * Inverts the RGB channels.
	 *
	 * Alpha remains unchanged.
	 *
	 * @return Inverted color.
	 */
	public inline function invert():Color {
		return fromRGBA(255 - r, 255 - g, 255 - b, a);
	}

	/**
	 * Returns a premultiplied alpha version of this color.
	 *
	 * @return Premultiplied color.
	 */
	public inline function premultiply():Color {
		return fromFloats(rf * af, gf * af, bf * af, af);
	}

	/**
	 * Converts the color to a hexadecimal string.
	 *
	 * @param includeAlpha Whether alpha should be included.
	 * @return Hexadecimal color string.
	 */
	public inline function toHex(includeAlpha:Bool = true):String {
		return includeAlpha ? "#" + StringTools.hex(this, 8) : "#" + StringTools.hex(this >> 8, 6);
	}

	/**
	 * Converts the color to HSV.
	 *
	 * @return HSV representation.
	 */
	public function toHSV():{h:Float, s:Float, v:Float} {
		var r:Float = rf, g = gf, b = bf;
		var max:Float = Math.max(r, Math.max(g, b));
		var min:Float = Math.min(r, Math.min(g, b));
		var d:Float = max - min;

		var h:Float = 0.0;
		var s:Float = max == 0 ? 0.0 : d / max;
		var v:Float = max;

		if (d != 0) {
			if (max == r)
				h = ((g - b) / d + (g < b ? 6 : 0)) / 6;
			else if (max == g)
				h = ((b - r) / d + 2) / 6;
			else
				h = ((r - g) / d + 4) / 6;
		}

		return {h: h * 360, s: s, v: v};
	}

	/**
	 * Returns a human-readable string representation.
	 *
	 * @return Color description.
	 */
	public inline function toString():String {
		return 'Color(r=$r, g=$g, b=$b, a=$a)';
	}
}
