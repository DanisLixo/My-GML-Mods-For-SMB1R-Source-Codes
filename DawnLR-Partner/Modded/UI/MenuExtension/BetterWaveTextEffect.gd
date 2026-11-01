@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextBetterWave
extends RichTextEffect


# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [better_wave param=2.0]hello[/better_wave] in text.
var bbcode := "better_wave"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# Get custom parameters from BBCode, e.g., [better_wave freq=5.0 amp=4.0][/better_wave]
	var freq = char_fx.env["freq"]
	var amp = char_fx.env["amp"]
	var time = char_fx.elapsed_time
	
	# Calculate vertical offset using a sine wave based on character index and time
	var y_offset = sin(time * freq + char_fx.relative_index * 0.5) * amp
	char_fx.offset.y = y_offset
	
	return true
