shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.0, 0.4, 0.1, 1.0); // Deep Forest Green
uniform vec4 glow_color : source_color = vec4(0.2, 1.0, 0.4, 1.0); // Neon/Bright Green
uniform float shine_intensity : hint_range(0.0, 1.0) = 0.6;
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    vec2 uv = UV;
    
    // 1. Base Gradient for Depth
    // Darkens the bottom right to make the "back" of the gem look thick.
    float depth = smoothstep(0.0, 1.0, (uv.x + uv.y) * 0.5);
    vec3 col = mix(base_color.rgb * 1.2, base_color.rgb * 0.8, depth);
    
    // 2. The Internal "Inner Glow"
    // This makes the center of the button look like it's lit from within.
    float inner_glow = 1.0 - distance(uv, vec2(0.4, 0.4)); // Offset slightly to top-left
    inner_glow = pow(inner_glow, 3.0); // Sharpen the glow
    col = mix(col, glow_color.rgb, inner_glow * glow_intensity);
    
    // 3. The Top-Left Specular "Reflection"
    // The sharp white/light hit on the surface.
    float specular = smoothstep(0.35, 0.0, distance(uv, vec2(0.25, 0.2)));
    col += vec3(1.0) * specular * shine_intensity;
    
    // 4. Top-Left Rim Light
    // A very thin, crisp highlight on the upper edge.
    float rim = smoothstep(0.04, 0.0, uv.y) * smoothstep(0.6, 0.0, uv.x);
    col += vec3(1.0) * rim * 0.25;

    COLOR = vec4(col, base_color.a);
}