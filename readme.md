# ⚛ Quark

> A lightweight graphics library built on top of Lime, providing modern OpenGL abstractions without hiding the underlying API.

---

## Overview

Quark is a low-level rendering toolkit for Haxe.

It sits directly above Lime's OpenGL context and provides a clean, typed API for common graphics operations such as:

* Shader compilation and management
* Vertex and index buffers
* Vertex array objects
* Textures and cubemaps
* Framebuffers and render targets
* Render state configuration
* Math utilities

Quark is intentionally small.

It does not attempt to be a game engine, scene graph, ECS, renderer, or asset pipeline.

Its goal is to make OpenGL easier to work with while keeping the underlying concepts visible and accessible.

---

## Philosophy

Quark follows a few simple principles:

### Stay close to OpenGL

If you already know OpenGL, Quark should feel familiar.

```haxe
var vao = new VertexArray();
var vbo = new VertexBuffer(vertices);
var shader = new Shader(vertexSrc, fragmentSrc);

```

The library wraps OpenGL objects rather than replacing them with a completely different rendering model.

---

### Provide type safety

Instead of passing raw OpenGL constants everywhere:

```haxe
GL.texParameteri(
    GL.TEXTURE_2D,
    GL.TEXTURE_MIN_FILTER,
    GL.LINEAR
);

```

you work with typed APIs:

```haxe
texture.setFilter(
    TextureFilter.LINEAR,
    TextureFilter.LINEAR
);

```

---

### Build foundations, not frameworks

Quark provides the rendering primitives.

Everything above that layer is left to the user.

---

## Features

### Application Framework

A lightweight application lifecycle built on top of Lime. You can override any of these callbacks in your custom `App` class:

#### Lifecycle & Rendering

* `onCreate()`: Called once after the graphics context has been created. Ideal for initializing resources.
* `onUpdate(dt:Float)`: Called every frame before rendering. Passes the delta time in seconds.
* `onRender(ctx:RenderContext)`: Called every frame to render the application.
* `onExit(code:Int)`: Called before the application exits, providing the status code.

#### Window Management

* `onResize(width:Int, height:Int)`: Called when the window is resized.
* `onMove(x:Float, y:Float)`: Called when the window position changes.
* `onFocus()`: Called when the application gains focus.
* `onBlur()`: Called when the application loses focus.
* `onFullscreen()`: Called when fullscreen mode is entered or toggled.
* `onClose()`: Called when the window is requested to close.

#### Keyboard Input

* `onKeyDown(key:KeyCode, modifier:KeyModifier)`: Called when a key is pressed.
* `onKeyUp(key:KeyCode, modifier:KeyModifier)`: Called when a key is released.
* `onTextInput(text:String)`: Called when raw text input is received.

#### Mouse Input

* `onMouseMove(x:Float, y:Float)`: Called when the mouse moves.
* `onMouseMoveRelative(dx:Float, dy:Float)`: Called when the mouse moves in relative mode (raw movement).
* `onMouseDown(x:Float, y:Float, button:MouseButton)`: Called when a mouse button is pressed.
* `onMouseUp(x:Float, y:Float, button:MouseButton)`: Called when a mouse button is released.
* `onMouseWheel(dx:Float, dy:Float, mode:MouseWheelMode)`: Called when the mouse wheel is moved.

#### Gamepad Input

* `onGamepadConnect(gamepad:Gamepad)`: Called when a gamepad is connected.
* `onGamepadAxis(gamepad:Gamepad, axis:GamepadAxis, value:Float)`: Called when a gamepad axis changes.
* `onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton)`: Called when a gamepad button is pressed.
* `onGamepadButtonUp(gamepad:Gamepad, button:GamepadButton)`: Called when a gamepad button is released.

#### Touch Input

* `onTouchStart(touch:Touch)`: Called when a touch begins.
* `onTouchMove(touch:Touch)`: Called when a touch moves.
* `onTouchEnd(touch:Touch)`: Called when a touch ends.

---

### Graphics

#### Shaders

* GLSL shader compilation
* Uniform management
* Automatic type helpers

#### Buffers

* VertexBuffer
* IndexBuffer
* UniformBuffer

#### Vertex Objects

* VertexArray
* VertexLayout
* VertexAttribute

#### Textures

* Texture
* Cubemap
* Texture filtering
* Texture wrapping
* Mipmap generation

#### Render Targets

* Framebuffer
* Renderbuffer

---

### Mathematics

Included math types:

```text
Vec2
Vec3
Vec4

Mat3
Mat4

Quat

Rect
Color

```

Utility functions:

```text
lerp
clamp
remap
distance
toRadians
toDegrees

```

and more.

---

## Installation

Install through Haxelib:

```bash
haxelib install quark

```

Or use the latest development version:

```bash
haxelib git quark https://github.com/JonkIsKindaCool/quark

```

Add Quark and Lime to your project:

```xml
<haxelib name="quark" />
<haxelib name="lime" />

```

---

## Getting Started

```haxe
import lime.app.Application;
import lime.graphics.RenderContext;

import quark.app.App;

class Main extends Application {
    override function onWindowCreate():Void {
        super.onWindowCreate();
        App.run(new Game());
    }
}

class Game extends App {

    override function onCreate():Void {
        super.onCreate();
    }

    override function onUpdate(dt:Float):Void {
        super.onUpdate(dt);
    }

    override function onRender(ctx:RenderContext):Void {
        super.onRender(ctx);
    }
}

```

---

## Creating a Shader

```haxe
var shader = new Shader(
    vertexSource,
    fragmentSource
);

shader.bind();

shader.setFloat("uTime", elapsed);
shader.setMat4("uProjection", projection);

shader.unbind();

```

---

## Creating Buffers

```haxe
var vertexBuffer = new VertexBuffer(
    new Float32Array(vertices)
);

var indexBuffer = new IndexBuffer(
    new UInt32Array(indices)
);

```

---

## Creating a Vertex Array

```haxe
var vao = new VertexArray();

vao.addBuffer(
    vertexBuffer,
    VertexLayout.POS3_UV2
);

vao.setIndexBuffer(indexBuffer);

```

---

## Loading a Texture

```haxe
var texture = new Texture(
    Image.fromFile("assets/player.png")
);

texture.bind();

```

---

## Render-To-Texture

```haxe
var colorTexture = Texture.empty(
    1024,
    1024
);

var depthBuffer = new Renderbuffer(
    1024,
    1024
);

var framebuffer = new Framebuffer();

framebuffer.attachTexture(colorTexture);
framebuffer.attachRenderbuffer(depthBuffer);

```

---

## What Quark Is Not

Quark intentionally does not include:

* Scene management
* Entity systems
* Component systems
* Asset pipelines
* Animation systems
* Physics engines
* Audio systems
* UI frameworks

These belong in higher-level libraries built on top of Quark.

---

## Targets

| Platform | Status |
| --- | --- |
| Windows | ✅ |
| Linux | ✅ |
| macOS | ✅ |
| HTML5 / WebGL | ✅ |
| Android | ✅ |
| iOS | ✅ |
| Consoles | 🔧 Planned |

---

## Examples

The repository includes a collection of examples demonstrating:

* Window creation
* Basic rendering
* Texturing
* Transformations
* Vertex layouts
* Framebuffers
* Sprite batching
* 3D rendering

---

## License

MIT License.

Use it in personal, commercial, open-source, or proprietary projects. Attribution is appreciated.