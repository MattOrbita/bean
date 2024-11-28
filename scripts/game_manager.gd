extends Node


var enemies = []
var enemy_script : Script = preload("res://scripts/enemy.gd")


func _ready() -> void:
	var root_node = get_tree().root
	enemies = find_nodes_with_script(root_node, enemy_script)


func find_nodes_with_script(root_node : Node, script : Script):
	var nodes_with_script = []
	
	if root_node.get_script() == script:
		nodes_with_script.append(root_node)
	
	for child in root_node.get_children():
		nodes_with_script.append_array(find_nodes_with_script(child, script))
	
	return nodes_with_script
