shader_type canvas_item;

uniform sampler2D dissolve_texture : source_color;
uniform float dissolve_value : hint_range(0.0, 1.0);
uniform vec2 sprite_pixel_size;
uniform vec2 dissolve_tex_size;

void fragment() {
    vec4 main_texture = texture(TEXTURE, UV);
    // Calculate pixel position inside the sprite
    vec2 pixel_pos_in_sprite = UV * sprite_pixel_size;
    // Snap to pixel grid by flooring pixel position
    vec2 snapped_pixel_pos = floor(pixel_pos_in_sprite);
    // Convert snapped pixel position to UV in dissolve texture space
    vec2 noise_uv = snapped_pixel_pos / dissolve_tex_size;
    // Sample dissolve noise texture at snapped UV
    vec4 noise_texture = texture(dissolve_texture, noise_uv);
    // Apply dissolve alpha mask
    main_texture.a *= step(noise_texture.r, dissolve_value);
    COLOR = main_texture;
}

void vertex() {

	if (VERTEX.y == 0.0){
		VERTEX += vec2(sin(TIME) * 2.5, 0);
	}

	if (VERTEX.y > 0.0){
		VERTEX += -vec2(sin(TIME) * 2.5, 0);
	}
}