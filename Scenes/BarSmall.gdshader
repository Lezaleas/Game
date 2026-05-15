shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.0, 0.45, 1.0, 1.0);
uniform float band_strength = 0.25;
uniform float band_size = 0.25;

void fragment() {
	vec4 col = base_color;

	// Distance from vertical center
	float dist = abs(UV.y - 0.5);

	// Horizontal light band
	float band = smoothstep(
		band_size,
		0.0,
		dist
	);

	col.rgb += band * band_strength;

	COLOR = col;
}