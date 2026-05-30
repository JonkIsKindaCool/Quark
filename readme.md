# ⚛ Quark

> A lightweight OpenGL wrapper built on top of [Lime](https://github.com/openfl/lime), designed to make low-level rendering approachable without hiding what's happening underneath.

---

## What is Quark?

Quark is the fundamental building block — hence the name. It sits directly on top of Lime's OpenGL context and provides a clean, structured entry point for render loops, lifecycle management, and math utilities, so you can focus on what you're actually building instead of wiring up boilerplate.

It is **not** a game framework. It does not manage scenes, entities, or assets. That's a job for the layers above it.

---

## Why Lime?

Lime already solves the hard cross-platform problem: it provides an OpenGL context on Desktop (Windows, macOS, Linux), Web (HTML5/WebGL), Mobile (iOS, Android), and consoles. Quark doesn't reinvent that — it wraps the surface Lime exposes and makes it ergonomic to work with from Haxe.

---

## Installation

```bash
haxelib install quark
```

Or via git for the latest version:

```bash
haxelib git quark https://github.com/JonkIsKindaCool/quark
```

Add it to your `project.xml`:

```xml
<haxelib name="quark" />
<haxelib name="lime" />
```

---

## Basic Usage

The most minimal Quark application looks like this:

```haxe
import lime.graphics.RenderContext;
import lime.app.Application;
import quark.app.App;

class Main extends Application {
    override function onWindowCreate() {
        super.onWindowCreate();
        App.run(new Game());
    }
}

class Game extends App {
    override function onCreate() {
        super.onCreate();
        // initialize your resources here
    }

    override function onUpdate(dt:Float) {
        super.onUpdate(dt);
        // dt is delta time in seconds
    }

    override function onRender(ctx:RenderContext) {
        super.onRender(ctx);
        // issue your GL draw calls here
    }
}
```

`App` gives you a clean lifecycle on top of Lime's `Application`:

| Method | When it's called |
|---|---|
| `onCreate()` | Once, after the GL context is ready |
| `onUpdate(dt)` | Every frame, before rendering |
| `onRender(ctx)` | Every frame, during the render pass |
| `onClose()` | When the application is closing |

---

## Math Utilities

Quark includes a small math library so you're not reaching for external dependencies for the basics:

```haxe
import quark.math.Vec2;
import quark.math.Vec3;
import quark.math.Mat4;
import quark.math.MathUtils;

var pos:Vec2   = new Vec2(100, 200);
var dir:Vec2   = new Vec2(3, 4).normalized;
var model:Mat4 = Mat4.identity();

model = model * Mat4.translation(new Vec3(pos.x, pos.y, 0));
model = model * Mat4.rotationZ(MathUtils.toRadians(45));
model = model * Mat4.scale(new Vec3(2.0, 2.0, 1.0));
```

Included types:

- `Vec2`, `Vec3`, `Vec4`
- `Mat3`, `Mat4`, `Quat`
- `Rect`, `Color`
- `MathUtils` — lerp, clamp, remap, toRadians, toDegrees, etc.

---

## Shader Helpers

Writing and compiling shaders manually is verbose. Quark provides a thin wrapper:

```haxe
import quark.graphics.Shader;

var shader:Shader = new Shader(
    vertexSrc,    // your GLSL vertex source
    fragmentSrc   // your GLSL fragment source
);

shader.bind();
shader.setFloat("uTime",       elapsed);
shader.setVec2("uResolution",  new Vec2(1280, 720));
shader.setMat4("uProjection",  projection);
shader.unbind();
```

---

## Buffers

```haxe
import quark.graphics.VertexBuffer;
import quark.graphics.IndexBuffer;
import quark.graphics.VertexLayout;

var vbo:VertexBuffer = new VertexBuffer(new Float32Array(vertices), VertexLayout.POS2); // x, y
var ibo:IndexBuffer = new IndexBuffer(new UInt32Array(indices));

vbo.bind();
ibo.bind();
// draw call here
vbo.unbind();
```

---

## What Quark is NOT

Quark deliberately omits things that belong in a higher layer:

- ❌ No scene management
- ❌ No asset loading pipeline
- ❌ No entity or component system
- ❌ No audio management
- ❌ No complex input management

---

## Examples

The `examples/` folder in the repository contains progressively more complex demos:

| Example | What it shows |
|---|---|
| `01_clear` | Clear the screen with a the window color |
| `02_triangle` | First triangle using a VBO and a basic shader |
| `03_texture` | Sampling a texture in GLSL |
| `04_transform` | Applying a model matrix for position, rotation, and scale |
| `05_batch` | Simple quad batching for multiple sprites |

---

## Targets

| Target | Status |
|---|---|
| Desktop (HL/C++) | ✅ Supported |
| HTML5 / WebGL | ✅ Supported |
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Consoles | 🔧 Planned |

---

## License

MIT — do whatever you want, just don't remove the attribution.