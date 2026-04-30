shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Radius where the effect starts (closer to center = bigger dark area)
uniform float inner_radius : hint_range(0.0, 1.5) = 0.4;
// Radius where it reaches full strength
uniform float outer_radius : hint_range(0.0, 1.5) = 0.9;
// Curve shape: 1.0 = linear, higher = sharper falloff at the end
uniform float falloff : hint_range(0.1, 8.0) = 2.0;
// Overall strength of the effect
uniform float strength : hint_range(0.0, 1.0) = 1.0;

// Use UV space (0–1 across the mesh) — most common
// If false, you could swap in a world-space version
uniform vec2 center = vec2(0.5, 0.5);

// Stretch: useful for non-square meshes so the vignette stays circular
uniform vec2 aspect = vec2(1.0, 1.0);

void fragment() {
    vec2 uv = UV;
    
    // Distance from center, with optional aspect correction
    vec2 delta = (uv - center) * aspect;
    float dist = length(delta);
    
    // Map distance through inner/outer radii into 0..1, then shape
    float t = smoothstep(inner_radius, outer_radius, dist);
    t = pow(t, falloff);
    t *= strength;
    
    ALBEDO = vignette_color.rgb;
    ALPHA = vignette_color.a * t;
}