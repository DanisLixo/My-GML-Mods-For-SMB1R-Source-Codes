shader_type canvas_item;

instance uniform int pixel_size : hint_range(1, 64) = 1; // Pixel size
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;

void fragment() { 
	vec2 size = vec2(textureSize(SCREEN_TEXTURE, 0)) / float(pixel_size);
	vec2 uv = floor(SCREEN_UV * size) / size;
	COLOR = texture(SCREEN_TEXTURE, uv);
}
