extends Area2D


var speed = 20
var damage = 10 #50

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


func _on_body_entered(body: Node2D) -> void:
	if body == target:
		target.take_damage(damage)
		queue_free()
