extends Node


var player
var enemies = []

var player_script : Script = preload("res://scripts/player.gd")
#var enemy_script : Script = preload("res://scripts/enemy.gd")
var enemy_script : Script = preload("res://scenes/enemy_placeholder.gd")


func _ready() -> void:
	var root_node = get_tree().root
	find_important_nodes(root_node)


func _process(delta: float) -> void:
	update_enemy_list()


func find_important_nodes(root_node : Node):
	var script = root_node.get_script()
	
	if script == enemy_script:
		enemies.append(root_node)
	elif script == player_script:
		player = root_node
	
	for child in root_node.get_children():
		find_important_nodes(child)


func update_enemy_list():
	var index_to_remove
	var is_updated = false
	
	while not is_updated:
		is_updated = true
		
		for i in range(len(enemies)):
			if enemies[i] == null:
				index_to_remove = i
				is_updated = false
				
				break
		
		if not is_updated:
			enemies.remove_at(index_to_remove)
