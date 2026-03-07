shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.1, 0.4, 0.1, 1.0);
uniform float shine_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = UV;
    vec4 col = base_color;

    // 1. Diagonal Gradient (Darker bottom-right, lighter top-left)
    float diag = (uv.x + uv.y) * 0.5;
    col.rgb *= mix(1.2, 0.6, diag);

    // 2. The "Top-Left" Specular Gleam
    // We move the center of the 'circle' of light to (0.3, 0.1)
    float highlight = smoothstep(0.4, 0.0, distance(uv, vec2(0.3, 0.1)));
    col.rgb += highlight * shine_intensity;

    // 3. Crisp Top-Left Edge Rim
    // This simulates the very sharp edge catching the light
    float rim = smoothstep(0.03, 0.0, uv.y) * smoothstep(0.5, 0.0, uv.x);
    col.rgb += rim * 0.4;

    COLOR = col;
}