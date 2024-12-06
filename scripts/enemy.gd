extends CharacterBody2D


var health = 50 #100
var move_speed # TODO delete

var min_speed = 250
var max_speed = 500


# TODO delete
func _ready() -> void:
	move_speed = max_speed


# TODO delete
func _process(delta: float) -> void:
	var direction = Input.get_vector('left', 'right', 'up', 'down')
	velocity = direction * move_speed
	move_and_slide()


# TODO delete
func make_slow():
	move_speed = min_speed


# TODO delete
func make_fast():
	move_speed = max_speed


func take_damage(damage):
	print('Health before: ' + str(health))
	
	health -= damage
	if health <= 0:
		queue_free()
	
	print('Health after: ' + str(health))
