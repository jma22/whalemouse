shader_type spatial;
render_mode blend_mix, cull_disabled, unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform float width : hint_range(0.0, 16.0) = 1.0;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 size = vec2(width) / vec2(textureSize(texture_albedo, 0));

	vec4 sprite_color = texture(texture_albedo, UV);

	float alpha = sprite_color.a;
	alpha += texture(texture_albedo, UV + vec2(0.0, -size.y)).a;
	alpha += texture(texture_albedo, UV + vec2(size.x, -size.y)).a;
	alpha += texture(texture_albedo, UV + vec2(size.x, 0.0)).a;
	alpha += texture(texture_albedo, UV + vec2(size.x, size.y)).a;
	alpha += texture(texture_albedo, UV + vec2(0.0, size.y)).a;
	alpha += texture(texture_albedo, UV + vec2(-size.x, size.y)).a;
	alpha += texture(texture_albedo, UV + vec2(-size.x, 0.0)).a;
	alpha += texture(texture_albedo, UV + vec2(-size.x, -size.y)).a;

	vec3 final_color = mix(outline_color.rgb, sprite_color.rgb, sprite_color.a);
	ALBEDO = final_color;
	ALPHA = clamp(alpha, 0.0, 1.0);
}
