package quark.graphics;

import lime.utils.ArrayBufferView;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;

class IndexBuffer {
	public var ebo(default, null):GLBuffer;
	public var count(default, null):Int;

	public function new(indices:ArrayBufferView, indexByteSize:Int = 4, dyn:Bool = false) {
		ebo = GL.createBuffer();

		bind();

		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indices, dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);

		count = Std.int(indices.byteLength / indexByteSize);
	}

	public function setData(indices:ArrayBufferView, indexByteSize:Int = 4, dyn:Bool = true):Void {
		bind();

		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indices, dyn ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);

		count = Std.int(indices.byteLength / indexByteSize); 
	}

	public function setSubData(offset:Int, data:ArrayBufferView):Void {
		bind();

		GL.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, offset, data);
	}

	public inline function setSubDataIndices(indexOffset:Int, data:ArrayBufferView):Void {
		setSubData(indexOffset * 4, data);
	}

	public inline function bind():Void {
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ebo);
	}

	public static inline function unbind():Void {
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	public function dispose():Void {
		GL.deleteBuffer(ebo);
	}
}
