extends CanvasLayer

var pixel_size := 1
func pixelate_screen() -> void:
	%PixelateEffect.show()
	while pixel_size < 32 && !started_unpixelate:
		pixel_size += 1
		print(str(pixel_size))
		%PixelateEffect.set_instance_shader_parameter("pixel_size", pixel_size)
		await get_tree().process_frame

var started_unpixelate := false
func unpixelate_screen() -> void:
	started_unpixelate = true
	while pixel_size > 1:
		pixel_size -= 1
		print(str(pixel_size))
		%PixelateEffect.set_instance_shader_parameter("pixel_size", pixel_size)
		await get_tree().process_frame
	%PixelateEffect.hide()
	started_unpixelate = false
