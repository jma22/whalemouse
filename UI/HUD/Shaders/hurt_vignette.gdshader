shader_type canvas_item;

// --- Hurt + Status Vignette Shader ---
// Two independent layers with their own shape / opacity settings.

// ---- Flash layer ----
uniform vec4  flash_color     : source_color = vec4(0.8, 0.0, 0.0, 1.0);
uniform float flash_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float flash_radius    : hint_range(0.0, 1.0) = 0.4;
uniform float flash_softness  : hint_range(0.01, 1.0) = 0.3;
uniform float flash_max_alpha : hint_range(0.0, 1.0) = 0.7;

// ---- Status layer ----
uniform vec4  status_color     : source_color = vec4(0.1, 0.3, 1.0, 1.0);
uniform float status_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float status_radius    : hint_range(0.0, 1.0) = 0.5;
uniform float status_softness  : hint_range(0.01, 1.0) = 0.4;
uniform float status_max_alpha : hint_range(0.0, 1.0) = 0.45;
uniform float pulse_speed      : hint_range(0.0, 8.0) = 2.5;
uniform float pulse_min        : hint_range(0.0, 1.0) = 0.3;
uniform float pulse_max        : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 uv = UV - 0.5;
    float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    uv.x *= aspect;
    float dist = length(uv);

    // --- Status: breathing pulse with its own vignette ring ---
    float status_vig = smoothstep(status_radius, status_radius + status_softness, dist);
    float pulse      = mix(pulse_min, pulse_max, 0.5 + 0.5 * sin(TIME * pulse_speed));
    float status_a   = status_vig * status_max_alpha * status_intensity * pulse;
    vec4  status     = vec4(status_color.rgb, status_a);

    // --- Flash: one-shot with its own vignette ring ---
    float flash_vig = smoothstep(flash_radius, flash_radius + flash_softness, dist);
    float flash_a   = flash_vig * flash_max_alpha * flash_intensity;
    vec4  flash     = vec4(flash_color.rgb, flash_a);

    // --- Alpha-over composite (flash on top of status) ---
    float out_a   = flash.a + status.a * (1.0 - flash.a);
    vec3  out_rgb = out_a > 0.0
        ? (flash.rgb * flash.a + status.rgb * status.a * (1.0 - flash.a)) / out_a
        : vec3(0.0);

    COLOR = vec4(out_rgb, out_a);
}
