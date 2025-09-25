extends TileMapLayer

class_name TLM

@onready var game_controller := get_node("/root/GameController")


func _input(event):
	if event.is_action_pressed("plant"):
		var mouse_pos := get_global_mouse_position()
		var click_pos := local_to_map(mouse_pos)
		var cell_data := get_cell_tile_data(click_pos)
		if cell_data == null:
			return

		var cell_type = cell_data.get("type")
		if cell_type != "road":
			game_controller.plant(mouse_pos)
