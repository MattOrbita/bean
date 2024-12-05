extends Node2D


var can_place : bool
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
	check_proximity()


# this node literally follows the mouse cursor
func follow_mouse():
	global_position = get_global_mouse_position()


# a raycast the length of place_proximity is pointed from this node to the player;
# this is so that we can check the proximity of the cursor to the player
# INDEPENDENT of the player's size
func point_raycast_to_player():
	if player == null:
		player = game_manager.player
	
	var direction = player.global_position - global_position
	var new_target_pos = direction.normalized() * place_proximity
	
	raycast.target_position = new_target_pos
# if we only check the difference between the cursor's position and the player's position,
# getting the player's position returns the center of the player; as such, if the player
# gets large enough, then you'll only be able to place inside of the player, and you won't
# even be able to see what you're placing


# if the raycast is hitting the player's hit box, which matches the player's sprite size,
# then we consider that close enough to place towers
func check_proximity():
	can_place = (raycast.get_collider() != null)
