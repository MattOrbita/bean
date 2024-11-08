extends Area2D


var scale_step = Vector2(0.1, 0.1)
var max_scale = Vector2(2, 2)

var enemies = []

# TODO figure out how to properly initialize vars below
@onready var player = $"../Player"


func _on_body_entered(body: Node2D) -> void:
	enemies.append(body)
	body.make_slow()


func _on_body_exited(body: Node2D) -> void:
	body.make_fast()
	enemies.erase(body)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("action") and player.get_pointing_to() == self:
		feed_tower()


func feed_tower():
	scale += scale_step
	scale = scale.clamp(Vector2(0, 0), max_scale)
