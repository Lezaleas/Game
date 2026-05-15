shader_type canvas_item;

// Controls how much the color shifts (0.1 is subtle, 0.5 is strong)
uniform float brightness_strength : hint_range(0.0, 1.0) = 0.1;
// Lower values (0.1 - 0.5) make the middle transition "sharper"
uniform float mid_sharpness : hint_range(0.1, 5.0) = 0.5;

void fragment() {
    // 1. Get the base color (works for ColorRects and Sprites)
    vec4 base_color = texture(TEXTURE, UV) * COLOR;
    
    // 2. Map UV.y (0 to 1) to a range of -1.0 (top) to 1.0 (bottom)
    float rel_y = (UV.y - 0.5) * 2.0;
    
    // 3. Create the "Sharp Cut" curve
    // pow() with a value < 1.0 makes the slope steep at the center
    float curve = sign(rel_y) * pow(abs(rel_y), mid_sharpness);
    
    // 4. Apply the shift
    // We SUBTRACT the curve because rel_y is negative at the top.
    // Subtracting a negative adds brightness to the top.
    vec3 final_rgb = base_color.rgb - (curve * brightness_strength);
    
    // 5. Output with original alpha transparency
    COLOR = vec4(final_rgb, base_color.a);
}