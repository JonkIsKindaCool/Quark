package quark.app;

import lime.graphics.WebGL2RenderContext;
import lime.ui.Touch;
import lime.ui.Window;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseButton;
import lime.ui.MouseWheelMode;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;

/**
 * Base application class for Quark.
 *
 * This class provides the main application lifecycle and input callbacks.
 * Extend it and override the methods you need, then start it using
 * `App.run()`.
 */
class App {

	/**
	 * Main OpenGL context used by Quark.
	 *
	 * Returns the active WebGL2/OpenGL context associated with
	 * the application window.
	 */
	public static var GL(get, never):WebGL2RenderContext;

	private static var _initialized:Bool = false;

	private static function get_GL() {
		return #if sys App.context.gl #else App.context #end;
	}

	/**
	 * Active rendering context.
	 *
	 * This is the same rendering context used by the main application window.
	 */
	public static var context:RenderContext;

	/**
	 * Currently running application instance.
	 */
	public static var instance:App;

	/**
	 * Starts a Quark application.
	 *
	 * Registers all lifecycle, rendering and input callbacks.
	 *
	 * @param app Application instance to run.
	 * @throws String If another application is already running.
	 */
	public static function run(app:App) {
		if (instance != null){
			throw 'Cannot have 2 quark applications running at the same time';
		}

		instance = app;

		var win:Window = Application.current.window;

		Application.current.onUpdate.add(dt -> {
			if (!_initialized) {
				return;
			}

			instance.onUpdate(dt / 1000.0);
		});

		win.onRender.add(ctx -> {
			App.context = ctx;

			if (GL == null)
				return;

			if (!_initialized) {
				instance.onCreate();

				trace(GL);

				_initialized = true;
				return;
			}

			instance.onRender(ctx);
		});

		win.onResize.add((w, h) -> instance.onResize(w, h));
		win.onMove.add((x, y) -> instance.onMove(x, y));
		win.onFocusIn.add(() -> instance.onFocus());
		win.onFocusOut.add(() -> instance.onBlur());
		win.onFullscreen.add(() -> instance.onFullscreen());
		win.onClose.add(() -> instance.onClose());

		win.onKeyDown.add((key, mod) -> instance.onKeyDown(key, mod));
		win.onKeyUp.add((key, mod) -> instance.onKeyUp(key, mod));
		win.onTextInput.add(text -> instance.onTextInput(text));

		win.onMouseMove.add((x, y) -> instance.onMouseMove(x, y));
		win.onMouseMoveRelative.add((x, y) -> instance.onMouseMoveRelative(x, y));
		win.onMouseDown.add((x, y, btn) -> instance.onMouseDown(x, y, btn));
		win.onMouseUp.add((x, y, btn) -> instance.onMouseUp(x, y, btn));
		win.onMouseWheel.add((dx, dy, mode) -> instance.onMouseWheel(dx, dy, mode));

		Touch.onStart.add(instance.onTouchStart);
		Touch.onMove.add(instance.onTouchMove);
		Touch.onEnd.add(instance.onTouchEnd);

		Gamepad.onConnect.add(gamepad -> {
			gamepad.onAxisMove.add((axis, val) -> instance.onGamepadAxis(gamepad, axis, val));
			gamepad.onButtonDown.add(btn -> instance.onGamepadButtonDown(gamepad, btn));
			gamepad.onButtonUp.add(btn -> instance.onGamepadButtonUp(gamepad, btn));
			instance.onGamepadConnect(gamepad);
		});

		Application.current.onExit.add(code -> instance.onExit(code));
	}

	/**
	 * Creates a new application instance.
	 */
	public function new() {}

	/**
	 * Called once after the graphics context has been created.
	 *
	 * Use this to initialize resources such as shaders,
	 * textures, meshes and buffers.
	 */
	public function onCreate() {}

	/**
	 * Called every frame before rendering.
	 *
	 * @param dt Delta time in seconds.
	 */
	public function onUpdate(dt:Float) {}

