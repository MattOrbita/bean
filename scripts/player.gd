extends CharacterBody2D


var move_speed = 500
var action_distance = 200

@onready var raycast = $RayCast2D


func _process(delta: float) -> void:
	move()
	point_raycast_to_cursor()


func move():
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	velocity = direction * move_speed
	move_and_slide()


func point_raycast_to_cursor():
	var direction = get_global_mouse_position() - position
	direction = direction.normalized()
	
	raycast.target_position = direction * action_distance


func get_pointing_to():
	return raycast.get_collider()
