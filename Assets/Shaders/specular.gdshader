shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.1, 0.4, 0.1, 1.0); // The "Gem" color
uniform float shine_factor : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    vec2 uv = UV;
    vec4 col = base_color;
    
    // 1. Create a vertical gradient for depth
    col.rgb *= mix(0.6, 1.2, 1.0 - uv.y);
    
    // 2. Add the "Jewel Arc" (The glossy top highlight)
    float gloss = smoothstep(0.5, 0.0, distance(uv, vec2(0.5, -0.2)));
    col.rgb += gloss * shine_factor;
    
    // 3. Add a thin rim light at the very top edge
    float edge = smoothstep(0.02, 0.0, uv.y);
    col.rgb += edge * 0.3;

    COLOR = col;
}