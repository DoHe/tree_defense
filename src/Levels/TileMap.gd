extends TileMap

onready var game_controller := get_node("/root/GameController")

func _input(event):
	if event.is_action_pressed("plant"):
		var mouse_pos : = get_global_mouse_position()
		var click_pos : = world_to_map(mouse_pos)
		var cell : = get_cell(click_pos.x, click_pos.y)
		if cell == -1:
			return
		var tile_name : = tile_set.tile_get_name(cell)
		if tile_name in ["dirt"]:
			game_controller.plant(mouse_pos)