	/**
	 * Called every frame to render the application.
	 *
	 * @param ctx Current rendering context.
	 */
	public function onRender(ctx:RenderContext) {}

	/**
	 * Called when the window is resized.
	 *
	 * @param width New window width.
	 * @param height New window height.
	 */
	public function onResize(width:Int, height:Int) {}

	/**
	 * Called when the window position changes.
	 *
	 * @param x New X position.
	 * @param y New Y position.
	 */
	public function onMove(x:Float, y:Float) {}

	/**
	 * Called when the application gains focus.
	 */
	public function onFocus() {}

	/**
	 * Called when the application loses focus.
	 */
	public function onBlur() {}

	/**
	 * Called when fullscreen mode is entered or toggled.
	 */
	public function onFullscreen() {}

	/**
	 * Called when the window is requested to close.
	 */
	public function onClose() {}

	/**
	 * Called before the application exits.
	 *
	 * @param code Exit code.
	 */
	public function onExit(code:Int) {}

	/**
	 * Called when a key is pressed.
	 *
	 * @param key Pressed key.
	 * @param modifier Active modifier keys.
	 */
	public function onKeyDown(key:KeyCode, modifier:KeyModifier) {}

	/**
	 * Called when a key is released.
	 *
	 * @param key Released key.
	 * @param modifier Active modifier keys.
	 */
	public function onKeyUp(key:KeyCode, modifier:KeyModifier) {}

	/**
	 * Called when text input is received.
	 *
	 * @param text Input text.
	 */
	public function onTextInput(text:String) {}

	/**
	 * Called when the mouse moves.
	 *
	 * @param x Mouse X position.
	 * @param y Mouse Y position.
	 */
	public function onMouseMove(x:Float, y:Float) {}

	/**
	 * Called when the mouse moves in relative mode.
	 *
	 * @param dx Horizontal movement.
	 * @param dy Vertical movement.
	 */
	public function onMouseMoveRelative(dx:Float, dy:Float) {}

	/**
	 * Called when a mouse button is pressed.
	 *
	 * @param x Mouse X position.
	 * @param y Mouse Y position.
	 * @param button Pressed button.
	 */
	public function onMouseDown(x:Float, y:Float, button:MouseButton) {}

	/**
	 * Called when a mouse button is released.
	 *
	 * @param x Mouse X position.
	 * @param y Mouse Y position.
	 * @param button Released button.
	 */
	public function onMouseUp(x:Float, y:Float, button:MouseButton) {}

	/**
	 * Called when the mouse wheel is moved.
	 *
	 * @param dx Horizontal wheel delta.
	 * @param dy Vertical wheel delta.
	 * @param mode Wheel mode.
	 */
	public function onMouseWheel(dx:Float, dy:Float, mode:MouseWheelMode) {}

	/**
	 * Called when a gamepad is connected.
	 *
	 * @param gamepad Connected gamepad.
	 */
	public function onGamepadConnect(gamepad:Gamepad) {}

	/**
	 * Called when a gamepad axis changes.
	 *
	 * @param gamepad Source gamepad.
	 * @param axis Axis identifier.
	 * @param value Axis value.
	 */
	public function onGamepadAxis(gamepad:Gamepad, axis:GamepadAxis, value:Float) {}

	/**
	 * Called when a gamepad button is pressed.
	 *
	 * @param gamepad Source gamepad.
	 * @param button Pressed button.
	 */
	public function onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton) {}

	/**
	 * Called when a gamepad button is released.
	 *
	 * @param gamepad Source gamepad.
	 * @param button Released button.
	 */
	public function onGamepadButtonUp(gamepad:Gamepad, button:GamepadButton) {}

	/**
	 * Called when a touch begins.
	 *
	 * @param touch Touch information.
	 */
	public function onTouchStart(touch:Touch) {}

	/**
	 * Called when a touch moves.
	 *
	 * @param touch Touch information.
	 */
	public function onTouchMove(touch:Touch) {}

	/**
	 * Called when a touch ends.
	 *
	 * @param touch Touch information.
	 */
	public function onTouchEnd(touch:Touch) {}
}