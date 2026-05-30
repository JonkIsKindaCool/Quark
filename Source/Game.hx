package;

import lime.graphics.Image;
import lime.app.Application;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import quark.math.Mat4;
import quark.math.Vec3;
import quark.math.MathUtils;
import lime.utils.UInt32Array;
import lime.utils.Float32Array;
import lime.graphics.RenderContext;
import lime.graphics.opengl.GL;
import quark.app.App;
import quark.graphics.Shader;
import quark.graphics.Texture;
import quark.graphics.VertexBuffer;
import quark.graphics.IndexBuffer;
import quark.graphics.VertexLayout;

class Game extends App {
	var cubeShader:Shader;
	var cubeVB:VertexBuffer;
	var cubeIB:IndexBuffer;
	var instanceVB:VertexBuffer;
	var cubeTextures:Array<Texture>;
	var textureCount:Int = 4;

	static inline var INSTANCE_COUNT = 1000;

	var skyShader:Shader;
	var skyVB:VertexBuffer;
	var skyIB:IndexBuffer;
	var skyTextures:Array<Texture>;

	var projection:Mat4;
	var camPos:Vec3 = new Vec3(0, 0, 0);
	var yaw:Float = -1.5708;
	var pitch:Float = 0.0;
	var mouseSensitivity:Float = 0.002;
	var moveSpeed:Float = 20.0;
	var keyW:Bool = false;
	var keyS:Bool = false;
	var keyA:Bool = false;
	var keyD:Bool = false;
	var keyUp:Bool = false;
	var keyDown:Bool = false;
	var locked:Bool = false;

	var cubeSize:Float = 2.0;

	override function onCreate() {
		super.onCreate();
		GL.enable(GL.DEPTH_TEST);
		projection = Mat4.perspective(0.785, 800 / 600, 0.1, 500.0);

		buildCubeShader();
		buildCubeGeometry();
		buildInstanceData();
		buildSkybox();

		cubeTextures = [
			new Texture(Image.fromFile("assets/cato.jpeg")),
			new Texture(Image.fromFile("assets/nerd.jpeg")),
			new Texture(Image.fromFile("assets/oye.jpeg")),
			new Texture(Image.fromFile("assets/nahiwin.jpg"))
		];
	}

	function buildCubeShader() {
		var vert = "
			attribute vec3 position;
			attribute vec2 uv;
			attribute vec4 iMat0;
			attribute vec4 iMat1;
			attribute vec4 iMat2;
			attribute vec4 iMat3;
			attribute float iTexIndex;

			varying vec2  vUV;
			varying float vTexIndex;

			uniform mat4 projection;
			uniform mat4 view;

			void main() {
				vUV      = uv;
				vTexIndex = iTexIndex;
				mat4 model = mat4(iMat0, iMat1, iMat2, iMat3);
				gl_Position = projection * view * model * vec4(position, 1.0);
			}
		";
		var frag = "
            #ifdef GL_ES
            precision mediump float;
            #endif

            varying vec2  vUV;
            varying float vTexIndex;

            uniform sampler2D uTex0;
            uniform sampler2D uTex1;
            uniform sampler2D uTex2;
            uniform sampler2D uTex3;

            void main() {
                int idx = int(vTexIndex);
                vec4 col;
                if      (idx == 0) col = texture2D(uTex0, vUV);
                else if (idx == 1) col = texture2D(uTex1, vUV);
                else if (idx == 2) col = texture2D(uTex2, vUV);
                else               col = texture2D(uTex3, vUV);
                gl_FragColor = col;
            }
        ";

		cubeShader = new Shader(vert, frag);
	}

