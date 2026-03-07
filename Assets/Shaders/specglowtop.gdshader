shader_type canvas_item;

// The deep "casing" or shadow color (e.g., Deep Forest Green)
uniform vec4 base_color : source_color = vec4(0.0, 0.4, 0.1, 1.0); 
// The vibrant, glowing center color (e.g., Neon Lime Green)
uniform vec4 glow_color : source_color = vec4(0.2, 1.0, 0.4, 1.0); 

uniform float shine_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.45;

void fragment() {
    vec2 uv = UV;
    
    // 1. Base Vertical Gradient (Symmetrical on X-axis)
    // Darkens significantly toward the bottom to emphasize height.
    float depth_gradient = smoothstep(0.0, 1.0, uv.y);
    vec3 col = mix(base_color.rgb * 1.6, base_color.rgb * 0.3, depth_gradient);
    
    // 2. Centered "Inner Glow"
    // This creates the translucent gemstone look, centered on (0.5, 0.5)
    float inner_glow = 1.0 - distance(uv, vec2(0.5, 0.5)); 
    inner_glow = pow(inner_glow, 4.0); // Sharpen the glow center
    col = mix(col, glow_color.rgb, inner_glow * glow_intensity);
    
    // 3. Main Specular "Reflection" (Centered from top)
    // We create a wider, slightly lower specular arc.
    float specular_center = 1.0 - distance(uv, vec2(0.5, 0.25));
    float spec = smoothstep(0.7, 0.0, 1.0 - specular_center);
    col += vec3(1.0) * spec * shine_intensity;
    
    // 4. Centered Top Rim Light
    // A crisp, narrow highlight at the absolute top center (0.5, 0.0)
    // This mimics a bright light source directly overhead.
    float rim_y = smoothstep(0.06, 0.0, uv.y);
    float rim_x = smoothstep(0.4, 0.1, abs(uv.x - 0.5)); // Symmetrical centered mask
    col += vec3(1.0) * rim_y * rim_x * 0.7;

    COLOR = vec4(col, base_color.a);
}