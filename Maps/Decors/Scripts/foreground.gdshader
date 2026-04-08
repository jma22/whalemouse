shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap;
uniform sampler2D base_texture : source_color, filter_linear_mipmap;

uniform float radius : hint_range(0.0, 10.0) = 0.4;
uniform float center_alpha : hint_range(0.0, 1.0) = 1.0;
uniform float edge_alpha : hint_range(0.0, 1.0) = 0.0;

uniform float pixel_size : hint_range(1.0, 100.0, 1.0) = 8.0;
uniform vec2 resolution = vec2(400.0, 400.0);
uniform vec2 dither_offset = vec2(2.0, 0.0);
uniform int bayer_size : hint_enum("2x2", "4x4", "8x8") = 2;
uniform bool interpolate = true;
uniform bool invert = false;
uniform float falloff : hint_range(0.1, 10.0) = 2.5;
uniform float noise_speed : hint_range(0.0, 10.0) = 1.0;
uniform vec2 center_offset = vec2(0.0, 0.0);
uniform float vertical_stretch : hint_range(0.1, 5.0) = 1.0;

const int bayer2[4] = {
	0, 2,
	3, 1
};

const int bayer4[16] = {
	0, 8, 2, 10,
	12, 4, 14, 6,
	3, 11, 1, 9,
	15, 7, 13, 5
};

const int bayer8[64] = {
	0, 32,  8, 40,  2, 34, 10, 42,
	48, 16, 56, 24, 50, 18, 58, 26,
	12, 44,  4, 36, 14, 46,  6, 38,
	60, 28, 52, 20, 62, 30, 54, 22,
	3, 35, 11, 43,  1, 33,  9, 41,
	51, 19, 59, 27, 49, 17, 57, 25,
	15, 47,  7, 39, 13, 45,  5, 37,
	63, 31, 55, 23, 61, 29, 53, 21
};

float get_bayer2(vec2 coord) {
	int x = int(mod(coord.x, 2.0));
	int y = int(mod(coord.y, 2.0));
	int index = y * 2 + x;
	return (float(bayer2[index]) + 0.5) / 4.0;
}

float get_bayer4(vec2 coord) {
	int x = int(mod(coord.x, 4.0));
	int y = int(mod(coord.y, 4.0));
	int index = y * 4 + x;
	return (float(bayer4[index]) + 0.5) / 16.0;
}

float get_bayer8(vec2 coord) {
	int x = int(mod(coord.x, 8.0));
	int y = int(mod(coord.y, 8.0));
	int index = y * 8 + x;
	return (float(bayer8[index]) + 0.5) / 64.0;
}

float get_dither(vec2 uv, vec2 step_size, vec2 center) {
	vec2 bayer_coord = floor(uv / step_size + 1.0e-5);
	vec2 grid_uv = bayer_coord * step_size + step_size * 0.5;
	float dist = distance(grid_uv, center);
	float t = pow(clamp(dist / radius, 0.0, 1.0), falloff);
	float threshold;
	if (bayer_size == 0) {
		threshold = get_bayer2(bayer_coord);
	} else if (bayer_size == 1) {
		threshold = get_bayer4(bayer_coord);
	} else {
		threshold = get_bayer8(bayer_coord);
	}
	return step(threshold, 1.0 - t);
}

float get_mask(vec2 uv, vec2 step_size, vec2 offset, vec2 center) {
	float d1 = get_dither(uv, step_size, center);
	float d2 = get_dither(uv - offset, step_size, center);
	return max(d1, d2);
}

void fragment() {
	vec2 screen_uv = FRAGCOORD.xy / VIEWPORT_SIZE;
	float aspect = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;

	// Smooth wandering offset using layered sine waves
	float t = TIME * noise_speed;
	vec2 wander = vec2(
		sin(t * 0.7) + sin(t * 1.3) * 0.5 + sin(t * 2.1) * 0.55,
		cos(t * 0.9) + cos(t * 1.7) * 0.5 + cos(t * 2.3) * 0.55
	) / VIEWPORT_SIZE;

	// Center of the screen in screen-space UV with offset
	vec2 center = vec2((0.5 + center_offset.x) * aspect, 0.5 + center_offset.y) + vec2(wander.x * aspect, wander.y);
	// Current pixel in aspect-corrected screen-space with vertical stretch
	vec2 uv = vec2(screen_uv.x * aspect, (screen_uv.y - 0.5 - center_offset.y) / vertical_stretch + 0.5 + center_offset.y);

	float uv_step_f = pixel_size / resolution.x;
	vec2 uv_step = vec2(uv_step_f, uv_step_f);
	vec2 raw_offset_uv = round(dither_offset) * uv_step;
	vec2 effective_offset = interpolate ? raw_offset_uv * 0.5 : raw_offset_uv;
	vec2 centered_uv = uv + effective_offset * 0.5;

	float dither;
	if (interpolate) {
		vec2 sub_step = uv_step * 0.5;
		vec2 quantized_uv = floor(centered_uv / uv_step) * uv_step;

		vec2 q1 = vec2(uv_step.x * 0.25, uv_step.y * 0.25);
		vec2 q3 = vec2(uv_step.x * 0.75, uv_step.y * 0.75);

		float v1 = get_mask(quantized_uv + q1, sub_step, effective_offset, center);
		float v2 = get_mask(quantized_uv + vec2(q3.x, q1.y), sub_step, effective_offset, center);
		float v3 = get_mask(quantized_uv + vec2(q1.x, q3.y), sub_step, effective_offset, center);
		float v4 = get_mask(quantized_uv + q3, sub_step, effective_offset, center);

		dither = (v1 + v2 + v3 + v4) * 0.25;
	} else {
		vec2 quantized_uv = floor(centered_uv / uv_step) * uv_step;
		dither = get_mask(quantized_uv, uv_step, effective_offset, center);
	}

	float mask = invert ? (1.0 - dither) : dither;
	float alpha = mix(edge_alpha, center_alpha, mask);

	vec4 tex = texture(base_texture, UV);
	ALBEDO = tex.rgb;
	ALPHA = tex.a * alpha;
}
