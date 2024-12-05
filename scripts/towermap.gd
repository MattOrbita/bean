extends TileMapLayer

var new_tile_id = Vector2i(6, 11)
const WALL_SCENE = preload("res://scenes/wall.tscn")
#const BIGGER_WALL_SCENE = preload("res://scenes/tower_placeholder.tscn")
var BIGGER_WALL_SCENE = preload("res://scenes/towers/feeding_tower.tscn")
var existing_walls = {} #kind of a crazy method here. I'll use dictionaries to keep track of placed tiles
var existing_towers = {}
var resources:int = 0
const wall_cost:int = 10
const big_wall_cost:int = 100
signal resources_changed(resources)
@export var navlayer: Node2D

var place_proximity = 220
var game_manager

var shooter_tower : PackedScene = preload("res://scenes/towers/air_control_tower.tscn")
var food_tower : PackedScene = preload("res://scenes/towers/feeding_tower.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	get_game_manager()


func get_game_manager():
	var level_node = $"/root".get_child(0)
	game_manager = level_node.get_node("Game Manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(get_global_mouse_position())
	var mouse_pos = Vector2i(to_local(get_global_mouse_position()))
	#print(mouse_pos)
	var tile_pos = local_to_map(mouse_pos)
	var clicked_tile = get_cell_atlas_coords(tile_pos)
	
	listen_for_place_input(tile_pos, clicked_tile)
	
	for wall in existing_walls:
		if existing_walls[wall] == null or (str(existing_walls[wall]) == "<Freed Object>"):
			existing_walls.erase(wall)
			delete_wall(get_cell_atlas_coords(wall), wall)
	
	for tower in existing_towers:
		if existing_towers[tower] == null or (str(existing_towers[tower]) == "<Freed Object>"):
			existing_towers.erase(tower)
			delete_big_wall(tower)
	#pass


func listen_for_place_input(tile_pos, clicked_tile):
	var player_to_mouse = get_global_mouse_position() - game_manager.player.global_position
	var place_distance = player_to_mouse.length()
	
	# only allow player to place within place_proximity units of themself
	if place_distance > place_proximity:
		return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if Input.is_action_pressed("ui_accept"):
			place_walls_grid(tile_pos, 2)
		elif Input.is_action_pressed("q"):
			place_big_wall(tile_pos)
		else:
			place_wall(clicked_tile, tile_pos)
		
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if Input.is_action_pressed("ui_accept"):
			delete_walls_grid(tile_pos, 3)
		elif Input.is_action_pressed("q"):
			delete_big_wall(tile_pos)
		else:
			delete_wall(clicked_tile, tile_pos)


func place_wall(clicked_tile, tile_pos):
	if clicked_tile != new_tile_id and resources >= wall_cost:  # Ensure a tile was actually clicked
		set_resources(resources - wall_cost)
		set_cell(tile_pos, 0, new_tile_id, 0)
		navlayer.removeNav(tile_pos) #sends a signal to the nav layer to remove navagation to that tile
		#print("clicked!")
		#print(tile_pos)
		var wall := WALL_SCENE.instantiate() as Wall
		wall.position.x = to_global(map_to_local(tile_pos)).x
		wall.position.y = to_global(map_to_local(tile_pos)).y
		wall.set_as_top_level(true)
		add_child(wall)
		existing_walls[tile_pos] = wall


func delete_wall(clicked_tile, tile_pos):
	if clicked_tile == new_tile_id:  # Ensure a tile was actually clicked
		set_cell(tile_pos, -1, new_tile_id, -1)
		navlayer.addNav(tile_pos) #sends a signal to the nav layer to add navagation back to that tile
		#print("clicked!")
		#print(tile_pos)
		if tile_pos in existing_walls:
			var wall = existing_walls[tile_pos]
			if wall is Wall:  # Check if the node is a Wall instance
				set_resources(resources + (wall_cost * wall.remaining_hp_proportion()))
				#refill the resources by amt spent proportional to remaining hp
				wall.destroyed()
				existing_walls.erase(tile_pos)


func place_walls_grid(tile_pos, n):
	for x in range(n):
		for y in range(n):
			var cell_pos = Vector2i(tile_pos.x + x, tile_pos.y + y)
			place_wall(get_cell_atlas_coords(cell_pos), cell_pos)


func delete_walls_grid(tile_pos, n):
	for x in range(n):
		for y in range(n):
			var cell_pos = Vector2i(tile_pos.x + x, tile_pos.y + y)
			delete_wall(get_cell_atlas_coords(cell_pos), cell_pos)


func place_big_wall(tile_pos):
	print("placing big wall!")
	var is_valid_placement = true
	for x in range(2):
		for y in range(2):
			var cell_pos = Vector2i(tile_pos.x + x, tile_pos.y + y)
			if get_cell_atlas_coords(cell_pos) == new_tile_id:
				is_valid_placement = false
				break

	if is_valid_placement and resources >= big_wall_cost:
		set_resources(resources - big_wall_cost)
		for x in range(2):
			for y in range(2):
				var cell_pos = Vector2i(tile_pos.x + x, tile_pos.y + y)
				set_cell(cell_pos, 0, new_tile_id, 0)
		var bwall := BIGGER_WALL_SCENE.instantiate() as BiggerWall
		bwall.position.x = to_global(map_to_local(tile_pos)).x + 24
		bwall.position.y = to_global(map_to_local(tile_pos)).y + 24
		bwall.set_as_top_level(true)
		add_child(bwall)
		existing_towers[tile_pos] = bwall


func delete_big_wall(tile_pos):
	# Iterate over all possible positions of the 2x2 wall
	for x in range(2):
		for y in range(2):
			var cell_pos = Vector2i(tile_pos.x - x, tile_pos.y - y)
			if cell_pos in existing_towers:
				var bwall = existing_towers[cell_pos]
				if bwall is BiggerWall:
					set_resources(resources + int(big_wall_cost * bwall.remaining_hp_proportion()))
					# Remove the BiggerWall instance
					bwall.destroyed()
					# Remove the wall tiles from the tilemap
					for i in range(2):
						for j in range(2):
							var pos = Vector2i(cell_pos.x + i, cell_pos.y + j)
							set_cell(pos, -1, new_tile_id, -1)
					# Remove the entry from the dictionary
					existing_towers.erase(cell_pos)


func set_resources(amount):
	resources = amount
	resources_changed.emit(resources)
	
func resources_left():
	return resources

func update_selected_tower(button : Button):
	pass
