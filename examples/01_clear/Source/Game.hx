package;

import quark.graphics.Color;
import lime.graphics.RenderContext;
import quark.app.App;

class Game extends App {
	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);

		var color:Color = ctx.attributes.background;

		App.GL.clearColor(color.rf, color.bf, color.gf, color.af);
		App.GL.clear(App.GL.COLOR_BUFFER_BIT);
	}

	override function onResize(width:Int, height:Int) {
		super.onResize(width, height);
		App.GL.viewport(0, 0, width, height);
	}
}
