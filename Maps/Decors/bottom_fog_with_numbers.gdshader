shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, blend_mix;

uniform sampler2D albedo : source_color, filter_nearest;
uniform float threshold_y = 0.0;
uniform float blend_width : hint_range(0.0, 2.0) = 0.2;
uniform vec4 tint : source_color = vec4(0.2, 0.4, 0.9, 1.0);
uniform float noise_amount : hint_range(0.0, 1.0) = 0.05;
uniform float noise_scale = 8.0;

varying vec3 world_pos;

// Cheap 2D hash noise
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float value_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f); // smoothstep
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec4 tex = texture(albedo, UV);

    // Sample noise on the XZ plane so the border wobbles horizontally
    float n = value_noise(world_pos.xz * noise_scale) - 0.5;
    float perturbed_y = world_pos.y + n * noise_amount;

    // Smooth transition across the (perturbed) threshold
    float t = smoothstep(threshold_y - blend_width, threshold_y + blend_width, perturbed_y);

    vec3 color = mix(tint.rgb, tex.rgb, t);

    ALBEDO = color;
    ALPHA = tex.a;
}