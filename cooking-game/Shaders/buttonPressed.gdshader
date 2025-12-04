shader_type canvas_item;

uniform float brightness_mult : hint_range(0.0, 2.0) = .7;
uniform float hue_shift_deg : hint_range(-180.0, 180.0) = 0;
uniform float saturation_mult : hint_range(0.0, 2.0) = 1.4;
//uniform vec2 press_offset = vec2(0.0, -50);

vec3 shift_hue(vec3 color, float degrees) {
    float angle = radians(degrees);
    float cosA = cos(angle);
    float sinA = sin(angle);
    
    // Matrices must be defined as 3 vec3 columns
    mat3 rgb_to_yiq = mat3(
        vec3(0.299, 0.587, 0.114),
        vec3(0.596, -0.275, -0.321),
        vec3(0.212, -0.523, 0.311)
    );

    mat3 yiq_to_rgb = mat3(
        vec3(1.0, 0.956, 0.621),
        vec3(1.0, -0.272, -0.647),
        vec3(1.0, -1.105, 1.702)
    );

    vec3 yiq = rgb_to_yiq * color;
    float old_i = yiq.y;
    float old_q = yiq.z;
    yiq.y = old_i * cosA - old_q * sinA;
    yiq.z = old_i * sinA + old_q * cosA;
    return clamp(yiq_to_rgb * yiq, 0.0, 1.0);
}

vec3 adjust_saturation(vec3 color, float sat_mult) {
    float gray = dot(color, vec3(0.299, 0.587, 0.114));
    return mix(vec3(gray), color, sat_mult);
}

void fragment() {
	//vec2 shifted_uv = UV + press_offset * TEXTURE_PIXEL_SIZE;
    vec4 tex_color = texture(TEXTURE, UV); // was (TEXTURE, shifted_uv) for offset

    vec3 color = shift_hue(tex_color.rgb, hue_shift_deg);
    color = adjust_saturation(color, saturation_mult);
    color *= brightness_mult;
 
    COLOR = vec4(color, tex_color.a);
}
