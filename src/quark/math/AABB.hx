package quark.math;

/**
 * An Axis-Aligned Bounding Box (AABB) represented by its minimum and maximum coordinates.
 * Commonly used for collision detection and view-frustum culling.
 */
@:forward
abstract AABB(BaseAABB) from BaseAABB to BaseAABB {
	/**
	 * Creates a new AABB from explicit minimum and maximum component bounds.
	 * * @param minX The minimum X bound.
	 * @param minY The minimum Y bound.
	 * @param minZ The minimum Z bound.
	 * @param maxX The maximum X bound.
	 * @param maxY The maximum Y bound.
	 * @param maxZ The maximum Z bound.
	 */
	public inline function new(minX:Float, minY:Float, minZ:Float, maxX:Float, maxY:Float, maxZ:Float) {
		this = {min: new Vec3(minX, minY, minZ), max: new Vec3(maxX, maxY, maxZ)};
	}

	/**
	 * Creates an AABB from min and max vectors.
	 * * @param min The vector specifying the minimum coordinate bounds.
	 * @param max The vector specifying the maximum coordinate bounds.
	 * @return A new AABB instance.
	 */
	public static inline function fromMinMax(min:Vec3, max:Vec3):AABB {
		return new AABB(min.x, min.y, min.z, max.x, max.y, max.z);
	}

	/**
	 * Creates an AABB from a center point and a size vector.
	 * * @param center The geometric center of the box.
	 * @param size The full dimensions (width, height, depth) of the box.
	 * @return A new AABB instance.
	 */
	public static inline function fromCenterSize(center:Vec3, size:Vec3):AABB {
		var half:Vec3 = size / 2;
		
		return fromMinMax(center - half, center + half);
	}

	/** The minimum coordinate bound of this bounding box. **/
	public var min(get, never):Vec3;

	/** The maximum coordinate bound of this bounding box. **/
	public var max(get, never):Vec3;

	inline function get_min():Vec3
		return this.min;

	inline function get_max():Vec3
		return this.max;

	/** The geometric center point of the box. **/
	public var center(get, never):Vec3;

	/** The total size (extents) along each axis. **/
	public var size(get, never):Vec3;

	inline function get_center():Vec3
		return (this.min + this.max) * 0.5;

	inline function get_size():Vec3
		return this.max - this.min;

	/**
	 * Checks if a specific point is inside or on the boundary of this bounding box.
	 * * @param p The 3D point to test.
	 * @return `true` if the point is inside the box bounds, `false` otherwise.
	 */
	public inline function containsPoint(p:Vec3):Bool {
		return p.x >= this.min.x
			&& p.x <= this.max.x
			&& p.y >= this.min.y
			&& p.y <= this.max.y
			&& p.z >= this.min.z
			&& p.z <= this.max.z;
	}

	/**
	 * Determines whether this bounding box intersects with another AABB.
	 * * @param other The other bounding box to check against.
	 * @return `true` if the boxes overlap, `false` otherwise.
	 */
	public inline function intersects(other:AABB):Bool {
		return !(this.max.x < other.min.x || this.min.x > other.max.x || this.max.y < other.min.y || this.min.y > other.max.y || this.max.z < other.min.z
			|| this.min.z > other.max.z);
	}

	/**
	 * Generates a new bounding box that scales out to encapsulate the given point.
	 * * @param point The 3D point to incorporate into the bounding volume.
	 * @return A new expanded AABB.
	 */
	public inline function expandToInclude(point:Vec3):AABB {
		return new AABB(Math.min(this.min.x, point.x), Math.min(this.min.y, point.y), Math.min(this.min.z, point.z), Math.max(this.max.x, point.x),
			Math.max(this.max.y, point.y), Math.max(this.max.z, point.z));
	}

	/**
	 * Converts the AABB properties to a human-readable string format.
	 */
	public inline function toString():String
		return 'AABB(min=${this.min}, max=${this.max})';
}

@:structInit
private class BaseAABB {
	public var min:Vec3;
	public var max:Vec3;
}
