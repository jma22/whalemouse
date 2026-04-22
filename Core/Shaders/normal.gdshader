shader_type spatial;

// === Sprite3D Base Shader ===
// Renders the sprite texture normally.
// Apply as ShaderMaterial on your Sprite3D. render_priority = 0 (default).

render_mode blend_mix, depth_draw_opaque, cull_disabled, unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec4 tex = texture(texture_albedo, UV);
    ALBEDO = tex.rgb;
    ALPHA = tex.a;
    ALPHA_SCISSOR_THRESHOLD = alpha_cutoff;
}
