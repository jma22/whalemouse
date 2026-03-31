shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform float radius : hint_range(0.0, 1.0) = 0.4;
uniform float softness : hint_range(0.0, 0.5) = 0.2;
uniform float center_alpha : hint_range(0.0, 1.0) = 1.0;
uniform float edge_alpha : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap;

void fragment() {
    vec4 tex = texture(texture_albedo, UV);

    // FRAGCOORD is pixel position — normalize it to 0..1
    vec2 screen_uv = FRAGCOORD.xy / VIEWPORT_SIZE;

    vec2 uv = screen_uv - vec2(0.5);
    float aspect = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
    uv.x *= aspect;

    float dist = length(uv);
    float t = smoothstep(radius - softness, radius + softness, dist);
    float alpha = mix(center_alpha, edge_alpha, t);

    ALBEDO = tex.rgb;
    ALPHA = tex.a * alpha;
}