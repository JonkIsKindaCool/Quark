package quark.math;

@:forward
abstract AABB(BaseAABB) from BaseAABB to BaseAABB {
	public inline function new(minX:Float, minY:Float, minZ:Float, maxX:Float, maxY:Float, maxZ:Float) {
		this = {min: new Vec3(minX, minY, minZ), max: new Vec3(maxX, maxY, maxZ)};
	}

	public static inline function fromMinMax(min:Vec3, max:Vec3):AABB {
		return new AABB(min.x, min.y, min.z, max.x, max.y, max.z);
	}

	public static inline function fromCenterSize(center:Vec3, size:Vec3):AABB {
		var half:Vec3 = size / 2;
        
		return fromMinMax(center - half, center + half);
	}

	public var min(get, never):Vec3;
	public var max(get, never):Vec3;

	inline function get_min():Vec3
		return this.min;

	inline function get_max():Vec3
		return this.max;

	public var center(get, never):Vec3;
	public var size(get, never):Vec3;

	inline function get_center():Vec3
		return (this.min + this.max) * 0.5;

	inline function get_size():Vec3
		return this.max - this.min;

	public inline function containsPoint(p:Vec3):Bool {
		return p.x >= this.min.x
			&& p.x <= this.max.x
			&& p.y >= this.min.y
			&& p.y <= this.max.y
			&& p.z >= this.min.z
			&& p.z <= this.max.z;
	}

	public inline function intersects(other:AABB):Bool {
		return !(this.max.x < other.min.x || this.min.x > other.max.x || this.max.y < other.min.y || this.min.y > other.max.y || this.max.z < other.min.z
			|| this.min.z > other.max.z);
	}

	public inline function expandToInclude(point:Vec3):AABB {
		return new AABB(Math.min(this.min.x, point.x), Math.min(this.min.y, point.y), Math.min(this.min.z, point.z), Math.max(this.max.x, point.x),
			Math.max(this.max.y, point.y), Math.max(this.max.z, point.z));
	}

	public inline function toString():String
		return 'AABB(min=${this.min}, max=${this.max})';
}

@:structInit
private class BaseAABB {
	public var min:Vec3;
	public var max:Vec3;
}