	function buildCubeGeometry() {
		var layout:VertexLayout = [
			{
				name: "position",
				size: 3,
				type: FLOAT,
				normalized: false
			},
			{
				name: "uv",
				size: 2,
				type: FLOAT,
				normalized: false
			}
		];

		var v:Array<Float> = [
			-0.5, -0.5,  0.5, 0.0, 1.0,  0.5, -0.5,  0.5, 1.0, 1.0,
			 0.5,  0.5,  0.5, 1.0, 0.0, -0.5,  0.5,  0.5, 0.0, 0.0,

			 0.5, -0.5, -0.5, 0.0, 1.0, -0.5, -0.5, -0.5, 1.0, 1.0,
			-0.5,  0.5, -0.5, 1.0, 0.0,  0.5,  0.5, -0.5, 0.0, 0.0,

			-0.5, -0.5, -0.5, 0.0, 1.0, -0.5, -0.5,  0.5, 1.0, 1.0,
			-0.5,  0.5,  0.5, 1.0, 0.0, -0.5,  0.5, -0.5, 0.0, 0.0,

			 0.5, -0.5,  0.5, 0.0, 1.0,  0.5, -0.5, -0.5, 1.0, 1.0,
			 0.5,  0.5, -0.5, 1.0, 0.0,  0.5,  0.5,  0.5, 0.0, 0.0,

			-0.5,  0.5,  0.5, 0.0, 1.0,  0.5,  0.5,  0.5, 1.0, 1.0,
			 0.5,  0.5, -0.5, 1.0, 0.0, -0.5,  0.5, -0.5, 0.0, 0.0,

			-0.5, -0.5, -0.5, 0.0, 1.0,  0.5, -0.5, -0.5, 1.0, 1.0,
			 0.5, -0.5,  0.5, 1.0, 0.0, -0.5, -0.5,  0.5, 0.0, 0.0,
		];

		cubeVB = new VertexBuffer(new Float32Array(v), layout);

		var indices:Array<Int> = [];
		for (f in 0...6) {
			var b = f * 4;
			indices = indices.concat([b, b + 1, b + 2, b, b + 2, b + 3]);
		}
		cubeIB = new IndexBuffer(new UInt32Array(indices));
	}

	function buildInstanceData() {
		var data = new Float32Array(INSTANCE_COUNT * 17);

		for (i in 0...INSTANCE_COUNT) {
			var tx = (Math.random() - 0.5) * 200;
			var ty = (Math.random() - 0.5) * 200;
			var tz = (Math.random() - 0.5) * 200;

			var rx = Math.random() * Math.PI * 2;
			var ry = Math.random() * Math.PI * 2;

			var model = Mat4.translation(new Vec3(tx, ty, tz)) * Mat4.rotationY(ry) * Mat4.rotationX(rx) * Mat4.scale(new Vec3(cubeSize, cubeSize, cubeSize));

			var arr = model.toArray();
			var base = i * 17;
			for (j in 0...16)
				data[base + j] = arr[j];

			data[base + 16] = Math.floor(Math.random() * textureCount);
		}

		var layout:VertexLayout = [
			{
				name: "iMat0",
				size: 4,
				type: FLOAT,
				normalized: false
			},
			{
				name: "iMat1",
				size: 4,
				type: FLOAT,
				normalized: false
			},
			{
				name: "iMat2",
				size: 4,
				type: FLOAT,
				normalized: false
			},
			{
				name: "iMat3",
				size: 4,
				type: FLOAT,
				normalized: false
			},
			{
				name: "iTexIndex",
				size: 1,
				type: FLOAT,
				normalized: false
			},
		];

		instanceVB = new VertexBuffer(data, layout);
	}

