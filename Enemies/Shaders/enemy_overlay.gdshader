shader_type spatial;
render_mode blend_add;

uniform float charge_level : hint_range(0.0, 1.0) = 0.0;
uniform float flash_level : hint_range(0.0, 1.0) = 0.0;

uniform vec4 flash_color : source_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 charge_color : source_color = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D texture_albedo : source_color;
uniform float mesh_bottom = -1.0;
uniform float mesh_top = 1.0;
varying float vert_y;

void vertex() {
	vert_y = VERTEX.y;
}

void fragment() {
	float gradient = 1.0 - smoothstep(mesh_bottom, mesh_top*1.5, vert_y);
	float mask = texture(texture_albedo, UV).a;
	float charge = charge_level * gradient;
	float combined = max(charge, flash_level);
	vec3 color = mix(charge_color.rgb, flash_color.rgb, step(charge, flash_level));
	ALBEDO = color;
	ALPHA = mask* combined;
}
