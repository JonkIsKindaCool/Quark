package;

import quark.math.Mat4;
import lime.utils.UInt32Array;
import lime.utils.Float32Array;
import lime.graphics.RenderContext;
import lime.graphics.opengl.GL;
import quark.app.App;
import quark.graphics.Shader;
import quark.graphics.VertexBuffer;
import quark.graphics.IndexBuffer;
import quark.graphics.VertexLayout;

class Game extends App {
	var shader:Shader;

	var vb:VertexBuffer;
	var ib:IndexBuffer;

	var projection:Mat4;

	override function onCreate() {
		super.onCreate();

		var vertexShader = "
        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vColor;

        void main()
        {
            vColor = color;
            gl_Position = vec4(position, 0.0, 1.0);
        }
        ";

		var fragmentShader = "
        #ifdef GL_ES
        precision mediump float;
        #endif

        varying vec3 vColor;

        void main() {
            gl_FragColor = vec4(vColor, 1.0);
        }
        ";

		shader = new Shader(vertexShader, fragmentShader);

		var layout:VertexLayout = [
			{
				name: "position",
				size: 2,
				type: FLOAT,
				normalized: false
			},
			{
				name: "color",
				size: 3,
				type: FLOAT,
				normalized: false
			}
		];

		var vertices:Array<Float> = [
			0.0, 0.5, 1, 0, 0,
			-0.5, -0.5, 0, 1, 0,
            0.5, -0.5, 0, 0, 1
		];

		vb = new VertexBuffer(new Float32Array(vertices), layout);

		var indices:Array<Int> = [0, 1, 2];

		ib = new IndexBuffer(new UInt32Array(indices));

	}

	override function onResize(width:Int, height:Int) {
        super.onResize(width, height);
        GL.viewport(0, 0, width, height);
    }

	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);

		GL.clearColor(0.1, 0.1, 0.1, 1.0);

		GL.clear(GL.COLOR_BUFFER_BIT);

		shader.bind();

		vb.bind();
		ib.bind();

		GL.drawElements(GL.TRIANGLES, ib.count, GL.UNSIGNED_INT, 0);
	}
}
