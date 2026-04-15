shader_type spatial;

uniform float charge_level : hint_range(0.0, 1.0) = 0.0;
uniform float flash_level : hint_range(0.0, 1.0) = 0.0;

uniform vec4 flash_color : source_color = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D texture_albedo : source_color;
uniform float mesh_bottom = -1.0;
uniform float mesh_top = 1.0;
varying float vert_y;

void vertex() {
	vert_y = VERTEX.y;
}

void fragment() {
	float gradient = smoothstep(mesh_bottom, mesh_top, vert_y);
	float mask = texture(texture_albedo, UV).a;
	float charge = charge_level * gradient;
	float combined = max(charge, flash_level)
	ALBEDO = flash_color.rgb;
	ALPHA = mask* combined;
}
