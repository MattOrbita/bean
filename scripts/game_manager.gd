extends Node


var player
var enemies = []

var walls_and_towers : TileMapLayer
var tower_selector : CanvasLayer

var player_script : Script = preload("res://scripts/player.gd")
#var enemy_script : Script = preload("res://scripts/enemy.gd")
var enemy_script : Script = preload("res://scenes/enemy_placeholder.gd")

var walls_and_towers_script : Script = preload("res://scripts/towermap.gd")
var tower_selector_script : Script = preload("res://scripts/tower_selector.gd")


func _ready() -> void:
	var root_node = get_tree().root
	find_important_nodes(root_node)


func _process(delta: float) -> void:
	update_enemy_list()


# creates references to important nodes, like the player and the tower selector UI,
# so that we only search the entire scene tree once to gain all these references.
# Every other script can just turn to the game manager if they need to use any of these
# references.
func find_important_nodes(root_node : Node):
	var script = root_node.get_script()
	
	if script == enemy_script:
		enemies.append(root_node)
	
	elif script == player_script:
		player = root_node
	elif script == walls_and_towers_script:
		walls_and_towers = root_node
	elif script == tower_selector_script:
		tower_selector = root_node
	
	for child in root_node.get_children():
		find_important_nodes(child)


# removes all enemies that have been killed from the enemy list
func update_enemy_list():
	var index_to_remove
	var is_updated = false
	
	# loop runs until our enemy list has weeded out every dead enemy AKA null enemy
	while not is_updated:
		is_updated = true
		
		for i in range(len(enemies)):
			if enemies[i] == null:
				index_to_remove = i
				is_updated = false
				
				break
		
		if not is_updated:
			enemies.remove_at(index_to_remove)


# upon selecting a different tower in the UI, that action passes from the UI to the game manager,
# and then from the game manager to the walls and towers tile map
func update_selected_tower(selected_tower : PackedScene):
	walls_and_towers.BIGGER_WALL_SCENE = selected_tower
