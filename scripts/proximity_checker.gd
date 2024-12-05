extends Node2D


var place_proximity = 200
@onready var raycast : RayCast2D = $RayCast2D

var player : Node2D = null
var game_manager


func _ready() -> void:
	get_game_manager()


func get_game_manager():
	var level_node = $"/root".get_child(0)
	game_manager = level_node.get_node("Game Manager")


func _process(delta: float) -> void:
	follow_mouse()
	point_raycast_to_player()
	
	if raycast.get_collider() == player:
		print('Player is within proximity')


func follow_mouse():
	global_position = get_global_mouse_position()


func point_raycast_to_player():
	if player == null:
		player = game_manager.player
	
	var direction = player.global_position - global_position
	var new_target_pos = direction.normalized() * place_proximity
	
	raycast.target_position = new_target_pos