	function buildSkybox() {
		var vert = "
            attribute vec3 position;
            varying vec3 vDir;
            uniform mat4 projection;
            uniform mat4 view;
            void main() {
                vDir = position;

                mat4 viewNoTranslation = view;
				
                viewNoTranslation[3][0] = 0.0;
                viewNoTranslation[3][1] = 0.0;
                viewNoTranslation[3][2] = 0.0;

                vec4 pos = projection * viewNoTranslation * vec4(position, 1.0);

                gl_Position = pos.xyww;
            }
        ";

		var frag = "
            #ifdef GL_ES
            precision mediump float;
            #endif
            varying vec3 vDir;
            uniform sampler2D uRight;  
            uniform sampler2D uLeft;   
            uniform sampler2D uTop;   
            uniform sampler2D uBottom; 
            uniform sampler2D uFront;  
            uniform sampler2D uBack;   

            vec4 sampleFace(vec3 d) {
                vec3 a = abs(d);
                vec2 uv;
                int face;

                if (a.x >= a.y && a.x >= a.z) {
                    face = d.x > 0.0 ? 0 : 1;
                    uv = d.x > 0.0 ? vec2(-d.z, -d.y) / a.x
                                   : vec2( d.z, -d.y) / a.x;
                } else if (a.y >= a.x && a.y >= a.z) {
                    face = d.y > 0.0 ? 2 : 3;
                    uv = d.y > 0.0 ? vec2( d.x,  d.z) / a.y
                                   : vec2( d.x, -d.z) / a.y;
                } else {
                    face = d.z > 0.0 ? 4 : 5;
                    uv = d.z > 0.0 ? vec2( d.x, -d.y) / a.z
                                   : vec2(-d.x, -d.y) / a.z;
                }

                uv = uv * 0.5 + 0.5;

                if      (face == 0) return texture2D(uRight,  uv);
                else if (face == 1) return texture2D(uLeft,   uv);
                else if (face == 2) return texture2D(uTop,    uv);
                else if (face == 3) return texture2D(uBottom, uv);
                else if (face == 4) return texture2D(uFront,  uv);
                else                return texture2D(uBack,   uv);
            }

            void main() {
                gl_FragColor = sampleFace(normalize(vDir));
            }
        ";

		skyShader = new Shader(vert, frag);

		var skyVerts:Array<Float> = [
			-1, -1,  1,  1, -1,  1,  1,  1,  1, -1,  1,  1,
			 1, -1, -1, -1, -1, -1, -1,  1, -1,  1,  1, -1,
			-1, -1, -1, -1, -1,  1, -1,  1,  1, -1,  1, -1,
			 1, -1,  1,  1, -1, -1,  1,  1, -1,  1,  1,  1,
			-1,  1,  1,  1,  1,  1,  1,  1, -1, -1,  1, -1,
			-1, -1, -1,  1, -1, -1,  1, -1,  1, -1, -1,  1,
		];

		var skyLayout:VertexLayout = [
			{
				name: "position",
				size: 3,
				type: FLOAT,
				normalized: false
			}
		];

		skyVB = new VertexBuffer(new Float32Array(skyVerts), skyLayout);

		var skyIdx:Array<Int> = [];
		for (f in 0...6) {
			var b = f * 4;
			skyIdx = skyIdx.concat([b, b + 1, b + 2, b, b + 2, b + 3]);
		}
		skyIB = new IndexBuffer(new UInt32Array(skyIdx));

		skyTextures = [
			new Texture(Image.fromFile("assets/sky/right.jpg")),
			new Texture(Image.fromFile("assets/sky/left.jpg")),
			new Texture(Image.fromFile("assets/sky/top.jpg")),
			new Texture(Image.fromFile("assets/sky/bottom.jpg")),
			new Texture(Image.fromFile("assets/sky/front.jpg")),
			new Texture(Image.fromFile("assets/sky/back.jpg")),
		];
	}

	function getForward():Vec3 {
		return new Vec3(Math.cos(pitch) * Math.cos(yaw), Math.sin(pitch), Math.cos(pitch) * Math.sin(yaw)).normalized;
	}

	function getRight():Vec3
		return getForward().cross(new Vec3(0, 1, 0)).normalized;

