extends Object

func point_to_camera_limit_y(c: ModLoaderHookChain, point := 0, point_dir := -1) -> int:
	point -= 16 if point == 32 && Global.get_window().content_scale_size.y == 144 else 0
	return c.execute_next([point, point_dir])
