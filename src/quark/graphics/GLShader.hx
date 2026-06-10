package quark.graphics;

import quark.utils.IDisposable;
import lime.utils.Float32Array;
import quark.math.Vec4;
import quark.math.Vec3;
import quark.math.Vec2;
import quark.math.Mat4;
import quark.math.Mat3;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;

/**
 * Represents an OpenGL GLShader program.
 *
 * Provides utilities for binding the program, accessing attributes,
 * caching uniform locations and uploading uniform values.
 */
class GLShader implements IDisposable {

	/**
	 * Native OpenGL GLShader program.
	 */
	public var program(default, null):GLProgram;

	/**
	 * Cached uniform locations.
	 */
	private var uniformCache:Map<String, GLUniformLocation>;

	/**
	 * Cached attribute locations.
	 */
	private var attributeCache:Map<String, Int>;

	/**
	 * Creates and links a GLShader program from GLSL source code.
	 *
	 * @param vertexSource Vertex GLShader source code.
	 * @param fragmentSource Fragment GLShader source code.
	 * @throws String If program creation fails.
	 */
	public function new(vertexSource:String, fragmentSource:String) {
		program = GLProgram.fromSources(GL, vertexSource, fragmentSource);

		if (program == null) {
			throw "Failed to create GLShader program";
		}

		uniformCache = new Map();
		attributeCache = new Map();
	}

	/**
	 * Binds this GLShader program.
	 */
	public inline function bind():Void {
		GL.useProgram(program);
	}

	/**
	 * Unbinds the currently active GLShader program.
	 */
	public static inline function unbind():Void {
		GL.useProgram(null);
	}

	/**
	 * Releases the OpenGL resources associated with this GLShader.
	 */
	public function dispose():Void {
		if (program != null) {
			GL.deleteProgram(program);
		}

		uniformCache.clear();
		attributeCache.clear();
	}

	/**
	 * Retrieves and caches a uniform location.
	 *
	 * @param name Uniform name.
	 * @return Uniform location or null if not found.
	 */
	private function getUniformLocation(name:String):Null<GLUniformLocation> {
		if (uniformCache.exists(name)) {
			return uniformCache.get(name);
		}

		var location:GLUniformLocation = GL.getUniformLocation(program, name);

		uniformCache.set(name, location);

		return location;
	}

	/**
	 * Checks whether a uniform exists in the GLShader.
	 *
	 * @param name Uniform name.
	 * @return True if the uniform exists.
	 */
	public function hasUniform(name:String):Bool {
		return getUniformLocation(name) != null;
	}

	/**
	 * Retrieves and caches an attribute location.
	 *
	 * @param name Attribute name.
	 * @return Attribute location.
	 */
	public function getAttributeLocation(name:String):Int {
		if (attributeCache.exists(name)) {
			return attributeCache.get(name);
		}

		var location:Int = GL.getAttribLocation(program, name);

		attributeCache.set(name, location);

		return location;
	}

	/**
	 * Sets a boolean uniform.
	 *
	 * @param name Uniform name.
	 * @param value Boolean value.
	 */
	public inline function setBool(name:String, value:Bool):Void {
		GL.uniform1i(getUniformLocation(name), value ? 1 : 0);
	}

	/**
	 * Sets an integer uniform.
	 *
	 * @param name Uniform name.
	 * @param value Integer value.
	 */
	public inline function setInt(name:String, value:Int):Void {
		GL.uniform1i(getUniformLocation(name), value);
	}

	/**
	 * Sets a float uniform.
	 *
	 * @param name Uniform name.
	 * @param value Float value.
	 */
	public inline function setFloat(name:String, value:Float):Void {
		GL.uniform1f(getUniformLocation(name), value);
	}

	/**
	 * Sets a vec2 uniform.
	 *
	 * @param name Uniform name.
	 * @param v Vector value.
	 */
	public inline function setVec2(name:String, v:Vec2):Void {
		GL.uniform2f(getUniformLocation(name), v.x, v.y);
	}

	/**
	 * Sets a vec3 uniform.
	 *
	 * @param name Uniform name.
	 * @param v Vector value.
	 */
	public inline function setVec3(name:String, v:Vec3):Void {
		GL.uniform3f(getUniformLocation(name), v.x, v.y, v.z);
	}

	/**
	 * Sets a vec4 uniform.
	 *
	 * @param name Uniform name.
	 * @param v Vector value.
	 */
	public inline function setVec4(name:String, v:Vec4):Void {
		GL.uniform4f(getUniformLocation(name), v.x, v.y, v.z, v.w);
	}

	/**
	 * Sets a 3x3 matrix uniform.
	 *
	 * @param name Uniform name.
	 * @param matrix Matrix value.
	 */
	public inline function setMat3(name:String, matrix:Mat3):Void {
		GL.uniformMatrix3fv(
			getUniformLocation(name),
			false,
			new Float32Array(matrix.toArray())
		);
	}

	/**
	 * Sets a 4x4 matrix uniform.
	 *
	 * @param name Uniform name.
	 * @param matrix Matrix value.
	 */
	public inline function setMat4(name:String, matrix:Mat4):Void {
		GL.uniformMatrix4fv(
			getUniformLocation(name),
			false,
			new Float32Array(matrix.toArray())
		);
	}

	/**
	 * Sets a 4x4 matrix uniform from raw float data.
	 *
	 * The array must contain 16 values.
	 *
	 * @param name Uniform name.
	 * @param data Matrix data.
	 */
	public function setMat4Raw(name:String, data:Array<Float>) {
		GL.uniformMatrix4fv(
			getUniformLocation(name),
			false,
			new Float32Array(data)
		);
	}

	/**
	 * Sets a float array uniform.
	 *
	 * @param name Uniform name.
	 * @param values Float values.
	 */
	public inline function setFloatArray(name:String, values:Array<Float>):Void {
		GL.uniform1fv(
			getUniformLocation(name),
			new Float32Array(values)
		);
	}

	/**
	 * Sets a vec2 array uniform.
	 *
	 * Values must be packed as:
	 * [x0, y0, x1, y1, ...]
	 *
	 * @param name Uniform name.
	 * @param values Packed vec2 data.
	 */
	public inline function setVec2Array(name:String, values:Array<Float>):Void {
		GL.uniform2fv(
			getUniformLocation(name),
			new Float32Array(values)
		);
	}

	/**
	 * Sets a vec3 array uniform.
	 *
	 * Values must be packed as:
	 * [x0, y0, z0, x1, y1, z1, ...]
	 *
	 * @param name Uniform name.
	 * @param values Packed vec3 data.
	 */
	public inline function setVec3Array(name:String, values:Array<Float>):Void {
		GL.uniform3fv(
			getUniformLocation(name),
			new Float32Array(values)
		);
	}

	/**
	 * Sets a vec4 array uniform.
	 *
	 * Values must be packed as:
	 * [x0, y0, z0, w0, x1, y1, z1, w1, ...]
	 *
	 * @param name Uniform name.
	 * @param values Packed vec4 data.
	 */
	public inline function setVec4Array(name:String, values:Array<Float>):Void {
		GL.uniform4fv(
			getUniformLocation(name),
			new Float32Array(values)
		);
	}

	/**
	 * Sets a texture sampler uniform.
	 *
	 * @param name Sampler uniform name.
	 * @param slot Texture unit index.
	 */
	public inline function setTexture(name:String, slot:Int):Void {
		setInt(name, slot);
	}
}