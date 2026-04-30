shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform sampler2D color_ramp : source_color, filter_linear, repeat_disable;

uniform float scale : hint_range(1.0, 50.0) = 12.0;
uniform float warp_strength : hint_range(0.0, 1.0) = 0.35;
uniform float warp_scale : hint_range(0.5, 10.0) = 2.5;
uniform float anim_speed : hint_range(0.0, 2.0) = 0.15;

// Remap pattern before sampling the gradient
uniform float contrast : hint_range(0.1, 5.0) = 1.5;
uniform float brightness : hint_range(-0.5, 0.5) = 0.0;

uniform float opacity : hint_range(0.0, 1.0) = 0.7;

vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)),
             dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453) * 2.0 - 1.0;
}

float value_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = dot(hash2(i), vec2(0.5)) + 0.5;
    float b = dot(hash2(i + vec2(1.0, 0.0)), vec2(0.5)) + 0.5;
    float c = dot(hash2(i + vec2(0.0, 1.0)), vec2(0.5)) + 0.5;
    float d = dot(hash2(i + vec2(1.0, 1.0)), vec2(0.5)) + 0.5;
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float voronoi_blob(vec2 uv) {
    vec2 cell = floor(uv);
    vec2 frac = fract(uv);
    float d1 = 8.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = hash2(cell + neighbor);
            point = 0.5 + 0.5 * sin(TIME * anim_speed + 6.2831 * point);
            vec2 diff = neighbor + point - frac;
            float dist = length(diff);
            d1 = min(d1, dist);
        }
    }
    return d1;
}

void fragment() {
    vec2 uv = UV * scale;
    
    // Domain warp
    vec2 warp = vec2(
        value_noise(uv * warp_scale + TIME * 0.04),
        value_noise(uv * warp_scale + TIME * 0.04 + vec2(5.2, 1.3))
    ) - 0.5;
    uv += warp * warp_strength;
    
    // Distance to nearest cell — low at centers, high between cells
    float pattern = voronoi_blob(uv);
    
    // Contrast / brightness
    pattern = (pattern - 0.5) * contrast + 0.5 + brightness;
    pattern = clamp(pattern, 0.0, 1.0);
    
    vec4 ramp = texture(color_ramp, vec2(pattern, 0.5));
    
    ALBEDO = ramp.rgb;
    ALPHA = ramp.a * opacity;
}