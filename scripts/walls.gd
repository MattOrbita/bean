extends TileMapLayer

var new_tile_id = Vector2i(17, 11)
const WALL_SCENE = preload("res://scenes/wall.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(get_global_mouse_position())
	var mouse_pos = Vector2i(to_local(get_global_mouse_position()))
	print(mouse_pos)
	var tile_pos = local_to_map(mouse_pos)
	var clicked_tile = get_cell_atlas_coords(tile_pos)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		place_wall(clicked_tile, tile_pos)
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if clicked_tile == new_tile_id:  # Ensure a tile was actually clicked
			set_cell(tile_pos, -1, new_tile_id, -1)
			print("clicked!")
			print(tile_pos)
	#pass
	
	 # Change this to the ID of the new tile type you want to set

func place_wall(clicked_tile, tile_pos):
	if clicked_tile != new_tile_id:  # Ensure a tile was actually clicked
			set_cell(tile_pos, 0, new_tile_id, 0)
			print("clicked!")
			print(tile_pos)
