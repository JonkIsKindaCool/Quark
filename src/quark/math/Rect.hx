package quark.math;

/**
 * Represents a 2D Rectangle specified by position (x, y) and size (w, h).
 */
@:forward
abstract Rect(BaseRect) from BaseRect to BaseRect {
	/**
	 * Creates a new rectangle.
	 * @param x The minimum X coordinate (left edge).
	 * @param y The minimum Y coordinate (top edge).
	 * @param width The width of the rectangle.
	 * @param height The height of the rectangle.
	 */
	public inline function new(x:Float, y:Float, width:Float, height:Float) {
		this = {
			x: x,
			y: y,
			w: width,
			h: height
		};
	}

	/**
	 * Creates a new rectangle given its minimum and maximum coordinate bounds.
	 */
	public static inline function fromMinMax(minX:Float, minY:Float, maxX:Float, maxY:Float):Rect {
		return new Rect(minX, minY, maxX - minX, maxY - minY);
	}

	/** The minimum X coordinate (left edge). */
	public var minX(get, never):Float;

	/** The minimum Y coordinate (top edge). */
	public var minY(get, never):Float;

	/** The maximum X coordinate (right edge). */
	public var maxX(get, never):Float;

	/** The maximum Y coordinate (bottom edge). */
	public var maxY(get, never):Float;

	inline function get_minX():Float
		return this.x;

	inline function get_minY():Float
		return this.y;

	inline function get_maxX():Float
		return this.x + this.w;

	inline function get_maxY():Float
		return this.y + this.h;

	/** The center position of this rectangle as a Vec2. */
	public var center(get, never):Vec2;

	inline function get_center():Vec2
		return new Vec2(this.x + this.w * 0.5, this.y + this.h * 0.5);

	/** Returns true if the given point `p` lies inside or on the edges of this rectangle. */
	public inline function containsPoint(p:Vec2):Bool {
		return p.x >= this.x && p.x <= this.x + this.w && p.y >= this.y && p.y <= this.y + this.h;
	}

	/** Returns true if this rectangle intersects/overlaps with another rectangle. */
	public inline function intersects(other:Rect):Bool {
		return !(get_maxX() < other.minX || get_minX() > other.maxX || get_maxY() < other.minY || get_minY() > other.maxY);
	}

	/** Returns a string representation of this rectangle. */
	public inline function toString():String
		return 'Rect(x=${this.x}, y=${this.y}, w=${this.w}, h=${this.h})';

	/** Returns a new rectangle that fully encloses both this rectangle and another. */
	public inline function merge(other:Rect):Rect {
		return Rect.fromMinMax(Math.min(this.x, other.x), Math.min(this.y, other.y), Math.max(maxX, other.maxX), Math.max(maxY, other.maxY));
	}

	/**
	 * Expands the rectangle uniformly in all directions by the specified amount.
	 * Pass a negative value to shrink it.
	 */
	public inline function expand(amount:Float):Rect {
		return new Rect(this.x - amount, this.y - amount, this.w + amount * 2, this.h + amount * 2);
	}

	/** Returns the overlapping area between this rectangle and another as a new Rect. */
	public inline function intersection(other:Rect):Rect {
		return Rect.fromMinMax(Math.max(this.x, other.x), Math.max(this.y, other.y), Math.min(maxX, other.maxX), Math.min(maxY, other.maxY));
	}

	/** Clamps the provided point `p` so that it lies within the bounds of this rectangle. */
	public inline function closestPoint(p:Vec2):Vec2 {
		return new Vec2(MathUtils.clamp(p.x, this.x, maxX), MathUtils.clamp(p.y, this.y, maxY));
	}

	/** Returns true if this rectangle completely encloses the `other` rectangle. */
	public inline function contains(other:Rect):Bool {
		return other.x >= this.x && other.y >= this.y && other.maxX <= maxX && other.maxY <= maxY;
	}

	/** Calculates the total area of the rectangle ($width \times height$). */
	public inline function area():Float
		return this.w * this.h;

	/** Returns true if either width or height is less than or equal to zero. */
	public inline function isEmpty():Bool
		return this.w <= 0 || this.h <= 0;

	/** Returns the Top-Left vertex position. */
	public inline function topLeft():Vec2
		return new Vec2(this.x, this.y);

	/** Returns the Top-Right vertex position. */
	public inline function topRight():Vec2
		return new Vec2(maxX, this.y);

	/** Returns the Bottom-Left vertex position. */
	public inline function bottomLeft():Vec2
		return new Vec2(this.x, maxY);

	/** Returns the Bottom-Right vertex position. */
	public inline function bottomRight():Vec2
		return new Vec2(maxX, maxY);
}

@:structInit
private class BaseRect {
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
}
