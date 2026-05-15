shader_type canvas_item;

uniform float brightness_strength : hint_range(0.0, 1.0) = 0.15;
uniform float mid_sharpness : hint_range(0.1, 5.0) = 0.5;
uniform float sheen_intensity : hint_range(0.0, 1.0) = 0.2;
uniform float inner_stroke_thickness : hint_range(0.0, 0.1) = 0.02;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV) * COLOR;
    
    // 1. Existing Gradient Logic
    float rel_y = (UV.y - 0.5) * 2.0;
    float curve = sign(rel_y) * pow(abs(rel_y), mid_sharpness);
    vec3 color_mod = base_color.rgb - (curve * brightness_strength);
    
    // 2. The Diagonal Sheen (The "Glass" look)
    // This creates a diagonal band of light
    float sheen = smoothstep(0.4, 0.5, 1.0 - abs((UV.x + UV.y) - 0.7));
    color_mod += sheen * sheen_intensity;
    
    // 3. Inner Stroke (The "Bevel" look)
    // Brightens the very top-left edges and darkens bottom-right
    float top_edge = smoothstep(inner_stroke_thickness, 0.0, UV.y);
    float left_edge = smoothstep(inner_stroke_thickness, 0.0, UV.x);
    float bottom_edge = smoothstep(1.0 - inner_stroke_thickness, 1.0, UV.y);
    
    color_mod += (top_edge + left_edge) * 0.15; // Light highlight
    color_mod -= bottom_edge * 0.15;            // Dark shadow
    
    COLOR = vec4(color_mod, base_color.a);
}