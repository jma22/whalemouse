shader_type spatial;

// Additive, always-lit, no depth writes, double-sided — the usual setup for a
// glowing projectile trail ribbon. Swap "blend_add" for "blend_mix" if you want
// a smoke-like trail instead of an energy/laser look.
render_mode blend_add, unshaded, cull_disabled, depth_draw_never, shadows_disabled;

// The gradient texture (head -> tail). Use the supplied trail_gradient.png.
uniform sampler2D trail_texture : source_color, filter_linear, repeat_enable;

// Tint at the head and at the tail. Alpha on each controls fade.
uniform vec4 color_head : source_color = vec4(1.0, 0.85, 0.35, 1.0);
uniform vec4 color_tail : source_color = vec4(1.0, 0.25, 0.05, 0.0);

// Glow strength fed into EMISSION (needs Glow enabled in WorldEnvironment to bloom).
uniform float emission_energy : hint_range(0.0, 16.0) = 3.0;

// Scrolls the texture along the trail for a flowing/shimmering feel. 0 = static.
uniform float scroll_speed = 1.5;

// Master opacity.
uniform float alpha_scale : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // On a RibbonTrailMesh / TubeTrailMesh or a GPUParticles3D trail, one UV axis
    // runs along the length. UV.x is correct for most; if your trail looks wrong,
    // swap the two .x references below to .y.
    float along = UV.x;

    // Sample the gradient, scrolling only the lookup (keeps the head->tail fade fixed).
    vec2 uv = vec2(along + TIME * scroll_speed, UV.y);
    vec4 tex = texture(trail_texture, uv);

    // Head-to-tail color/alpha gradient.
    vec4 grad = mix(color_head, color_tail, along);

    vec3 col = tex.rgb * grad.rgb;
    // COLOR.a lets a particle system or vertex color fade the whole trail over its life.
    float a = tex.a * grad.a * alpha_scale * COLOR.a;

    ALBEDO = col;
    EMISSION = col * emission_energy;
    ALPHA = a;
}
