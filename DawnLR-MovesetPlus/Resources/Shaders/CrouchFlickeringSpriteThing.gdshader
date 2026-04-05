shader_type canvas_item;

uniform int mode = 0;
uniform float speed = 50;
uniform bool enabled = false;
uniform float palette_size = 3;
uniform sampler2D player_palette: filter_nearest;
uniform int palette_idx = 0;
uniform sampler2D invincible_palette: filter_nearest;
uniform float dist_1 = 0.0;
uniform bool charged_jump = false;

vec4 mode_0(vec4 colour)
{
	float amount = abs(sin(TIME * speed));
	vec4 inv = abs(colour - vec4(1.0, 1.0, 1.0, 0.0));
	vec4 rainbow = vec4(abs(sin(TIME * 5.0)), abs(cos(TIME * 3.0)), abs(sin((TIME))), colour.a);
	inv = vec4(mix(inv, rainbow, 0.5));
	colour = vec4(mix(colour, inv, amount));
	return colour;
}

vec4 mode_1(vec4 colour)
{
    // Determine invincible palette row (1–3)
    int invincible_palette_idx = int(TIME * speed) % 3;

    vec4 closest = colour;
    float closest_distance = 99999.9;

    int palette_count = int(palette_size); // number of colors

    for (int i = 0; i < palette_count; i++)
	{
	    float x_coord = (float(i) + 0.5) / palette_size;
	    float y_coord = (float(palette_idx) + 0.5) / float(3);

	    vec4 sampled = texture(player_palette, vec2(x_coord, y_coord));

	    float d = distance(sampled, colour);
	    if (d < 0.01 && d <= closest_distance)
	    {
	        float inv_x_coord = (float(i) + 0.5) / palette_size;
	        float inv_y_coord = (float(invincible_palette_idx) + 0.5) / float(3);

	        closest = texture(invincible_palette, vec2(inv_x_coord, inv_y_coord));
	        closest_distance = d;
	    }
	}
    return closest;
}

vec4 squat(vec4 colour) {
	int invert = int(TIME * speed) % 2;
	
	vec4 closest = colour;
    float closest_distance = 99999.9;

    int palette_count = int(palette_size); // number of colors
	
	if (invert == 1) {
		for (int i = 0; i < palette_count; i++)
		{
			float x_coord = (float(i) + 0.5) / palette_size;
		    float y_coord = (float(palette_idx) + 0.5) / float(3);

		    vec4 sampled = texture(player_palette, vec2(x_coord, y_coord));

		    float d = distance(sampled, colour);
		    if (d < 0.01 && d <= closest_distance)
		    {
		        float inv_x_coord = (float(i) + 0.5) / palette_size;
		        float inv_y_coord = (float(2) + 0.5) / float(3);

		        closest = texture(invincible_palette, vec2(inv_x_coord, inv_y_coord));
		        closest_distance = d;
		    }
		}
	}
	return closest;
}

void fragment() {
	if (enabled)
	{
		if (mode == 0)
		{
			COLOR = mode_0(COLOR);
		} else if (mode == 1)
		{
			COLOR = mode_1(COLOR);
		} 
	}
	if (charged_jump)
	{
		COLOR = squat(COLOR);
	}
}
