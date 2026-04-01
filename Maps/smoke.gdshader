shader_type spatial;
render_mode unshaded;

uniform float wave_frequency : hint_range(1.0, 50.0) = 10.0;
uniform float wave_amplitude : hint_range(0.0, 0.5) = 0.1;
uniform float scroll_speed : hint_range(0.0, 10.0) = 2.0;
uniform float blur_radius : hint_range(0.001, 0.5) = 0.05;
uniform vec3 color : source_color = vec3(0.0);
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float bottom_darken : hint_range(0.0, 1.0) = 0.5;

float gaussian(float x, float sigma) {
	return exp(-0.5 * (x * x) / (sigma * sigma));
}

void fragment() {
	float sigma = blur_radius / 3.0;
	int samples = 128;
	float step_size = blur_radius * 2.0 / float(samples);

	float total_weight = 0.0;
	float blurred_mask = 0.0;

	for (int i = 0; i < 16; i++) {
		float offset = -blur_radius + (float(i) + 0.5) * step_size;
		float sample_y = UV.y + offset;
		float wave = sin((UV.x + TIME * scroll_speed) * wave_frequency * TAU) * wave_amplitude;
		float edge = 0.5 + wave;
		float mask = step(edge, sample_y);
		float weight = gaussian(offset, sigma);
		blurred_mask += mask * weight;
		total_weight += weight;
	}

	blurred_mask /= total_weight;

	float darken = mix(1.0, bottom_darken, UV.y);
	ALBEDO = color * darken;
	float alpha_fade = mix(alpha, 1.0, UV.y);
	ALPHA = blurred_mask * alpha_fade;
}
