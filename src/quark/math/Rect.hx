package quark.math;

@:forward
abstract Rect(BaseRect) from BaseRect to BaseRect {
	public inline function new(x:Float, y:Float, width:Float, height:Float) {
		this = {
			x: x,
			y: y,
			w: width,
			h: height
		};
	}

	public static inline function fromMinMax(minX:Float, minY:Float, maxX:Float, maxY:Float):Rect {
		return new Rect(minX, minY, maxX - minX, maxY - minY);
	}

	public var x(get, never):Float;
	public var y(get, never):Float;

	public var width(get, never):Float;
	public var height(get, never):Float;

	inline function get_x():Float
		return this.x;

	inline function get_y():Float
		return this.y;

	inline function get_width():Float
		return this.w;

	inline function get_height():Float
		return this.h;

	public var minX(get, never):Float;
	public var minY(get, never):Float;

	public var maxX(get, never):Float;
	public var maxY(get, never):Float;

	inline function get_minX():Float
		return this.x;

	inline function get_minY():Float
		return this.y;

	inline function get_maxX():Float
		return this.x + this.w;

	inline function get_maxY():Float
		return this.y + this.h;

	public var center(get, never):Vec2;

	inline function get_center():Vec2
		return new Vec2(this.x + this.w * 0.5, this.y + this.h * 0.5);

	public inline function containsPoint(p:Vec2):Bool {
		return p.x >= this.x && p.x <= this.x + this.w && p.y >= this.y && p.y <= this.y + this.h;
	}

	public inline function intersects(other:Rect):Bool {
		return !(get_maxX() < other.minX || get_minX() > other.maxX || get_maxY() < other.minY || get_minY() > other.maxY);
	}

	public inline function toString():String
		return 'Rect(x=${this.x}, y=${this.y}, w=${this.w}, h=${this.h})';

	public inline function merge(other:Rect):Rect {
		return Rect.fromMinMax(Math.min(this.x, other.x), Math.min(this.y, other.y), Math.max(maxX, other.maxX), Math.max(maxY, other.maxY));
	}

	public inline function expand(amount:Float):Rect {
		return new Rect(this.x - amount, this.y - amount, this.w + amount * 2, this.h + amount * 2);
	}

	public inline function intersection(other:Rect):Rect {
		return Rect.fromMinMax(Math.max(this.x, other.x), Math.max(this.y, other.y), Math.min(maxX, other.maxX), Math.min(maxY, other.maxY));
	}

	public inline function closestPoint(p:Vec2):Vec2 {
		return new Vec2(MathUtils.clamp(p.x, this.x, maxX), MathUtils.clamp(p.y, this.y, maxY));
	}

	public inline function contains(other:Rect):Bool {
		return other.x >= this.x && other.y >= this.y && other.maxX <= maxX && other.maxY <= maxY;
	}

	public inline function area():Float
		return this.w * this.h;

	public inline function isEmpty():Bool
		return this.w <= 0 || this.h <= 0;

	public inline function topLeft():Vec2
		return new Vec2(this.x, this.y);

	public inline function topRight():Vec2
		return new Vec2(maxX, this.y);

	public inline function bottomLeft():Vec2
		return new Vec2(this.x, maxY);

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
