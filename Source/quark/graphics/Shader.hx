package quark.graphics;

import lime.utils.Float32Array;
import quark.math.Vec4;
import quark.math.Vec3;
import quark.math.Vec2;
import quark.math.Mat4;
import quark.math.Mat3;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;

class Shader {
	public var program(default, null):GLProgram;

	private var uniformCache:Map<String, GLUniformLocation>;
	private var attributeCache:Map<String, Int>;

	public function new(vertexSource:String, fragmentSource:String) {
		program = GLProgram.fromSources(GL, vertexSource, fragmentSource);
		if (program == null) {
			throw "Failed to create shader program";
		}

		uniformCache = new Map();
		attributeCache = new Map();
	}

	public inline function bind():Void {
		GL.useProgram(program);
	}

	public static inline function unbind():Void {
		GL.useProgram(null);
	}

	public function dispose():Void {
		if (program != null) {
			GL.deleteProgram(program);
		}

		uniformCache.clear();
		attributeCache.clear();
	}

	private function getUniformLocation(name:String):Null<GLUniformLocation> {
		if (uniformCache.exists(name)) {
			return uniformCache.get(name);
		}

		var location:GLUniformLocation = GL.getUniformLocation(program, name);

		uniformCache.set(name, location);

		return location;
	}

	public function hasUniform(name:String):Bool {
		return getUniformLocation(name) != null;
	}

	public function getAttributeLocation(name:String):Int {
		if (attributeCache.exists(name)) {
			return attributeCache.get(name);
		}

		var location:Int = GL.getAttribLocation(program, name);

		attributeCache.set(name, location);

		return location;
	}

	public inline function setBool(name:String, value:Bool):Void {
		GL.uniform1i(getUniformLocation(name), value ? 1 : 0);
	}

	public inline function setInt(name:String, value:Int):Void {
		GL.uniform1i(getUniformLocation(name), value);
	}

	public inline function setFloat(name:String, value:Float):Void {
		GL.uniform1f(getUniformLocation(name), value);
	}

	public inline function setVec2(name:String, v:Vec2):Void {
		GL.uniform2f(getUniformLocation(name), v.x, v.y);
	}

	public inline function setVec3(name:String, v:Vec3):Void {
		GL.uniform3f(getUniformLocation(name), v.x, v.y, v.z);
	}

	public inline function setVec4(name:String, v:Vec4):Void {
		GL.uniform4f(getUniformLocation(name), v.x, v.y, v.z, v.w);
	}

	public inline function setMat3(name:String, matrix:Mat3):Void {
		GL.uniformMatrix3fv(getUniformLocation(name), false, new Float32Array(matrix.toArray()));
	}

	public inline function setMat4(name:String, matrix:Mat4):Void {
		GL.uniformMatrix4fv(getUniformLocation(name), false, new Float32Array(matrix.toArray()));
	}

	public inline function setFloatArray(name:String, values:Array<Float>):Void {
		GL.uniform1fv(getUniformLocation(name), new Float32Array(values));
	}

	public inline function setVec2Array(name:String, values:Array<Float>):Void {
		GL.uniform2fv(getUniformLocation(name), new Float32Array(values));
	}

	public inline function setVec3Array(name:String, values:Array<Float>):Void {
		GL.uniform3fv(getUniformLocation(name), new Float32Array(values));
	}

	public inline function setVec4Array(name:String, values:Array<Float>):Void {
		GL.uniform4fv(getUniformLocation(name), new Float32Array(values));
	}

	public inline function setTexture(name:String, slot:Int):Void {
		setInt(name, slot);
	}
}
