package quark.app;

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

class App {
	public static var context:RenderContext;
	public static var instance:App;

	public static function run(app:App) {
		instance = app;

		var win:Window = Application.current.window;

		Application.current.onUpdate.add(dt -> {
			instance.onUpdate(dt / 1000.0);
		});

		win.onRender.add(ctx -> {
			App.context = ctx;
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

		instance.onCreate();
	}

	public function new() {}

	public function onCreate() {}

	public function onUpdate(dt:Float) {}

	public function onRender(ctx:RenderContext) {}

	public function onResize(width:Int, height:Int) {}

	public function onMove(x:Float, y:Float) {}

	public function onFocus() {}

	public function onBlur() {}

	public function onFullscreen() {}

	public function onClose() {}

	public function onExit(code:Int) {}

	public function onKeyDown(key:KeyCode, modifier:KeyModifier) {}

	public function onKeyUp(key:KeyCode, modifier:KeyModifier) {}

	public function onTextInput(text:String) {}

	public function onMouseMove(x:Float, y:Float) {}

	public function onMouseMoveRelative(dx:Float, dy:Float) {}

	public function onMouseDown(x:Float, y:Float, button:MouseButton) {}

	public function onMouseUp(x:Float, y:Float, button:MouseButton) {}

	public function onMouseWheel(dx:Float, dy:Float, mode:MouseWheelMode) {}

	public function onGamepadConnect(gamepad:Gamepad) {}

	public function onGamepadAxis(gamepad:Gamepad, axis:GamepadAxis, value:Float) {}

	public function onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton) {}

	public function onGamepadButtonUp(gamepad:Gamepad, button:GamepadButton) {}

	public function onTouchStart(touch:Touch) {}

	public function onTouchMove(touch:Touch) {}

	public function onTouchEnd(touch:Touch) {}
}
