shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, unshaded;

uniform sampler2D albedo_texture : source_color, filter_nearest;

uniform vec4 fog_color : source_color = vec4(0.02, 0.0, 0.08, 1.0);

// World Y of the floor plane. Anything below this is fully fogged.
uniform float ground_y = 0.0;

// How far up (in world units) the fog reaches
uniform float fog_height : hint_range(0.0, 10.0) = 1.5;

uniform float fog_strength : hint_range(0.0, 1.0) = 0.9;
uniform float fog_falloff : hint_range(0.5, 4.0) = 1.8;

// Smaller = bigger noise blobs. Tune to your world scale.
uniform float noise_scale : hint_range(0.01, 5.0) = 0.6;

// How far the noise warps the fog edge (in world units)
uniform float noise_strength : hint_range(0.0, 5.0) = 0.7;

uniform vec2 noise_drift = vec2(0.1, -0.05);

varying vec3 world_pos;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float value_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        v += amp * value_noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return v;
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);

    // In 3D, +Y is up
    float height_above = world_pos.y - ground_y;

    // Sample noise on world XY — varies both along sprite height AND across sprites
    vec2 nuv = world_pos.xy * noise_scale + noise_drift * TIME;
    float n = fbm(nuv) - 0.5;

    float warped_height = height_above + n * noise_strength;

    float fog_amount = 1.0 - smoothstep(0.0, fog_height, warped_height);
    fog_amount = pow(fog_amount, fog_falloff);

    ALBEDO = mix(tex_color.rgb, fog_color.rgb, fog_amount * fog_strength);
    ALPHA = tex_color.a;
}