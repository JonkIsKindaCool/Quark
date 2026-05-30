package quark.graphics;

import lime.graphics.opengl.GL;

enum BlendFactor {
	ZERO; 
	ONE;
	SRC_COLOR; 
	ONE_MINUS_SRC_COLOR;
	DST_COLOR; 
	ONE_MINUS_DST_COLOR;
	SRC_ALPHA;
	ONE_MINUS_SRC_ALPHA;
	DST_ALPHA; 
	ONE_MINUS_DST_ALPHA;
	CONSTANT_COLOR; 
	ONE_MINUS_CONSTANT_COLOR;
	CONSTANT_ALPHA;
	ONE_MINUS_CONSTANT_ALPHA;
	SRC_ALPHA_SATURATE;
}

enum BlendEquation {
	ADD; 
	SUBTRACT;
	REVERSE_SUBTRACT; 
	MIN;
	MAX;
}

typedef BlendState = {
	srcColor:BlendFactor,
	dstColor:BlendFactor,
	srcAlpha:BlendFactor,
	dstAlpha:BlendFactor,
	equationColor:BlendEquation,
	equationAlpha:BlendEquation,
}

abstract BlendMode(BlendState) from BlendState to BlendState {
	public static final ALPHA:BlendMode = {
		srcColor: SRC_ALPHA,
		dstColor: ONE_MINUS_SRC_ALPHA,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	public static final OPAQUE:BlendMode = {
		srcColor: ONE,
		dstColor: ZERO,
		srcAlpha: ONE,
		dstAlpha: ZERO,
		equationColor: ADD,
		equationAlpha: ADD
	}

	public static final ADDITIVE:BlendMode = {
		srcColor: SRC_ALPHA,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: ADD,
		equationAlpha: ADD
	}

	public static final MULTIPLY:BlendMode = {
		srcColor: DST_COLOR,
		dstColor: ZERO,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	public static final SCREEN:BlendMode = {
		srcColor: ONE,
		dstColor: ONE_MINUS_SRC_COLOR,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	public static final PREMULTIPLIED_ALPHA:BlendMode = {
		srcColor: ONE,
		dstColor: ONE_MINUS_SRC_ALPHA,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	public static final SUBTRACT:BlendMode = {
		srcColor: SRC_ALPHA,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: REVERSE_SUBTRACT,
		equationAlpha: ADD
	}

	public static final DARKEN:BlendMode = {
		srcColor: ONE,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: MIN,
		equationAlpha: ADD
	}

	public static final LIGHTEN:BlendMode = {
		srcColor: ONE,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: MAX,
		equationAlpha: ADD
	}

	public inline function new(state:BlendState) {
		this = state;
	}

	public function apply():Void {
		if (isOpaque()) {
			GL.disable(GL.BLEND);
			return;
		}

		GL.enable(GL.BLEND);
		GL.blendFuncSeparate(resolveFactor(this.srcColor), resolveFactor(this.dstColor), resolveFactor(this.srcAlpha), resolveFactor(this.dstAlpha));
		GL.blendEquationSeparate(resolveEquation(this.equationColor), resolveEquation(this.equationAlpha));
	}

	public static function disable():Void {
		GL.disable(GL.BLEND);
	}

	public static function custom(state:BlendState):BlendMode {
		return state;
	}

	inline function isOpaque():Bool {
		return this.srcColor == ONE && this.dstColor == ZERO && this.equationColor == ADD;
	}

	static function resolveFactor(f:BlendFactor):Int {
		return switch f {
			case ZERO: GL.ZERO;
			case ONE: GL.ONE;
			case SRC_COLOR: GL.SRC_COLOR;
			case ONE_MINUS_SRC_COLOR: GL.ONE_MINUS_SRC_COLOR;
			case DST_COLOR: GL.DST_COLOR;
			case ONE_MINUS_DST_COLOR: GL.ONE_MINUS_DST_COLOR;
			case SRC_ALPHA: GL.SRC_ALPHA;
			case ONE_MINUS_SRC_ALPHA: GL.ONE_MINUS_SRC_ALPHA;
			case DST_ALPHA: GL.DST_ALPHA;
			case ONE_MINUS_DST_ALPHA: GL.ONE_MINUS_DST_ALPHA;
			case CONSTANT_COLOR: GL.CONSTANT_COLOR;
			case ONE_MINUS_CONSTANT_COLOR: GL.ONE_MINUS_CONSTANT_COLOR;
			case CONSTANT_ALPHA: GL.CONSTANT_ALPHA;
			case ONE_MINUS_CONSTANT_ALPHA: GL.ONE_MINUS_CONSTANT_ALPHA;
			case SRC_ALPHA_SATURATE: GL.SRC_ALPHA_SATURATE;
		}
	}

	static function resolveEquation(e:BlendEquation):Int {
		return switch e {
			case ADD: GL.FUNC_ADD;
			case BlendEquation.SUBTRACT: GL.FUNC_SUBTRACT;
			case REVERSE_SUBTRACT: GL.FUNC_REVERSE_SUBTRACT;
			case MIN: GL.MIN;
			case MAX: GL.MAX;
		}
	}
}
