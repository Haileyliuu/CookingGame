shader_type canvas_item;

uniform float highlight_strength : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    // Mix the base color with white, controlled by highlight_strength
    COLOR = mix(base, vec4(1.0), highlight_strength) * base.a;
}
