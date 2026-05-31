package quark.graphics;

import lime.graphics.opengl.GL;

/**
 * Blend factors used by OpenGL when combining source and destination pixels.
 *
 * General formula:
 * result = (source * srcFactor) op (destination * dstFactor)
 */
enum BlendFactor {
	/** Always 0. */
	ZERO;

	/** Always 1. */
	ONE;

	/** Source color. */
	SRC_COLOR;

	/** 1 - source color. */
	ONE_MINUS_SRC_COLOR;

	/** Destination color. */
	DST_COLOR;

	/** 1 - destination color. */
	ONE_MINUS_DST_COLOR;

	/** Source alpha. */
	SRC_ALPHA;

	/** 1 - source alpha. */
	ONE_MINUS_SRC_ALPHA;

	/** Destination alpha. */
	DST_ALPHA;

	/** 1 - destination alpha. */
	ONE_MINUS_DST_ALPHA;

	/** Constant color specified through OpenGL. */
	CONSTANT_COLOR;

	/** 1 - constant color. */
	ONE_MINUS_CONSTANT_COLOR;

	/** Constant alpha specified through OpenGL. */
	CONSTANT_ALPHA;

	/** 1 - constant alpha. */
	ONE_MINUS_CONSTANT_ALPHA;

	/** Special saturation factor. */
	SRC_ALPHA_SATURATE;
}

/**
 * Blend equations used to combine source and destination values.
 */
enum BlendEquation {
	/** source + destination */
	ADD;

	/** source - destination */
	SUBTRACT;

	/** destination - source */
	REVERSE_SUBTRACT;

	/** Uses the minimum value. */
	MIN;

	/** Uses the maximum value. */
	MAX;
}

/**
 * Describes a complete blend state.
 *
 * Color and alpha channels can use independent
 * factors and equations.
 */
typedef BlendState = {
	/** Source color blend factor. */
	srcColor:BlendFactor,

	/** Destination color blend factor. */
	dstColor:BlendFactor,

	/** Source alpha blend factor. */
	srcAlpha:BlendFactor,

	/** Destination alpha blend factor. */
	dstAlpha:BlendFactor,

	/** Blend equation used for RGB channels. */
	equationColor:BlendEquation,

	/** Blend equation used for the alpha channel. */
	equationAlpha:BlendEquation,
}

/**
 * Represents an OpenGL blending configuration.
 *
 * Includes several predefined blend modes and
 * support for custom blend states.
 */
abstract BlendMode(BlendState) from BlendState to BlendState {

	/**
	 * Standard alpha blending.
	 *
	 * Commonly used for sprites, UI and transparent objects.
	 */
	public static final ALPHA:BlendMode = {
		srcColor: SRC_ALPHA,
		dstColor: ONE_MINUS_SRC_ALPHA,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	/**
	 * Opaque rendering.
	 *
	 * Completely replaces destination pixels.
	 */
	public static final OPAQUE:BlendMode = {
		srcColor: ONE,
		dstColor: ZERO,
		srcAlpha: ONE,
		dstAlpha: ZERO,
		equationColor: ADD,
		equationAlpha: ADD
	}

	/**
	 * Additive blending.
	 *
	 * Useful for light, glow and particle effects.
	 */
	public static final ADDITIVE:BlendMode = {
		srcColor: SRC_ALPHA,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: ADD,
		equationAlpha: ADD
	}

	/**
	 * Multiply blending.
	 *
	 * Produces darker results by multiplying colors.
	 */
	public static final MULTIPLY:BlendMode = {
		srcColor: DST_COLOR,
		dstColor: ZERO,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	/**
	 * Screen blending.
	 *
	 * Produces brighter results and is often used
	 * as the inverse of multiply blending.
	 */
	public static final SCREEN:BlendMode = {
		srcColor: ONE,
		dstColor: ONE_MINUS_SRC_COLOR,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	/**
	 * Premultiplied alpha blending.
	 *
	 * Intended for textures whose RGB values have
	 * already been multiplied by alpha.
	 */
	public static final PREMULTIPLIED_ALPHA:BlendMode = {
		srcColor: ONE,
		dstColor: ONE_MINUS_SRC_ALPHA,
		srcAlpha: ONE,
		dstAlpha: ONE_MINUS_SRC_ALPHA,
		equationColor: ADD,
		equationAlpha: ADD
	}

	/**
	 * Subtractive blending.
	 *
	 * Subtracts source values from destination values.
	 */
	public static final SUBTRACT:BlendMode = {
		srcColor: SRC_ALPHA,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: REVERSE_SUBTRACT,
		equationAlpha: ADD
	}

	/**
	 * Darken blending.
	 *
	 * Keeps the darker value between source and destination.
	 */
	public static final DARKEN:BlendMode = {
		srcColor: ONE,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: MIN,
		equationAlpha: ADD
	}

	/**
	 * Lighten blending.
	 *
	 * Keeps the brighter value between source and destination.
	 */
	public static final LIGHTEN:BlendMode = {
		srcColor: ONE,
		dstColor: ONE,
		srcAlpha: ONE,
		dstAlpha: ONE,
		equationColor: MAX,
		equationAlpha: ADD
	}

	/**
	 * Creates a blend mode from a blend state.
	 *
	 * @param state Blend configuration.
	 */
	public inline function new(state:BlendState) {
		this = state;
	}

	/**
	 * Applies the blend state to OpenGL.
	 *
	 * Blending is automatically disabled when
	 * the mode is fully opaque.
	 */
	public function apply():Void {
		if (isOpaque()) {
			GL.disable(GL.BLEND);
			return;
		}

		GL.enable(GL.BLEND);
		GL.blendFuncSeparate(resolveFactor(this.srcColor), resolveFactor(this.dstColor), resolveFactor(this.srcAlpha), resolveFactor(this.dstAlpha));
		GL.blendEquationSeparate(resolveEquation(this.equationColor), resolveEquation(this.equationAlpha));
	}

	/**
	 * Disables OpenGL blending.
	 */
	public static function disable():Void {
		GL.disable(GL.BLEND);
	}

	/**
	 * Creates a custom blend mode.
	 *
	 * @param state Blend state definition.
	 * @return Custom blend mode.
	 */
	public static function custom(state:BlendState):BlendMode {
		return state;
	}

	/**
	 * Checks whether this blend mode is equivalent
	 * to fully opaque rendering.
	 *
	 * @return True if blending is not required.
	 */
	inline function isOpaque():Bool {
		return this.srcColor == ONE && this.dstColor == ZERO && this.equationColor == ADD;
	}

	/**
	 * Converts a BlendFactor to its OpenGL constant.
	 *
	 * @param f Blend factor.
	 * @return OpenGL enum value.
	 */
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

	/**
	 * Converts a BlendEquation to its OpenGL constant.
	 *
	 * @param e Blend equation.
	 * @return OpenGL enum value.
	 */
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