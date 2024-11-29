extends CharacterBody2D

var move_speed = 150
var direction = Vector2(0,0)
var touching_walls = []

func _ready():
	randomize()
	
func random_direction():
	return Vector2(1,0).rotated(randf_range(-PI, PI))

func _process(delta: float) -> void:
	velocity = direction * move_speed
	move_and_slide()


func _on_timer_timeout():
	direction = random_direction()
	for wall in touching_walls:
		if wall is Wall and wall != null:
			wall.hit()


func _on_area_2d_body_entered(body):
	touching_walls.append(body)
		

func _on_area_2d_body_exited(body):
	touching_walls.erase(body)


func take_damage(damage):
	pass
	#health -= damage
	#if health <= 0:
		#queue_free()
