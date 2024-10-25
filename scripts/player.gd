extends CharacterBody2D

var move_speed = 500


func _process(delta: float) -> void:
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	velocity = direction * move_speed
	move_and_slide()
	#comment test
