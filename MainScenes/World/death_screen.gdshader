shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled, depth_test_disabled, depth_draw_never;

// Animate from ~0.8 down to 0.0 to close the spotlight
uniform float radius : hint_range(0.0, 2.0) = 0.5;
uniform float softness : hint_range(0.0, 1.0) = 0.15;
uniform float darkness : hint_range(0.0, 1.0) = 1.0;
uniform vec3 overlay_color : source_color = vec3(0.0, 0.0, 0.0);

global uniform vec2 foreground_player_uv;

void vertex() {
	// Force the quad to fill the screen regardless of its transform,
	// drawn at the near plane so it always renders in front.
	POSITION = vec4(VERTEX.xy * 2.0, 0.0, 1.0);
}

void fragment() {
	vec2 screen_uv = FRAGCOORD.xy / VIEWPORT_SIZE;
	float aspect = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;

	// Aspect-correct so the spotlight stays circular
	vec2 uv     = vec2(screen_uv.x * aspect, screen_uv.y);
	vec2 center = vec2(foreground_player_uv.x * aspect, foreground_player_uv.y);

	float dist = distance(uv, center);

	// 0 inside the hole -> 1 in the dark region, soft edge
	float mask = smoothstep(radius - softness, radius + softness, dist);

	ALBEDO = overlay_color;
	ALPHA  = darkness * mask;
}