extends Area2D


var speed = 20
var target : Node2D


func _process(delta: float) -> void:
	face_target()
	pursue_target()


func face_target():
	if target != null:
		look_at(target.position)


func pursue_target():
	if target != null:
		var move_vector = (target.position - position).normalized() * speed
		position += move_vector
