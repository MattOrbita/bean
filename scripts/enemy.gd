extends CharacterBody2D


var health = 100

var move_speed = 500 # TODO delete

# TODO delete
func _process(delta: float) -> void:
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	velocity = direction * move_speed
	move_and_slide()


func take_damage(damage):
	health -= damage
	if health < 0:
		queue_free()