	override function onKeyDown(key:KeyCode, modifier:KeyModifier) {
		super.onKeyDown(key, modifier);
		switch key {
			case W:
				keyW = true;
			case S:
				keyS = true;
			case A:
				keyA = true;
			case D:
				keyD = true;
			case E:
				keyUp = true;
			case Q:
				keyDown = true;
			case LEFT_SHIFT:
				locked = !locked;
				Application.current.window.mouseLock = locked;
			case ESCAPE:
				locked = false;
				Application.current.window.mouseLock = false;
			default:
		}
	}

	override function onKeyUp(key:KeyCode, modifier:KeyModifier) {
		super.onKeyUp(key, modifier);
		switch key {
			case W:
				keyW = false;
			case S:
				keyS = false;
			case A:
				keyA = false;
			case D:
				keyD = false;
			case E:
				keyUp = false;
			case Q:
				keyDown = false;
			default:
		}
	}

	override function onMouseMoveRelative(dx:Float, dy:Float) {
		super.onMouseMoveRelative(dx, dy);
		if (!locked)
			return;
		yaw += dx * mouseSensitivity;
		pitch -= dy * mouseSensitivity;
		pitch = MathUtils.clamp(pitch, -1.5, 1.5);
	}

	override function onUpdate(dt:Float) {
		var f = getForward(), r = getRight();
		if (keyW)
			camPos = camPos + f * (moveSpeed * dt);
		if (keyS)
			camPos = camPos - f * (moveSpeed * dt);
		if (keyA)
			camPos = camPos - r * (moveSpeed * dt);
		if (keyD)
			camPos = camPos + r * (moveSpeed * dt);
		if (keyUp)
			camPos = camPos + new Vec3(0, moveSpeed * dt, 0);
		if (keyDown)
			camPos = camPos - new Vec3(0, moveSpeed * dt, 0);
	}

	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);
		GL.clearColor(0.0, 0.0, 0.0, 1.0);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

		var view = Mat4.lookAt(camPos, camPos + getForward(), new Vec3(0, 1, 0));

		renderSkybox(view);
		renderCubes(view);
	}

	function renderSkybox(view:Mat4) {
		GL.depthMask(false);
		GL.depthFunc(GL.LEQUAL);

		skyShader.bind();
		skyShader.setMat4("projection", projection);

		var skyView = view.toArray();
		skyView[12] = 0;
		skyView[13] = 0;
		skyView[14] = 0;
		skyShader.setMat4Raw("view", skyView);

		skyShader.setInt("uRight", 0);
		skyShader.setInt("uLeft", 1);
		skyShader.setInt("uTop", 2);
		skyShader.setInt("uBottom", 3);
		skyShader.setInt("uFront", 4);
		skyShader.setInt("uBack", 5);

		for (i in 0...6)
			skyTextures[i].bind(i);

		skyVB.bind();
		skyIB.bind();
		GL.drawElements(GL.TRIANGLES, skyIB.count, GL.UNSIGNED_INT, 0);

		GL.depthMask(true);
		GL.depthFunc(GL.LESS);
	}

	function renderCubes(view:Mat4) {
		cubeShader.bind();
		cubeShader.setMat4("projection", projection);
		cubeShader.setMat4("view", view);
		cubeShader.setInt("uTex0", 0);
		cubeShader.setInt("uTex1", 1);
		cubeShader.setInt("uTex2", 2);
		cubeShader.setInt("uTex3", 3);

		for (i in 0...textureCount)
			cubeTextures[i].bind(i);

		cubeVB.bind();
		cubeIB.bind();

		instanceVB.bindInstanced(cubeShader, 1);

		GL.drawElementsInstanced(GL.TRIANGLES, cubeIB.count, GL.UNSIGNED_INT, 0, INSTANCE_COUNT);

		instanceVB.unbindInstanced(cubeShader);
	}

	override function onResize(width:Int, height:Int) {
		super.onResize(width, height);
		GL.viewport(0, 0, width, height);
		projection = Mat4.perspective(0.785, width / height, 0.1, 500.0);
	}
}
