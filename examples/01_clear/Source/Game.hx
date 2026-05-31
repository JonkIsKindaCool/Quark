package;

import quark.utils.Color;
import lime.graphics.RenderContext;
import quark.app.App;
import lime.graphics.opengl.GL;

class Game extends App {
	override function onRender(ctx:RenderContext) {
		super.onRender(ctx);

		var color:Color = ctx.attributes.background;

		GL.clearColor(color.rf, color.bf, color.gf, color.af);
		GL.clear(GL.COLOR_BUFFER_BIT);
	}

	override function onResize(width:Int, height:Int) {
		super.onResize(width, height);
		GL.viewport(0, 0, width, height);
	}
}
